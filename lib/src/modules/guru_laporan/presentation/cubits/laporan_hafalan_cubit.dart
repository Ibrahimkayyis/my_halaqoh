import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:printing/printing.dart';

import '../../domain/models/laporan_hafalan_config.dart';

import '../../../guru_hafalan/domain/repositories/hafalan_santri_repository.dart';
import '../widgets/hafalan_pdf_builder.dart';
import 'laporan_hafalan_state.dart';

/// Cubit that orchestrates PDF generation and sharing for Hafalan reports.
///
/// Registered as [registerFactory] — scoped to the
/// [LaporanKonfigurasiHafalanSheet] bottom sheet lifetime.
///
/// Data flow:
///   Sheet → [generatePdf] → [HafalanPdfBuilder.build] → emit [generated]
///   Sheet → [previewPdf]  → Printing.layoutPdf (native preview)
///   Sheet → [sharePdf]   → Printing.sharePdf (native share sheet)
class LaporanHafalanCubit extends Cubit<LaporanHafalanState> {
  final _log = Logger();
  final HafalanSantriRepository _repository;

  LaporanHafalanCubit(this._repository) : super(const LaporanHafalanState.initial());

  /// Builds the PDF bytes from [config].
  ///
  /// Fetches ALL records for the requested santri from the local repository,
  /// then filtering to the selected date range is done inside [HafalanPdfBuilder].
  Future<void> generatePdf(
    LaporanHafalanConfig config,
  ) async {
    emit(const LaporanHafalanState.generating());
    try {
      final allRecords = _repository.getAllHafalanBySantriId(config.santriId);
      final bytes = await HafalanPdfBuilder.build(config, allRecords);
      emit(LaporanHafalanState.generated(bytes));
    } catch (e, st) {
      _log.e('Hafalan PDF generation failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanState.error('Gagal membuat laporan: ${e.toString()}'),
      );
    }
  }

  /// Opens the native PDF preview via the [printing] package.
  Future<void> previewPdf(Uint8List bytes, String filename) async {
    try {
      await Printing.layoutPdf(onLayout: (_) => bytes, name: filename);
    } catch (e, st) {
      _log.e('Hafalan PDF preview failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanState.error(
          'Gagal membuka pratinjau: ${e.toString()}',
        ),
      );
    }
  }

  /// Shares the PDF via the native share sheet (WhatsApp, email, save…).
  Future<void> sharePdf(Uint8List bytes, String filename) async {
    try {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e, st) {
      _log.e('Hafalan PDF share failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanState.error('Gagal berbagi laporan: ${e.toString()}'),
      );
    }
  }

  /// Resets the cubit state back to initial so the teacher can reconfigure.
  void reset() => emit(const LaporanHafalanState.initial());
}
