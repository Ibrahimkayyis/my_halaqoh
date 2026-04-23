import 'package:freezed_annotation/freezed_annotation.dart';

part 'latest_setoran_item.freezed.dart';

/// Lightweight model for the "Setoran Terakhir" list on the dashboard.
/// Combines data from [HafalanSantriModel] with the student's name
/// resolved from [SantriCubit].
@freezed
abstract class LatestSetoranItem with _$LatestSetoranItem {
  const factory LatestSetoranItem({
    /// Student full name (resolved from SantriCubit)
    required String santriName,

    /// Surah info string, e.g. "Al-Mulk 1 - 9"
    required String surahInfo,

    /// Kelancaran score
    required int score,
  }) = _LatestSetoranItem;
}
