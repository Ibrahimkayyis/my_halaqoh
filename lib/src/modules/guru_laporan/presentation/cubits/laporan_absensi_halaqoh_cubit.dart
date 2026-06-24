import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:printing/printing.dart';

import '../../domain/models/laporan_absensi_halaqoh_config.dart';
import '../../../guru_absensi/domain/models/absensi_model.dart';
import '../../../master_data/domain/models/santri_model.dart';
import '../widgets/absensi_halaqoh_pdf_builder.dart';
import 'laporan_absensi_halaqoh_state.dart';

/// Cubit that orchestrates PDF generation and sharing for halaqoh-wide
/// attendance reports.
///
/// Registered as [registerFactory] — scoped to the
/// [LaporanKonfigurasiHalaqohSheet] bottom sheet lifetime.
///
/// Data flow:
///   UI (sheet) → [generatePdf] → [AbsensiHalaqohPdfBuilder.build] → emit [generated]
///   UI          → [previewPdf] → Printing.layoutPdf (native preview)
///   UI          → [sharePdf]  → share_plus native sheet
class LaporanAbsensiHalaqohCubit extends Cubit<LaporanAbsensiHalaqohState> {
  final _log = Logger();

  LaporanAbsensiHalaqohCubit()
      : super(const LaporanAbsensiHalaqohState.initial());

  /// Builds the PDF bytes from [config], the pre-loaded [allRecords],
  /// and the full [santriList] for the halaqoh.
  ///
  /// All data is already in memory — no Firestore queries are triggered here.
  Future<void> generatePdf(
    LaporanAbsensiHalaqohConfig config,
    List<AbsensiModel> allRecords,
    List<SantriModel> santriList,
  ) async {
    emit(const LaporanAbsensiHalaqohState.generating());
    try {
      final bytes = await AbsensiHalaqohPdfBuilder.build(
        config,
        allRecords,
        santriList,
      );
      emit(LaporanAbsensiHalaqohState.generated(bytes));
    } catch (e, st) {
      _log.e('Halaqoh PDF generation failed', error: e, stackTrace: st);
      emit(
        LaporanAbsensiHalaqohState.error(
          t.laporanConfig.errGenerate(error: e.toString()),
        ),
      );
    }
  }

  /// Opens the native PDF preview via the [printing] package.
  Future<void> previewPdf(Uint8List bytes, String filename) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => bytes,
        name: filename,
      );
    } catch (e, st) {
      _log.e('Halaqoh PDF preview failed', error: e, stackTrace: st);
      emit(
        LaporanAbsensiHalaqohState.error(
          t.laporanConfig.errPreview(error: e.toString()),
        ),
      );
    }
  }

  /// Shares the PDF via the native share sheet.
  Future<void> sharePdf(Uint8List bytes, String filename) async {
    try {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e, st) {
      _log.e('Halaqoh PDF share failed', error: e, stackTrace: st);
      emit(
        LaporanAbsensiHalaqohState.error(
          t.laporanConfig.errShare(error: e.toString()),
        ),
      );
    }
  }

  /// Resets state to initial so the user can generate a new report.
  void reset() => emit(const LaporanAbsensiHalaqohState.initial());
}
