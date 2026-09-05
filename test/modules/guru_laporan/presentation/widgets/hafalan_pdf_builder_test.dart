import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_absensi_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_hafalan_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/hafalan_pdf_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id', null);
    LocaleSettings.setLocale(AppLocale.id);
  });

  group('HafalanPdfBuilder Tests', () {
    test('build generates valid PDF bytes for individual student', () async {
      final config = LaporanHafalanConfig(
        santriName: 'Muhammad Wildan',
        santriId: 's1',
        santriNis: '1001',
        halaqohName: 'Halaqoh Abu Bakar',
        guruNama: 'Ust. Ahmad Fauzi',
        range: ReportRange.monthly,
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 31),
      );

      final records = [
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
        HafalanSantriModel(
          id: 'r2',
          santriId: 's1',
          guruId: 'g1',
          halaqohId: 'h1',
          surahId: 114,
          surahName: 'An-Nas',
          juz: 30,
          ayatMulai: 1,
          ayatSelesai: 6,
          jenis: 'Murajaah',
          nilaiKelancaran: 80,
          nilaiTajwid: 80,
          tanggalSetoran: DateTime(2026, 8, 15),
          createdAt: DateTime(2026, 8, 15),
        ),
      ];

      final pdfBytes = await HafalanPdfBuilder.build(config, records);

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
