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

  WaliSantriNotificationService(this._firestore, this._prefs);

  String _readPrefsKey(String uid) => 'read_notifications_$uid';

  Set<String> getReadNotificationIds(String uid) {
    final list = _prefs.getStringList(_readPrefsKey(uid)) ?? [];
    return list.toSet();
  }

  Future<void> markAllAsRead(String uid, List<String> notificationIds) async {
    final existing = getReadNotificationIds(uid);
    existing.addAll(notificationIds);
    await _prefs.setStringList(_readPrefsKey(uid), existing.toList());
  }

  Future<void> markAsRead(String uid, String notificationId) async {
    final existing = getReadNotificationIds(uid);
    existing.add(notificationId);
    await _prefs.setStringList(_readPrefsKey(uid), existing.toList());
  }

  /// Streams combined and sorted real notifications for a specific [santriId].
  Stream<List<WaliSantriNotificationItem>> watchNotificationsForSantri(
    String santriId,
    String uid,
  ) {
    late StreamController<List<WaliSantriNotificationItem>> controller;
    StreamSubscription? absensiSub;
    StreamSubscription? hafalanSub;

    List<WaliSantriNotificationItem> absensiItems = [];
    List<WaliSantriNotificationItem> hafalanItems = [];

    void emitMerged() {
      if (controller.isClosed) return;
      final readIds = getReadNotificationIds(uid);

      final merged = [...absensiItems, ...hafalanItems];
      merged.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      for (var item in merged) {
        item.isRead = readIds.contains(item.id);
      }

      controller.add(merged);
    }

    controller = StreamController<List<WaliSantriNotificationItem>>.broadcast(
      onListen: () {
        // ── 1. Absensi query stream ──────────────────────────────────────────
        // Query recent attendance sessions
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
                final status = (matchingRecord['status'] ?? 'Hadir').toString();
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
            // Non-fatal fallback
            emitMerged();
          },
        );

        // ── 2. Hafalan query stream ──────────────────────────────────────────
        // Query recent memorization records for this student
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
            // Non-fatal fallback
            emitMerged();
          },
        );
      },
      onCancel: () {
        absensiSub?.cancel();
        hafalanSub?.cancel();
      },
    );

    return controller.stream;
  }
}
