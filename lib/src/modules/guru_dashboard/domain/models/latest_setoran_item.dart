import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';

part 'latest_setoran_item.freezed.dart';

/// Lightweight model representing a grouped submission in the "Setoran Terakhir" list.
/// Groups multiple [HafalanSantriModel] records that belong to the same submission session.
@freezed
abstract class LatestSetoranItem with _$LatestSetoranItem {
  const LatestSetoranItem._();

  const factory LatestSetoranItem({
    required String santriId,
    required String santriName,
    required DateTime tanggalSetoran,
    required String jenis, // "Ziyadah" or "Murajaah"
    required int nilaiKelancaran,
    required int nilaiTajwid,
    required List<HafalanSantriModel> records,
  }) = _LatestSetoranItem;

  int get avgScore => ((nilaiKelancaran + nilaiTajwid) / 2).round();

  bool get hasMultiple => records.length > 1;

  bool get isZiyadah => jenis.toLowerCase() == 'ziyadah';

  /// Returns a display string for the surah range.
  /// Single surah: "Al-Mulk"
  /// Multiple surahs: "Al-Mulk — An-Nas"
  String get surahDisplay {
    if (records.isEmpty) return '-';
    if (records.length == 1) {
      return records.first.surahName;
    }
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return '${sorted.first.surahName} — ${sorted.last.surahName}';
  }

  /// Returns a subtitle with ayat details or surat count.
  /// Single surah: "Ayat 1 - 30"
  /// Multiple surahs: "3 Surat"
  String get ayatDisplay {
    if (records.isEmpty) return '';
    if (records.length == 1) {
      final r = records.first;
      return 'Ayat ${r.ayatMulai} - ${r.ayatSelesai}';
    }
    return '${records.length} Surat';
  }

  /// Returns detailed per-surah lines for expanded view.
  List<String> get detailLines {
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return sorted
        .map((r) => '${r.surahName} (${r.ayatMulai}-${r.ayatSelesai})')
        .toList();
  }
}
