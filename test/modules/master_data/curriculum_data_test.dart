import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/curriculum_data.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

void main() {
  group('Kurikulum Reguler Baru - CurriculumData Model Checks', () {
    test('Kelas 7 & 10 Sem 1: Langsung Ziyadah Juz 30 (bukan I\'dad Tahsin)', () {
      for (final kelas in ['7', '10']) {
        final sem1 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 1);
        expect(sem1, isNotNull);
        expect(sem1!.uts.tipe, TipeHafalan.ziyadah);
        expect(sem1.uts.juzList, [30]);
        expect(sem1.uts.deskripsi, "An-Naba' – Al-A'la");
        expect(sem1.uts.fraksi, '½ Juz');

        expect(sem1.uas.tipe, TipeHafalan.ziyadah);
        expect(sem1.uas.juzList, [30]);
        expect(sem1.uas.deskripsi, 'Al-Ghasyiyah – An-Nas');
        expect(sem1.uas.fraksi, '½ Juz');
      }
    });

    test('Kelas 7 & 10 Sem 2: Ziyadah Juz 29 (Al-Mulk–Nuh & Al-Jin–Al-Mursalat)', () {
      for (final kelas in ['7', '10']) {
        final sem2 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 2);
        expect(sem2, isNotNull);
        expect(sem2!.uts.tipe, TipeHafalan.ziyadah);
        expect(sem2.uts.juzList, [29]);
        expect(sem2.uts.deskripsi, 'Al-Mulk – Nuh');
        expect(sem2.uts.fraksi, '½ Juz');

        expect(sem2.uas.tipe, TipeHafalan.ziyadah);
        expect(sem2.uas.juzList, [29]);
        expect(sem2.uas.deskripsi, 'Al-Jin – Al-Mursalat');
        expect(sem2.uas.fraksi, '½ Juz');
      }
    });

    test('Kelas 8 & 11 Sem 1: Ziyadah Juz 28 (Al-Mujadilah–Ash-Shaff 5 & Ash-Shaff 6–At-Tahrim)', () {
      for (final kelas in ['8', '11']) {
        final sem1 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 1);
        expect(sem1, isNotNull);
        expect(sem1!.uts.tipe, TipeHafalan.ziyadah);
        expect(sem1.uts.juzList, [28]);
        expect(sem1.uts.deskripsi, 'Al-Mujadilah – Ash-Shaff 5');
        expect(sem1.uts.fraksi, '½ Juz');

        expect(sem1.uas.tipe, TipeHafalan.ziyadah);
        expect(sem1.uas.juzList, [28]);
        expect(sem1.uas.deskripsi, 'Ash-Shaff 6 – At-Tahrim');
        expect(sem1.uas.fraksi, '½ Juz');
      }
    });

    test('Kelas 8 & 11 Sem 2: Ziyadah Juz 1 (Al-Baqarah 1-76 & Al-Baqarah 77-141)', () {
      for (final kelas in ['8', '11']) {
        final sem2 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 2);
        expect(sem2, isNotNull);
        expect(sem2!.uts.tipe, TipeHafalan.ziyadah);
        expect(sem2.uts.juzList, [1]);
        expect(sem2.uts.deskripsi, 'Al-Baqarah 1-76');
        expect(sem2.uts.fraksi, '½ Juz');

        expect(sem2.uas.tipe, TipeHafalan.ziyadah);
        expect(sem2.uas.juzList, [1]);
        expect(sem2.uas.deskripsi, 'Al-Baqarah 77-141');
        expect(sem2.uas.fraksi, '½ Juz');
      }
    });

    test('Kelas 9 & 12: Sem 1 Ziyadah Juz 2, Sem 2 Muraja\'ah 5 Juz', () {
      for (final kelas in ['9', '12']) {
        final sem1 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 1);
        expect(sem1, isNotNull);
        expect(sem1!.uts.juzList, [2]);
        expect(sem1.uas.juzList, [2]);

        final sem2 = CurriculumData.getSemesterTarget(kelas, 'Reguler', 2);
        expect(sem2, isNotNull);
        expect(sem2!.uts.tipe, TipeHafalan.murajaah);
        expect(sem2.uts.juzList, [1, 2, 28, 29, 30]);
        expect(sem2.uas.tipe, TipeHafalan.murajaah);
        expect(sem2.uas.juzList, [1, 2, 28, 29, 30]);
      }
    });
  });

  group('Kumulatif Target Juz per Semester (SMP & SMA)', () {
    TargetHafalanModel makeModel(String kelas, int semester) {
      return TargetHafalanModel(
        id: '${kelas}_Reguler',
        kelas: kelas,
        program: 'Reguler',
        semesterAktif: semester,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
    }

    test('SMP Reguler: Kelas 7 Sem 1 = [30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('7', 1), '7', 'R');
      expect(list, [30]);
    });

    test('SMP Reguler: Kelas 7 Sem 2 = [29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('7', 2), '7', 'R');
      expect(list, [29, 30]);
    });

    test('SMP Reguler: Kelas 8 Sem 1 = [28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('8', 1), '8', 'R');
      expect(list, [28, 29, 30]);
    });

    test('SMP Reguler: Kelas 8 Sem 2 = [1, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('8', 2), '8', 'R');
      expect(list, [1, 28, 29, 30]);
    });

    test('SMP Reguler: Kelas 9 Sem 1 = [1, 2, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('9', 1), '9', 'R');
      expect(list, [1, 2, 28, 29, 30]);
    });

    test('SMP Reguler: Kelas 9 Sem 2 = [1, 2, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('9', 2), '9', 'R');
      expect(list, [1, 2, 28, 29, 30]);
    });

    test('SMA Reguler: Kelas 10 Sem 1 = [30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('10', 1), '10', 'R');
      expect(list, [30]);
    });

    test('SMA Reguler: Kelas 10 Sem 2 = [29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('10', 2), '10', 'R');
      expect(list, [29, 30]);
    });

    test('SMA Reguler: Kelas 11 Sem 1 = [28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('11', 1), '11', 'R');
      expect(list, [28, 29, 30]);
    });

    test('SMA Reguler: Kelas 11 Sem 2 = [1, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('11', 2), '11', 'R');
      expect(list, [1, 28, 29, 30]);
    });

    test('SMA Reguler: Kelas 12 Sem 1 = [1, 2, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('12', 1), '12', 'R');
      expect(list, [1, 2, 28, 29, 30]);
    });

    test('SMA Reguler: Kelas 12 Sem 2 = [1, 2, 28, 29, 30]', () {
      final list = TargetHafalanHelper.getTargetJuzList(makeModel('12', 2), '12', 'R');
      expect(list, [1, 2, 28, 29, 30]);
    });
  });

  group('Target Weight Count Calculations', () {
    TargetHafalanModel makeModel(String kelas, int semester) {
      return TargetHafalanModel(
        id: '${kelas}_Reguler',
        kelas: kelas,
        program: 'Reguler',
        semesterAktif: semester,
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
      );
    }

    test('TargetJuzCountDouble bertambah 1.0 per semester sampai 5.0 di akhir', () {
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('7', 1), '7', 'R'), 1.0);
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('7', 2), '7', 'R'), 2.0);
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('8', 1), '8', 'R'), 3.0);
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('8', 2), '8', 'R'), 4.0);
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('9', 1), '9', 'R'), 5.0);
      expect(TargetHafalanHelper.getTargetJuzCountDouble(makeModel('9', 2), '9', 'R'), 5.0);
    });
  });
}
