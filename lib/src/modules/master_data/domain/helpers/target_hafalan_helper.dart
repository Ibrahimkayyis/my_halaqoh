import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Utility helpers for working with [TargetHafalanModel] across modules.
class TargetHafalanHelper {
  const TargetHafalanHelper._();

  // ── Program code mapping ──────────────────────────────────────────────────

  /// Converts short program code ("R"/"T") → full name ("Reguler"/"Takhassus").
  ///
  /// [SantriModel] and [HalaqohModel] use short codes,
  /// while [TargetHafalanModel] uses full names.
  static String programCodeToFullName(String code) {
    return code == 'T' ? 'Takhassus' : 'Reguler';
  }

  /// Converts full program name → short code.
  static String fullNameToProgramCode(String fullName) {
    return fullName == 'Takhassus' ? 'T' : 'R';
  }

  // ── Target lookup ─────────────────────────────────────────────────────────

  /// Find the [TargetHafalanModel] for a given [kelas] and short [programCode]
  /// ("R" or "T") from a list of targets.
  ///
  /// Returns `null` if no matching target is found.
  static TargetHafalanModel? findTarget(
    List<TargetHafalanModel> targets,
    String kelas,
    String programCode,
  ) {
    final fullProgram = programCodeToFullName(programCode);
    try {
      return targets.firstWhere(
        (t) => t.kelas == kelas && t.program == fullProgram,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Display formatting ────────────────────────────────────────────────────

  /// Format a list of juz numbers into smart range groups.
  ///
  /// Example: `[1, 2, 3, 29, 30]` → `"Juz 1-3, 29-30"`
  static String formatJuzRange(List<int> juzList) {
    if (juzList.isEmpty) return '-';
    final sorted = List<int>.from(juzList)..sort();

    final List<String> groups = [];
    int start = sorted.first;
    int end = sorted.first;

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == end + 1) {
        end = sorted[i];
      } else {
        groups.add(start == end ? '$start' : '$start-$end');
        start = sorted[i];
        end = sorted[i];
      }
    }
    groups.add(start == end ? '$start' : '$start-$end');

    return 'Juz ${groups.join(', ')}';
  }
}
