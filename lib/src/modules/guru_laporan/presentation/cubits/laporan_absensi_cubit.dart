import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:printing/printing.dart';

import '../../domain/models/laporan_absensi_config.dart';
import '../../../guru_absensi/domain/models/absensi_model.dart';
import '../widgets/absensi_pdf_builder.dart';
import 'laporan_absensi_state.dart';

/// Cubit that orchestrates PDF generation and sharing for attendance reports.
///
/// Registered as [registerFactory] — scoped to the [LaporanKonfigurasiSheet]
/// bottom sheet lifetime.
///
/// Data flow:
///   UI (sheet) → [generatePdf] → [AbsensiPdfBuilder.build] → emit [generated]
///   UI          → [previewPdf] → Printing.layoutPdf (native preview)
///   UI          → [sharePdf]  → share_plus native sheet
class LaporanAbsensiCubit extends Cubit<LaporanAbsensiState> {
  final _log = Logger();

  LaporanAbsensiCubit() : super(const LaporanAbsensiState.initial());

  /// Builds the PDF bytes from [config] and the pre-loaded [allRecords].
  ///
  /// [allRecords] is the full list already loaded by [AbsensiCubit] on screen —
  /// filtering to the selected date range is done inside [AbsensiPdfBuilder].
  Future<void> generatePdf(
    LaporanAbsensiConfig config,
    List<AbsensiModel> allRecords,
  ) async {
    emit(const LaporanAbsensiState.generating());
    try {
      final bytes = await AbsensiPdfBuilder.build(config, allRecords);
      emit(LaporanAbsensiState.generated(bytes));
    } catch (e, st) {
      _log.e('PDF generation failed', error: e, stackTrace: st);
      emit(LaporanAbsensiState.error('Gagal membuat laporan: ${e.toString()}'));
    }
  }

  /// Opens the native PDF preview via the [printing] package.
  ///
  /// Uses the in-memory [bytes] already emitted by [generatePdf] — no
  /// additional file I/O is required.
  Future<void> previewPdf(Uint8List bytes, String filename) async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => bytes,
        name: filename,
      );
    } catch (e, st) {
      _log.e('PDF preview failed', error: e, stackTrace: st);
      emit(LaporanAbsensiState.error('Gagal membuka pratinjau: ${e.toString()}'));
    }
  }

  /// Shares the PDF via the native share sheet (WhatsApp, email, save, etc.).
  ///
  /// [Printing.sharePdf] handles temporary file creation internally —
  /// no [path_provider] is required.
  Future<void> sharePdf(Uint8List bytes, String filename) async {
    try {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e, st) {
      _log.e('PDF share failed', error: e, stackTrace: st);
      emit(LaporanAbsensiState.error('Gagal berbagi laporan: ${e.toString()}'));
    }
  }

  /// Resets the cubit state back to initial.
  void reset() {
    emit(const LaporanAbsensiState.initial());
  }
}
