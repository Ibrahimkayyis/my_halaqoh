import 'package:my_halaqoh/src/modules/master_data/domain/helpers/curriculum_data.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';

// ── Empty state reason ────────────────────────────────────────────────────────

/// Describes why a santri currently has no juz hafalan targets.
enum EmptyTargetKind {
  /// Admin hasn't configured the target record at all (no Firestore doc).
  noAdminConfig,

  /// Admin set semesterAktif but the curriculum for that semester has no juz
  /// because it's I'dad Tahsin (preparation / reading correction).
  idadTahsin,

  /// Admin set semesterAktif but the curriculum for that semester has no juz
  /// because it's Dauroh (intensive camp).
  dauroh,

  /// Admin set semesterAktif but the curriculum for that semester has no juz
  /// because it's UAT (Ujian Akhir Tahfidz — final exam, no new targets).
  uat,

  /// semesterAktif is set but the kelas/program lookup returns no curriculum
  /// data (e.g. kelas string mismatch or future class not yet defined).
  unknownCurriculum,
}

/// Structured reason returned by [TargetHafalanHelper.getEmptyStateReason].
class EmptyTargetReason {
  final EmptyTargetKind kind;

  /// Short label shown as heading, e.g. "I'dad Tahsin".
  final String label;

  /// Longer explanation shown as body text.
  final String description;

