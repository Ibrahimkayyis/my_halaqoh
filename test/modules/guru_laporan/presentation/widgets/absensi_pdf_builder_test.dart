import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_record_entry.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/models/laporan_absensi_config.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/absensi_pdf_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id', null);
    LocaleSettings.setLocale(AppLocale.id);
  });

  group('AbsensiPdfBuilder Tests', () {
    test('build generates valid PDF bytes for individual attendance report', () async {
      final config = LaporanAbsensiConfig(
        santriName: 'Muhammad Wildan',
        santriNis: '1001',
        programType: 'reguler',
        halaqohName: 'Halaqoh Abu Bakar',
        guruNama: 'Ust. Ahmad Fauzi',
        range: ReportRange.monthly,
        startDate: DateTime(2026, 8, 1),
        endDate: DateTime(2026, 8, 7),
      );

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

      final pdfBytes = await AbsensiPdfBuilder.build(config, records);

      expect(pdfBytes, isNotNull);
      expect(pdfBytes.isNotEmpty, isTrue);
      expect(pdfBytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
    });
  });
}
