import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_absensi_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_absensi_halaqoh_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/absensi_halaqoh_pdf_builder.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id', null);
    LocaleSettings.setLocale(AppLocale.id);
  });

  group('AbsensiHalaqohPdfBuilder Tests', () {
    test('build generates valid PDF bytes for halaqoh-wide attendance recap', () async {
      final config = LaporanAbsensiHalaqohConfig(
        halaqohName: 'Halaqoh Abu Bakar',
        guruNama: 'Ust. Ahmad Fauzi',
        programType: 'reguler',
        range: ReportRange.monthly,
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 7),
      );

      final santriList = [
        SantriModel(
          id: 's1',
          nama: 'Muhammad Wildan',
          nis: '1001',
          kelas: '7A',
          program: 'R',
          halaqohId: 'h1',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 1),
        ),
      ];

      final records = [
        AbsensiModel(
          id: 'a1',
          halaqohId: 'h1',
          guruId: 'g1',
          tanggal: DateTime(2026, 8, 1),
          sesi: 'shubuh',
          records: [
            AbsensiRecordEntry(
              santriId: 's1',
              nis: '1001',
              nama: 'Muhammad Wildan',
              status: 'hadir',
            ),
          ],
          createdAt: DateTime(2026, 8, 1),
          updatedAt: DateTime(2026, 8, 1),
        ),
      ];

      final pdfBytes = await AbsensiHalaqohPdfBuilder.build(
        config,
        records,
        santriList,
      );

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