  const EmptyTargetReason({
    required this.kind,
    required this.label,
    required this.description,
  });
}


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

  static double getTargetJuzCountDouble(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    if (targetModel == null || targetModel.semesterAktif == null) {
      return 0.0;
    }
    final program = programCodeToFullName(programCode);
    final semesterAktif = targetModel.semesterAktif!;

    int targetKls = int.tryParse(kelas) ?? 7;
    int startKls = targetKls <= 9 ? 7 : 10;

    double totalWeight = 0.0;

    for (int k = startKls; k <= targetKls; k++) {
      final kStr = k.toString();
      final kurikulum = CurriculumData.getKurikulum(kStr, program);
      if (kurikulum == null) continue;

      if (k < targetKls) {
        totalWeight += _getSemesterWeight(kurikulum.semester1);
        totalWeight += _getSemesterWeight(kurikulum.semester2);
      } else {
        totalWeight += _getSemesterWeight(kurikulum.semester1);
        if (semesterAktif == 2) {
          totalWeight += _getSemesterWeight(kurikulum.semester2);
        }
      }
    }

    return totalWeight;
  }

  static double _getSemesterWeight(SemesterTarget semester) {
    return _getPeriodeWeight(semester.uts) + _getPeriodeWeight(semester.uas);
  }

  static double _getPeriodeWeight(PeriodeTarget periode) {
    if (periode.tipe != TipeHafalan.ziyadah) {
      return 0.0;
    }

    if (periode.fraksi != null) {
      final clean = periode.fraksi!.replaceAll(' Juz', '').trim();
      if (clean == '½') return 0.5;
      if (clean == '¾') return 0.75;
      if (clean == '¼') return 0.25;

      final parts = clean.split('/');
      if (parts.length == 2) {
        final num = double.tryParse(parts[0]);
        final den = double.tryParse(parts[1]);
        if (num != null && den != null && den != 0) {
          return num / den;
        }
      }
      final parsed = double.tryParse(clean);
      if (parsed != null) return parsed;
    }

    return periode.juzList.length.toDouble();
  }

  /// Returns the cumulative list of target juz up to the active semester.
  /// Returns empty list if semester is not set (e.g. "Belum ditetapkan").
  static List<int> getTargetJuzList(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    if (targetModel == null || targetModel.semesterAktif == null) {
      return const [];
    }
    final program = programCodeToFullName(programCode);
    final semAktif = targetModel.semesterAktif!;
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

  // ── Empty state diagnostics ───────────────────────────────────────────────

  /// Returns an [EmptyTargetReason] describing WHY there are currently no juz
  /// targets for this santri — useful for showing a contextual empty state UI.
  ///
  /// Call this ONLY when [getTargetJuzList] returns an empty list.
  static EmptyTargetReason getEmptyStateReason({
    required TargetHafalanModel? target,
    required String? kelas,
    required String? programCode,
  }) {
    // Case 1: no admin config record at all
    if (target == null || kelas == null || programCode == null) {
      return const EmptyTargetReason(
        kind: EmptyTargetKind.noAdminConfig,
        label: 'Target Belum Dikonfigurasi',
        description:
            'Admin belum menetapkan target hafalan untuk kelas dan program ini. '
            'Silakan hubungi admin untuk mengatur target.',
      );
    }

    // Case 2: admin hasn't chosen a semester yet
    if (target.semesterAktif == null) {
      return const EmptyTargetReason(
        kind: EmptyTargetKind.noAdminConfig,
        label: 'Semester Aktif Belum Dipilih',
        description:
            'Admin belum memilih semester aktif. '
            'Target hafalan akan muncul setelah admin menentukan semester yang sedang berjalan.',
      );
    }

    final fullProgram = programCodeToFullName(programCode);
    final sem =
        CurriculumData.getSemesterTarget(kelas, fullProgram, target.semesterAktif!);

    // Case 3: curriculum not found (unknown kelas/program combination)
    if (sem == null) {
      return const EmptyTargetReason(
        kind: EmptyTargetKind.unknownCurriculum,
        label: 'Kurikulum Tidak Ditemukan',
        description:
            'Data kurikulum untuk kelas dan program ini belum tersedia. '
            'Hubungi pengembang aplikasi jika masalah ini terus berlanjut.',
      );
    }

    // Check what type the active semester periods are
    final utsType = sem.uts.tipe;
    final uasType = sem.uas.tipe;

    // If both periods are idadTahsin
    if (utsType == TipeHafalan.idadTahsin || uasType == TipeHafalan.idadTahsin) {
      return EmptyTargetReason(
        kind: EmptyTargetKind.idadTahsin,
        label: "I'dad Tahsin",
        description:
            "Semester ${target.semesterAktif} ini adalah periode I'dad Tahsin — "
            "masa persiapan dan perbaikan bacaan Al-Qur'an. "
            "Belum ada target hafalan juz baru pada periode ini. "
            "Guru dapat menambahkan target juz secara manual jika santri sudah siap.",
      );
    }

    // If both periods are dauroh
    if (utsType == TipeHafalan.dauroh || uasType == TipeHafalan.dauroh) {
      return EmptyTargetReason(
        kind: EmptyTargetKind.dauroh,
        label: 'Dauroh',
        description:
            'Semester ${target.semesterAktif} ini adalah periode Dauroh — '
            'program hafalan intensif kilat. '
            'Target juz belum ditetapkan secara individual pada periode ini. '
            'Guru dapat menambahkan target juz secara manual setelah Dauroh selesai.',
      );
    }

    // If both periods are UAT
    if (utsType == TipeHafalan.uat && uasType == TipeHafalan.uat) {
      return const EmptyTargetReason(
        kind: EmptyTargetKind.uat,
        label: 'UAT — Ujian Akhir Tahfidz',
        description:
            'Semester ini adalah periode Ujian Akhir Tahfidz (UAT). '
            'Tidak ada target hafalan baru — santri sedang dalam tahap ujian keseluruhan hafalan.',
      );
    }

    // Fallback (juz list is empty for an unexpected reason)
    return const EmptyTargetReason(
      kind: EmptyTargetKind.noAdminConfig,
      label: 'Belum Ada Target Hafalan',
      description:
          'Belum ada target hafalan yang ditetapkan untuk semester ini.',
    );
  }

  // ── Target ranges for a specific Juz ───────────────────────────────────────

  static List<TargetAyatRange> getTargetRangesForJuz({
    required int juzNumber,
    required TargetHafalanModel? target,
    required String? kelas,
    required String? programCode,
    required List<int> extraJuz,
  }) {
    if (extraJuz.contains(juzNumber)) {
      return _fullJuzRanges(juzNumber);
    }

    final adminJuzList = target != null && kelas != null && programCode != null
        ? getTargetJuzList(target, kelas, programCode)
        : <int>[];

    if (!adminJuzList.contains(juzNumber)) {
      return _fullJuzRanges(juzNumber);
    }

    final cumulative = getCumulativeTargetAyatRanges(target, kelas ?? '7', programCode ?? 'R');
    final juz = QuranService.instance.getJuzByNumber(juzNumber);
    if (juz == null) return const [];

    final result = <TargetAyatRange>[];
    for (final seg in juz.surahs) {
      final matches = cumulative.where((r) => r.surahId == seg.surahId).toList();
      if (matches.isNotEmpty) {
        int? minStart;
        int? maxEnd;
        for (final r in matches) {
          final start = r.ayatStart > seg.ayatStart ? r.ayatStart : seg.ayatStart;
          final end = r.ayatEnd < seg.ayatEnd ? r.ayatEnd : seg.ayatEnd;
          if (start <= end) {
            if (minStart == null || start < minStart) minStart = start;
            if (maxEnd == null || end > maxEnd) maxEnd = end;
          }
        }
        if (minStart != null && maxEnd != null) {
          result.add(TargetAyatRange(
            surahId: seg.surahId,
            ayatStart: minStart,
            ayatEnd: maxEnd,
          ));
        }
      }
    }

    return result;
  }

  static Map<String, int> getJuzProgressStats({
    required int juzNumber,
    required TargetHafalanModel? target,
    required String? kelas,
    required String? programCode,
    required List<int> extraJuz,
    required JuzProgress? juzProgress,
  }) {
    final targetRanges = getTargetRangesForJuz(
      juzNumber: juzNumber,
      target: target,
      kelas: kelas,
      programCode: programCode,
      extraJuz: extraJuz,
    );

    int totalTargetAyat = 0;
    int completedTargetAyat = 0;

    final juz = QuranService.instance.getJuzByNumber(juzNumber);
    if (juz == null) {
      return {'total': 0, 'completed': 0};
    }

    for (final seg in juz.surahs) {
      final match = targetRanges.where((r) => r.surahId == seg.surahId).firstOrNull;
      if (match != null) {
        final targetCount = match.ayatEnd - match.ayatStart + 1;
        totalTargetAyat += targetCount;

        if (juzProgress != null) {
          final sp = juzProgress.surahProgressList
              .where((s) => s.surahId == seg.surahId)
              .firstOrNull;
          if (sp != null) {
            final memorizedLimit = seg.ayatStart + sp.memorizedAyat - 1;
            if (sp.memorizedAyat > 0) {
              final start = match.ayatStart > seg.ayatStart ? match.ayatStart : seg.ayatStart;
              final end = match.ayatEnd < memorizedLimit ? match.ayatEnd : memorizedLimit;
              if (start <= end) {
                completedTargetAyat += (end - start + 1);
              }
            }
          }
        }
      }
    }

    return {
      'total': totalTargetAyat,
      'completed': completedTargetAyat,
    };
  }

  static double getCompletedJuzCountDouble({
    required TargetHafalanModel? targetModel,
    required String kelas,
    required String programCode,
    required OverallHafalanProgress? progressData,
  }) {
    if (targetModel == null || targetModel.semesterAktif == null || progressData == null) {
      return 0.0;
    }
    final program = programCodeToFullName(programCode);
    final semesterAktif = targetModel.semesterAktif!;

    int targetKls = int.tryParse(kelas) ?? 7;
    int startKls = targetKls <= 9 ? 7 : 10;

    double completedWeight = 0.0;

    for (int k = startKls; k <= targetKls; k++) {
      final kStr = k.toString();
      final kurikulum = CurriculumData.getKurikulum(kStr, program);
      if (kurikulum == null) continue;

      if (k < targetKls) {
        completedWeight += _getSemesterCompletedWeight(kStr, program, 1, progressData);
        completedWeight += _getSemesterCompletedWeight(kStr, program, 2, progressData);
      } else {
        completedWeight += _getSemesterCompletedWeight(kStr, program, 1, progressData);
        if (semesterAktif == 2) {
          completedWeight += _getSemesterCompletedWeight(kStr, program, 2, progressData);
        }
      }
    }

    return completedWeight;
  }

  static double _getSemesterCompletedWeight(
    String kelas,
    String program,
    int semester,
    OverallHafalanProgress progressData,
  ) {
    return _getPeriodeCompletedWeight(kelas, program, semester, true, progressData) +
        _getPeriodeCompletedWeight(kelas, program, semester, false, progressData);
  }

  static double _getPeriodeCompletedWeight(
    String kelas,
    String program,
    int semester,
    bool isUts,
    OverallHafalanProgress progressData,
  ) {
    final cleanKelas = kelas.trim();
    final cleanProgram = program.trim();

    double weight = 0.0;
    final semTarget = CurriculumData.getSemesterTarget(cleanKelas, cleanProgram, semester);
    if (semTarget == null) return 0.0;
    final periode = isUts ? semTarget.uts : semTarget.uas;

    if (periode.tipe != TipeHafalan.ziyadah) {
      return 0.0;
    }

    if (periode.fraksi != null) {
      final clean = periode.fraksi!.replaceAll(' Juz', '').trim();
      if (clean == '½') {
        weight = 0.5;
      } else if (clean == '¾') {
        weight = 0.75;
      } else if (clean == '¼') {
        weight = 0.25;
      } else {
        final parts = clean.split('/');
        if (parts.length == 2) {
          final num = double.tryParse(parts[0]);
          final den = double.tryParse(parts[1]);
          if (num != null && den != null && den != 0) {
            weight = num / den;
          }
        } else {
          weight = double.tryParse(clean) ?? 1.0;
        }
      }
    } else {
      weight = periode.juzList.length.toDouble();
    }

    final ranges = _getPeriodeRanges(cleanKelas, cleanProgram, semester, isUts);
    final fraction = getCompletedFractionForRanges(ranges, progressData);

    return weight * fraction;
  }

  static double getCompletedFractionForRanges(
    List<TargetAyatRange> ranges,
    OverallHafalanProgress progressData,
  ) {
    if (ranges.isEmpty) return 0.0;
    int totalTarget = 0;
    int totalCompleted = 0;

    for (final r in ranges) {
      final count = r.ayatEnd - r.ayatStart + 1;
      totalTarget += count;

      final juz = QuranService.instance.getAllJuz().where((j) => j.surahs.any((s) => s.surahId == r.surahId)).firstOrNull;
      if (juz != null) {
        final jp = progressData.juzProgressList.where((j) => j.juzNumber == juz.number).firstOrNull;
        if (jp != null) {
          final sp = jp.surahProgressList.where((s) => s.surahId == r.surahId).firstOrNull;
          if (sp != null) {
            final seg = QuranService.instance.getSurahById(r.surahId)?.segmentForJuz(juz.number);
            if (seg != null) {
              final memorizedLimit = seg.ayatStart + sp.memorizedAyat - 1;
              if (sp.memorizedAyat > 0) {
                final start = r.ayatStart > seg.ayatStart ? r.ayatStart : seg.ayatStart;
                final end = r.ayatEnd < memorizedLimit ? r.ayatEnd : memorizedLimit;
                if (start <= end) {
                  totalCompleted += (end - start + 1);
                }
              }
            }
          }
        }
      }
    }

    if (totalTarget == 0) return 0.0;
    return totalCompleted / totalTarget;
  }

  static List<TargetAyatRange> getCumulativeTargetAyatRanges(
    TargetHafalanModel? targetModel,
    String kelas,
    String programCode,
  ) {
    if (targetModel == null || targetModel.semesterAktif == null) {
      return const [];
    }
    final program = programCodeToFullName(programCode);
    final semesterAktif = targetModel.semesterAktif!;

    int targetKls = int.tryParse(kelas) ?? 7;
    int startKls = targetKls <= 9 ? 7 : 10;

    final ranges = <TargetAyatRange>[];

    for (int k = startKls; k <= targetKls; k++) {
      final kStr = k.toString();
      if (k < targetKls) {
        ranges.addAll(_getSemesterRanges(kStr, program, 1));
        ranges.addAll(_getSemesterRanges(kStr, program, 2));
      } else {
        ranges.addAll(_getSemesterRanges(kStr, program, 1));
        if (semesterAktif == 2) {
          ranges.addAll(_getSemesterRanges(kStr, program, 2));
        }
      }
    }

    return ranges;
  }

  static List<TargetAyatRange> _getSemesterRanges(
    String kelas,
    String program,
    int semester,
  ) {
    return [
      ..._getPeriodeRanges(kelas, program, semester, true),
      ..._getPeriodeRanges(kelas, program, semester, false),
    ];
  }

  static List<TargetAyatRange> _getPeriodeRanges(
    String kelas,
    String program,
    int semester,
    bool isUts,
  ) {
    final cleanKelas = kelas.trim();
    final cleanProgram = program.trim();

    if (cleanProgram == 'Reguler') {
      if (cleanKelas == '7' || cleanKelas == '10') {
        if (semester == 2) {
          if (isUts) {
            return [
              for (int s = 78; s <= 87; s++) _fullSurahRange(s),
            ];
          } else {
            return [
              for (int s = 88; s <= 114; s++) _fullSurahRange(s),
            ];
          }
        }
      } else if (cleanKelas == '8' || cleanKelas == '11') {
        if (semester == 1) {
          if (isUts) {
            final list = <TargetAyatRange>[];
            for (int s = 67; s <= 73; s++) {
              list.add(_fullSurahRange(s));
            }
            list.add(const TargetAyatRange(surahId: 74, ayatStart: 1, ayatEnd: 47));
            return list;
          } else {
            final list = <TargetAyatRange>[];
            list.add(const TargetAyatRange(surahId: 74, ayatStart: 48, ayatEnd: 56));
            for (int s = 75; s <= 77; s++) {
              list.add(_fullSurahRange(s));
            }
            for (int s = 58; s <= 60; s++) {
              list.add(_fullSurahRange(s));
            }
            list.add(const TargetAyatRange(surahId: 61, ayatStart: 1, ayatEnd: 5));
            return list;
          }
        } else if (semester == 2) {
          if (isUts) {
            final list = <TargetAyatRange>[];
            list.add(const TargetAyatRange(surahId: 61, ayatStart: 6, ayatEnd: 14));
            for (int s = 62; s <= 66; s++) {
              list.add(_fullSurahRange(s));
            }
            list.add(const TargetAyatRange(surahId: 2, ayatStart: 1, ayatEnd: 37));
            return list;
          } else {
            return [
              const TargetAyatRange(surahId: 2, ayatStart: 38, ayatEnd: 141),
            ];
          }
        }
      } else if (cleanKelas == '9' || cleanKelas == '12') {
        if (semester == 1) {
          if (isUts) {
            return [
              const TargetAyatRange(surahId: 2, ayatStart: 142, ayatEnd: 202),
            ];
          } else {
            return [
              const TargetAyatRange(surahId: 2, ayatStart: 203, ayatEnd: 252),
            ];
          }
        } else if (semester == 2) {
          final list = <TargetAyatRange>[];
          list.add(const TargetAyatRange(surahId: 2, ayatStart: 1, ayatEnd: 141));
          list.add(const TargetAyatRange(surahId: 2, ayatStart: 142, ayatEnd: 252));
          for (int s = 58; s <= 66; s++) {
            list.add(_fullSurahRange(s));
          }
          for (int s = 67; s <= 77; s++) {
            list.add(_fullSurahRange(s));
          }
          for (int s = 78; s <= 114; s++) {
            list.add(_fullSurahRange(s));
          }
          return list;
        }
      }
    } else if (cleanProgram == 'Takhassus') {
      final semTarget = CurriculumData.getSemesterTarget(cleanKelas, cleanProgram, semester);
      if (semTarget != null) {
        final list = isUts ? semTarget.uts.juzList : semTarget.uas.juzList;
        final res = <TargetAyatRange>[];
        for (final j in list) {
          res.addAll(_fullJuzRanges(j));
        }
        return res;
      }
    }

    return const [];
  }

  static TargetAyatRange _fullSurahRange(int surahId) {
    final surah = QuranService.instance.getSurahById(surahId);
    return TargetAyatRange(
      surahId: surahId,
      ayatStart: 1,
      ayatEnd: surah?.ayatCount ?? 286,
    );
  }

  static List<TargetAyatRange> _fullJuzRanges(int juzNumber) {
    final juz = QuranService.instance.getJuzByNumber(juzNumber);
    if (juz == null) return const [];
    return juz.surahs.map((seg) => TargetAyatRange(
      surahId: seg.surahId,
      ayatStart: seg.ayatStart,
      ayatEnd: seg.ayatEnd,
    )).toList();
  }
}

class TargetAyatRange {
  final int surahId;
  final int ayatStart;
  final int ayatEnd;

  const TargetAyatRange({
    required this.surahId,
    required this.ayatStart,
    required this.ayatEnd,
  });
}
