import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/wali_santri_notification_item.dart';

/// Real-time service for streaming Wali Santri in-app notifications
/// from real Firestore `/absensi` and `/hafalan_santri` collections.
class WaliSantriNotificationService {
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  /// Broadcast signal fired whenever the read-state (SharedPreferences)
  /// changes. All active watch streams listen to this and re-emit merged data
  /// so badges update instantly without waiting for a Firestore snapshot.
  final StreamController<void> _readStateChanges =
      StreamController<void>.broadcast();

  WaliSantriNotificationService(this._firestore, this._prefs);

  /// Notifies every active watch stream that the read-state changed.
  void notifyReadStateChanged() {
    if (!_readStateChanges.isClosed) {
      _readStateChanges.add(null);
    }
  }

  String _readPrefsKey(String uid) => 'read_notifications_$uid';

  Set<String> getReadNotificationIds(String uid) {
    final list = _prefs.getStringList(_readPrefsKey(uid)) ?? [];
    return list.toSet();
  }

  Future<void> markAllAsRead(String uid, List<String> notificationIds) async {
    final existing = getReadNotificationIds(uid);
    existing.addAll(notificationIds);
    await _prefs.setStringList(_readPrefsKey(uid), existing.toList());
    notifyReadStateChanged();
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    final existing = getReadNotificationIds(uid);
    existing.add(notificationId);
    await _prefs.setStringList(_readPrefsKey(uid), existing.toList());
    notifyReadStateChanged();
  }

