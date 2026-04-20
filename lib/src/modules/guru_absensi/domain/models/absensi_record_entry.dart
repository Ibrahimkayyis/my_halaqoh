import 'package:freezed_annotation/freezed_annotation.dart';

part 'absensi_record_entry.freezed.dart';
part 'absensi_record_entry.g.dart';

/// A single student's attendance status within an attendance session.
@freezed
abstract class AbsensiRecordEntry with _$AbsensiRecordEntry {
  const factory AbsensiRecordEntry({
    /// Firestore document ID of the santri
    required String santriId,

    /// NIS — unique student identifier
    required String nis,

    /// Student full name (denormalized for offline display)
    required String nama,

    /// Attendance status: 'hadir', 'sakit', 'izin', 'alfa'
    required String status,
  }) = _AbsensiRecordEntry;

  factory AbsensiRecordEntry.fromJson(Map<String, dynamic> json) =>
      _$AbsensiRecordEntryFromJson(json);
}
