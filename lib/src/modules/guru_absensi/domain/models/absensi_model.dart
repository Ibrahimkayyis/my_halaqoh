import 'package:freezed_annotation/freezed_annotation.dart';
import 'absensi_record_entry.dart';

part 'absensi_model.freezed.dart';
part 'absensi_model.g.dart';

/// Domain model for an attendance session.
/// Maps to Firestore collection: `/absensi/{id}`
///
/// One document represents one halaqoh session on one date.
/// The combination of [halaqohId] + [tanggal] + [sesi] is unique.
@freezed
abstract class AbsensiModel with _$AbsensiModel {
  const factory AbsensiModel({
    /// Firestore document ID
    required String id,

    /// Reference to `/halaqoh/{id}`
    required String halaqohId,

    /// Reference to `/guru/{id}` — the teacher who recorded attendance
    required String guruId,

    /// Attendance date (date only, time portion is midnight)
    required DateTime tanggal,

    /// Session key: 'shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'
    required String sesi,

    /// Per-student attendance entries
    required List<AbsensiRecordEntry> records,

    /// Whether this record has been synced to Firestore
    @Default(false) bool isSynced,

    required DateTime createdAt,
    required DateTime updatedAt,

    /// Timestamp set by the Cloud Function after FCM notifications have been
    /// dispatched for this session. Null means not yet notified.
    /// NEVER written by the Flutter client — this is a server-only field.
    @JsonKey(name: 'notifiedAt') DateTime? notifiedAt,
  }) = _AbsensiModel;

  factory AbsensiModel.fromJson(Map<String, dynamic> json) =>
      _$AbsensiModelFromJson(json);
}