  /// Streams combined and sorted real notifications for a specific [santriId].
  Stream<List<WaliSantriNotificationItem>> watchNotificationsForSantri(
    String santriId,
    String uid,
  ) {
    late StreamController<List<WaliSantriNotificationItem>> controller;
    StreamSubscription? absensiSub;
    StreamSubscription? hafalanSub;
    StreamSubscription? sertifikasiSub;
    StreamSubscription? readStateSub;

    List<WaliSantriNotificationItem> absensiItems = [];
    List<WaliSantriNotificationItem> hafalanItems = [];
    List<WaliSantriNotificationItem> sertifikasiItems = [];

    void emitMerged() {
      if (controller.isClosed) return;
      final readIds = getReadNotificationIds(uid);

      final merged = [...absensiItems, ...hafalanItems, ...sertifikasiItems];
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      for (var item in merged) {
        item.isRead = readIds.contains(item.id);
      }

      controller.add(merged);
    }

    controller = StreamController<List<WaliSantriNotificationItem>>.broadcast(
      onListen: () {
        // ── 1. Absensi query stream ──────────────────────────────────────────
        absensiSub = _firestore
            .collection('absensi')
            .orderBy('tanggal', descending: true)
            .limit(30)
            .snapshots()
            .listen(
          (snapshot) {
            final List<WaliSantriNotificationItem> items = [];
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final records = data['records'];
              if (records is! List) continue;

              final matchingRecord = records.firstWhere(
                (r) => r is Map && r['santriId'] == santriId,
                orElse: () => null,
              );

              if (matchingRecord != null && matchingRecord is Map) {
                final rawStatus = (matchingRecord['status'] ?? 'hadir').toString();
                if (rawStatus.trim().toLowerCase() == 'belum') continue;

                final status = _formatAbsensiStatus(rawStatus);
                final santriName = (matchingRecord['nama'] ?? 'Santri').toString();
                final sesi = (data['sesi'] ?? 'Sesi').toString();
                final tanggalTs = data['tanggal'] as Timestamp?;
                final date = tanggalTs?.toDate() ?? DateTime.now();

                final formattedDate =
                    DateFormat('d MMM yyyy', 'id_ID').format(date);
                final sesiTitle =
                    sesi.isNotEmpty ? '${sesi[0].toUpperCase()}${sesi.substring(1)}' : sesi;

                items.add(
                  WaliSantriNotificationItem(
                    id: 'absensi_${doc.id}',
                    title: 'Kehadiran: $status',
                    message:
                        'Santri $santriName tercatat $status pada sesi $sesiTitle ($formattedDate).',
                    category: 'absensi',
                    timestamp: date,
                    entityType: 'absensi',
                    entityId: doc.id,
                  ),
                );
              }
            }
            absensiItems = items;
            emitMerged();
          },
          onError: (e) {
            emitMerged();
          },
        );

        // ── 2. Hafalan query stream ──────────────────────────────────────────
        hafalanSub = _firestore
            .collection('hafalan_santri')
            .where('santriId', isEqualTo: santriId)
            .orderBy('tanggalSetoran', descending: true)
            .limit(30)
            .snapshots()
            .listen(
          (snapshot) {
            final List<WaliSantriNotificationItem> items = [];
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final surahName = (data['surahName'] ?? 'Al-Quran').toString();
              final juz = data['juz']?.toString() ?? '-';
              final jenis = (data['jenis'] ?? 'Ziyadah').toString();
              final ayatMulai = data['ayatMulai']?.toString() ?? '1';
              final ayatSelesai = data['ayatSelesai']?.toString() ?? '1';
              final tanggalTs = data['tanggalSetoran'] as Timestamp?;
              final date = tanggalTs?.toDate() ?? DateTime.now();
              final formattedDate =
                  DateFormat('d MMM yyyy', 'id_ID').format(date);

              items.add(
                WaliSantriNotificationItem(
                  id: 'hafalan_${doc.id}',
                  title: 'Setoran: $surahName (Juz $juz)',
                  message:
                      'Santri telah menyetorkan $jenis Surah $surahName ayat $ayatMulai–$ayatSelesai ($formattedDate).',
                  category: 'hafalan',
                  timestamp: date,
                  entityType: 'hafalan',
                  entityId: doc.id,
                ),
              );
            }
            hafalanItems = items;
            emitMerged();
          },
          onError: (e) {
            emitMerged();
          },
        );

        // ── 3. Sertifikasi Tahfidz — multi-stage lifecycle stream ──────────
        // Generates distinct notification events for each lifecycle transition
        // (pending -> scheduled/rejected -> passed/failed) so every status
        // change produces a brand-new unread notification with a unique ID.
        sertifikasiSub = _firestore
            .collection('sertifikasi_tahfidz')
            .where('santriId', isEqualTo: santriId)
            .limit(30)
            .snapshots()
            .listen(
          (snapshot) {
            final List<WaliSantriNotificationItem> items = [];
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final status = (data['status'] ?? 'pending').toString();
              final juz = data['juz']?.toString() ?? '-';
              final santriNama = (data['santriNama'] ?? 'Santri').toString();
              final sesiUjian = (data['sesiUjian'] ?? '').toString();
              final pengujiNama = (data['pengujiNama'] ?? '').toString();
              final alasanPenolakan = (data['alasanPenolakan'] ?? '').toString();
              final nilai = data['nilai'];
              final predikat = (data['predikat'] ?? '').toString();
              final tanggalUjianTs = data['tanggalUjian'] as Timestamp?;
              final updatedAtTs = data['updatedAt'] as Timestamp?;
              final createdAtTs = data['createdAt'] as Timestamp?;
              final completedAtTs = data['completedAt'] as Timestamp?;

              final createdAt = createdAtTs?.toDate() ?? DateTime.now();
              final updatedAt = updatedAtTs?.toDate() ?? createdAt;
              final completedAt = completedAtTs?.toDate() ?? updatedAt;
              final tanggalUjianStr = tanggalUjianTs != null
                  ? DateFormat('d MMM yyyy', 'id_ID').format(tanggalUjianTs.toDate())
                  : '';

              // Stage 1: Submission / Pending Notification
              items.add(
                WaliSantriNotificationItem(
                  id: 'sertifikasi_${doc.id}_pending',
                  title: 'Pengajuan Sertifikasi Juz $juz',
                  message:
                      'Pengajuan ujian sertifikasi Juz $juz untuk ananda $santriNama sedang menunggu persetujuan Waka Tahfidz.',
                  category: 'sertifikasi',
                  timestamp: createdAt,
                  entityType: 'sertifikasi',
                  entityId: doc.id,
                ),
              );

              // Stage 2: Scheduled Notification
              if (status == 'scheduled' || status == 'passed' || status == 'failed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_scheduled',
                    title: 'Ujian Sertifikasi Juz $juz Dijadwalkan',
                    message:
                        'Ujian hafalan Juz $juz dijadwalkan pada $tanggalUjianStr${sesiUjian.isNotEmpty ? ' ($sesiUjian)' : ''}. Penguji: ${pengujiNama.isNotEmpty ? pengujiNama : 'Ustadz Penguji'}.',
                    category: 'sertifikasi',
                    timestamp: status == 'scheduled'
                        ? updatedAt
                        : (tanggalUjianTs?.toDate() ?? updatedAt),
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 2 Alt: Rejected Notification
              if (status == 'rejected') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_rejected',
                    title: 'Pengajuan Sertifikasi Juz $juz Ditolak',
                    message:
                        'Pengajuan ujian sertifikasi Juz $juz untuk ananda $santriNama ditolak: ${alasanPenolakan.isNotEmpty ? alasanPenolakan : '-'}',
                    category: 'sertifikasi',
                    timestamp: updatedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 3: Passed Notification
              if (status == 'passed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_passed',
                    title: 'Alhamdulillah! Lulus Sertifikasi Juz $juz',
                    message:
                        'Ananda $santriNama dinyatakan LULUS Sertifikasi Juz $juz${predikat.isNotEmpty ? ' dengan predikat $predikat' : ''}${nilai != null ? ' (Nilai: $nilai)' : ''}.',
                    category: 'sertifikasi',
                    timestamp: completedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 3 Alt: Failed / Repeat Notification
              if (status == 'failed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_failed',
                    title: 'Hasil Sertifikasi Juz $juz',
                    message:
                        'Ananda $santriNama perlu mengulang ujian sertifikasi Juz $juz${nilai != null ? ' (Nilai: $nilai)' : ''}. Tetap semangat menghafal!',
                    category: 'sertifikasi',
                    timestamp: completedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }
            }
            sertifikasiItems = items;
            emitMerged();
          },
          onError: (e) {
            emitMerged();
          },
        );

        // ── 4. Read-state changes (SharedPreferences) ────────────────────────
        // Re-emit immediately when items are marked read/unread so the badge
        // updates instantly without waiting for a Firestore snapshot change.
        readStateSub = _readStateChanges.stream.listen((_) => emitMerged());
      },
      onCancel: () {
        readStateSub?.cancel();
        absensiSub?.cancel();
        hafalanSub?.cancel();
        sertifikasiSub?.cancel();
      },
    );

