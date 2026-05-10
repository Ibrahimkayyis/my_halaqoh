import 'package:my_halaqoh/src/modules/master_data/domain/helpers/curriculum_data.dart';
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

  // ── Display helpers ───────────────────────────────────────────────────────

  /// Returns a short summary string for the active semester target, suitable
  /// for display in Guru / Wali Santri screens.
  ///
  /// Examples:
  ///   - "Sem 2 · Juz 29, 30 (2 Juz)"
  ///   - "Sem 1 · I'dad Tahsin"
  ///   - "Sem 1 · UAT"
  ///   - null if no semester is set or kurikulum not found
  static String? getActiveSemesterSummary(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    if (targetModel == null || targetModel.semesterAktif == null) return null;

    final program = programCodeToFullName(programCode);
    final sem = CurriculumData.getSemesterTarget(
      kelas,
      program,
      targetModel.semesterAktif!,
    );
    if (sem == null) return null;

    final semLabel = 'Sem ${targetModel.semesterAktif}';
    final cumulativeJuz = _getCumulativeJuzList(
      kelas,
      program,
      targetModel.semesterAktif!,
    );

    // If there is absolutely no juz target (e.g. Class 7 Sem 1 I'dad Tahsin)
    if (cumulativeJuz.isEmpty) {
      final desc = sem.uts.deskripsi ?? sem.uts.tipe.name;
      return '$semLabel · $desc';
    }
    
    return '$semLabel · ${_formatJuzList(cumulativeJuz)} (${cumulativeJuz.length} Juz)';
  }

  static int getTargetJuzCount(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    return getTargetJuzList(targetModel, kelas, programCode).length;
  }

  /// Returns the cumulative list of target juz up to the active semester.
  /// Falls back to full-year cumulative list for the current class if semester not set.
  static List<int> getTargetJuzList(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    final program = programCodeToFullName(programCode);
    final semAktif = targetModel?.semesterAktif ?? 2; // default to full year (sem 2)
    return _getCumulativeJuzList(kelas, program, semAktif);
  }

  // ── Cumulative calculation logic ──────────────────────────────────────────

  /// Retrieves the accumulated juz targets from the starting class of the educational
  /// level (SMP -> class 7, SMA -> class 10) up to the current [targetKelas] and [semesterAktif].
  static List<int> _getCumulativeJuzList(
    String targetKelas,
    String fullProgram,
    int semesterAktif,
  ) {
    int targetKls = int.tryParse(targetKelas) ?? 7;
    int startKls = targetKls <= 9 ? 7 : 10;
    
    final cumulativeSet = <int>{};
    
    for (int k = startKls; k <= targetKls; k++) {
      final kStr = k.toString();
      final kurikulum = CurriculumData.getKurikulum(kStr, fullProgram);
      if (kurikulum == null) continue;
      
      // If we are looking at a previous class, add BOTH semesters
      if (k < targetKls) {
        cumulativeSet.addAll(kurikulum.semester1.allJuz);
        cumulativeSet.addAll(kurikulum.semester2.allJuz);
      } 
      // If we are looking at the current class, add up to the active semester
      else {
        cumulativeSet.addAll(kurikulum.semester1.allJuz);
        if (semesterAktif == 2) {
          cumulativeSet.addAll(kurikulum.semester2.allJuz);
        }
      }
    }
    
    return cumulativeSet.toList()..sort();
  }

  // ── Private formatting ────────────────────────────────────────────────────

  static String _formatJuzList(List<int> sorted) {
    if (sorted.isEmpty) return '-';
    if (sorted.length == 1) return 'Juz ${sorted.first}';
    final groups = <String>[];
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
