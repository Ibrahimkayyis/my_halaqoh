import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_absensi_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_hafalan_halaqoh_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/hafalan_halaqoh_pdf_builder.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id', null);
    LocaleSettings.setLocale(AppLocale.id);
  });

  group('HafalanHalaqohPdfBuilder Tests', () {
    test('build generates valid PDF bytes without assertions or errors', () async {
      final config = LaporanHafalanHalaqohConfig(
        halaqohName: 'Halaqoh Abu Bakar',
        guruNama: 'Ust. Ahmad Fauzi',
        kelas: '7A',
        range: ReportRange.monthly,
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 31),
      );

      final santri1 = SantriModel(
        id: 's1',
        nama: 'Muhammad Wildan',
        nis: '1001',
        kelas: '7A',
        program: 'R',
        halaqohId: 'h1',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      final santri2 = SantriModel(
        id: 's2',
        nama: 'Ahmad Dahlan',
        nis: '1002',
        kelas: '7A',
        program: 'R',
        halaqohId: 'h1',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      final records1 = [
        HafalanSantriModel(
          id: 'r1',
          santriId: 's1',
          guruId: 'g1',
          halaqohId: 'h1',
          surahId: 1,
          surahName: 'Al-Fatihah',
          juz: 1,
          ayatMulai: 1,
          ayatSelesai: 7,
          jenis: 'Ziyadah',
          nilaiKelancaran: 90,
          nilaiTajwid: 85,
          tanggalSetoran: DateTime(2026, 8, 10),
          createdAt: DateTime(2026, 8, 10),
        ),
      ];

      final Map<String, List<HafalanSantriModel>> recordsBySantriId = {
        's1': records1,
        's2': <HafalanSantriModel>[],
      };

      final pdfBytes = await HafalanHalaqohPdfBuilder.build(
        config,
        [santri1, santri2],
        recordsBySantriId,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      // PDF documents always begin with the %PDF magic byte header
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