    return controller.stream;
  }

  /// Streams real notifications for a specific [guruId] (Sertifikasi updates).
  Stream<List<WaliSantriNotificationItem>> watchNotificationsForGuru(
    String guruId,
    String uid,
  ) {
    late StreamController<List<WaliSantriNotificationItem>> controller;
    StreamSubscription? sertifikasiSub;
    StreamSubscription? readStateSub;
    List<WaliSantriNotificationItem> sertifikasiItems = [];

    void emitMerged() {
      if (controller.isClosed) return;
      final readIds = getReadNotificationIds(uid);

      final merged = [...sertifikasiItems];
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      for (var item in merged) {
        item.isRead = readIds.contains(item.id);
      }

      controller.add(merged);
    }

    controller = StreamController<List<WaliSantriNotificationItem>>.broadcast(
      onListen: () {
        // ── Sertifikasi Tahfidz — multi-stage lifecycle stream ───────────────
        // Generates distinct notification events for each lifecycle transition
        // (pending -> scheduled/rejected -> passed/failed) so every status
        // change produces a brand-new unread notification for the Guru.
        sertifikasiSub = _firestore
            .collection('sertifikasi_tahfidz')
            .where('guruId', isEqualTo: guruId)
            .limit(30)
            .snapshots()
            .listen(
          (snapshot) {
            final List<WaliSantriNotificationItem> items = [];
            for (var doc in snapshot.docs) {
              final data = doc.data();
              final status = (data['status'] ?? 'pending').toString();
              final juz = data['juz']?.toString() ?? '-';
              final santriNama = (data['santriNama'] ?? 'Santri').toString();
              final sesiUjian = (data['sesiUjian'] ?? '').toString();
              final pengujiNama = (data['pengujiNama'] ?? '').toString();
              final alasanPenolakan = (data['alasanPenolakan'] ?? '').toString();
              final nilai = data['nilai'];
              final predikat = (data['predikat'] ?? '').toString();
              final tanggalUjianTs = data['tanggalUjian'] as Timestamp?;
              final updatedAtTs = data['updatedAt'] as Timestamp?;
              final createdAtTs = data['createdAt'] as Timestamp?;
              final completedAtTs = data['completedAt'] as Timestamp?;

              final createdAt = createdAtTs?.toDate() ?? DateTime.now();
              final updatedAt = updatedAtTs?.toDate() ?? createdAt;
              final completedAt = completedAtTs?.toDate() ?? updatedAt;
              final tanggalUjianStr = tanggalUjianTs != null
                  ? DateFormat('d MMM yyyy', 'id_ID').format(tanggalUjianTs.toDate())
                  : '';

              // Stage 1: Submission / Pending Notification (Confirmation for teacher)
              items.add(
                WaliSantriNotificationItem(
                  id: 'sertifikasi_${doc.id}_pending',
                  title: 'Pengajuan Sertifikasi Terkirim',
                  message:
                      'Pengajuan sertifikasi Juz $juz untuk $santriNama sedang menunggu persetujuan Waka Tahfidz.',
                  category: 'sertifikasi',
                  timestamp: createdAt,
                  entityType: 'sertifikasi',
                  entityId: doc.id,
                ),
              );

              // Stage 2: Scheduled Notification
              if (status == 'scheduled' || status == 'passed' || status == 'failed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_scheduled',
                    title: 'Ujian Sertifikasi Juz $juz Dijadwalkan',
                    message:
                        'Ujian sertifikasi Juz $juz untuk $santriNama dijadwalkan pada $tanggalUjianStr${sesiUjian.isNotEmpty ? ' ($sesiUjian)' : ''}. Penguji: ${pengujiNama.isNotEmpty ? pengujiNama : 'Ustadz Penguji'}.',
                    category: 'sertifikasi',
                    timestamp: status == 'scheduled'
                        ? updatedAt
                        : (tanggalUjianTs?.toDate() ?? updatedAt),
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 2 Alt: Rejected Notification
              if (status == 'rejected') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_rejected',
                    title: 'Pengajuan Sertifikasi Juz $juz Ditolak',
                    message:
                        'Pengajuan sertifikasi Juz $juz untuk $santriNama ditolak: ${alasanPenolakan.isNotEmpty ? alasanPenolakan : '-'}',
                    category: 'sertifikasi',
                    timestamp: updatedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 3: Passed Notification
              if (status == 'passed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_passed',
                    title: 'Santri Lulus Sertifikasi Juz $juz',
                    message:
                        '$santriNama dinyatakan LULUS Ujian Sertifikasi Juz $juz${predikat.isNotEmpty ? ' dengan predikat $predikat' : ''}${nilai != null ? ' (Nilai: $nilai)' : ''}.',
                    category: 'sertifikasi',
                    timestamp: completedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }

              // Stage 3 Alt: Failed / Repeat Notification
              if (status == 'failed') {
                items.add(
                  WaliSantriNotificationItem(
                    id: 'sertifikasi_${doc.id}_failed',
                    title: 'Santri Perlu Mengulang Sertifikasi Juz $juz',
                    message:
                        '$santriNama perlu mengulang Ujian Sertifikasi Juz $juz${nilai != null ? ' (Nilai: $nilai)' : ''}. Silakan bimbing kembali.',
                    category: 'sertifikasi',
                    timestamp: completedAt,
                    entityType: 'sertifikasi',
                    entityId: doc.id,
                  ),
                );
              }
            }
            sertifikasiItems = items;
            emitMerged();
          },
          onError: (e) {
            emitMerged();
          },
        );

        // ── Read-state changes (SharedPreferences) ───────────────────────────
        // Re-emit immediately when items are marked read/unread so the badge
        // updates instantly without waiting for a Firestore snapshot change.
        readStateSub = _readStateChanges.stream.listen((_) => emitMerged());
      },
      onCancel: () {
        readStateSub?.cancel();
        sertifikasiSub?.cancel();
      },
    );

    return controller.stream;
  }

  /// Normalizes legacy or raw status strings to standard Indonesian labels ('Hadir', 'Sakit', 'Izin', 'Alfa').
  /// Variants like 'hadir_barcode', 'hadir_manual', 'terlambat' are all unified into 'Hadir'.
  static String _formatAbsensiStatus(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'hadir':
      case 'hadir_barcode':
      case 'hadir_manual':
      case 'terlambat':
        return 'Hadir';
      case 'sakit':
        return 'Sakit';
      case 'izin':
        return 'Izin';
      case 'alfa':
        return 'Alfa';
      default:
        return raw.isNotEmpty
            ? '${raw[0].toUpperCase()}${raw.substring(1)}'
            : raw;
    }
  }
}
