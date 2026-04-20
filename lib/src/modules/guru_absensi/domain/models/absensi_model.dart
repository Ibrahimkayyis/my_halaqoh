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

    /// Session key: 'shubuh', 'dhuha1', 'dhuha2', 'ashar', 'maghrib'
    required String sesi,

    /// Per-student attendance entries
    required List<AbsensiRecordEntry> records,

    /// Whether this record has been synced to Firestore
    @Default(false) bool isSynced,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AbsensiModel;

  factory AbsensiModel.fromJson(Map<String, dynamic> json) =>
      _$AbsensiModelFromJson(json);
}
