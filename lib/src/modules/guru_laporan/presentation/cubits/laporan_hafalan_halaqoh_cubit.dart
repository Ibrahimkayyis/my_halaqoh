import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:printing/printing.dart';

import '../../../guru_hafalan/domain/models/hafalan_santri_model.dart';
import '../../../guru_hafalan/domain/repositories/hafalan_santri_repository.dart';
import '../../../master_data/domain/models/santri_model.dart';
import '../../domain/models/laporan_hafalan_halaqoh_config.dart';
import '../widgets/hafalan_halaqoh_pdf_builder.dart';
import 'laporan_hafalan_halaqoh_state.dart';

/// Cubit that orchestrates PDF generation and sharing for whole-halaqoh Hafalan reports.
///
/// Registered as [registerFactory] — scoped to the
/// [LaporanKonfigurasiHafalanHalaqohSheet] bottom sheet lifetime.
class LaporanHafalanHalaqohCubit extends Cubit<LaporanHafalanHalaqohState> {
  final _log = Logger();
  final HafalanSantriRepository _repository;

  LaporanHafalanHalaqohCubit(this._repository)
      : super(const LaporanHafalanHalaqohState.initial());

  /// Builds the consolidated PDF bytes for all santri in [santriList].
  Future<void> generatePdf(
    LaporanHafalanHalaqohConfig config,
    List<SantriModel> santriList,
  ) async {
    emit(const LaporanHafalanHalaqohState.generating());
    try {
      final recordsBySantriId = <String, List<HafalanSantriModel>>{};
      for (final santri in santriList) {
        recordsBySantriId[santri.id] =
            _repository.getAllHafalanBySantriId(santri.id);
      }

      final bytes = await HafalanHalaqohPdfBuilder.build(
        config,
        santriList,
        recordsBySantriId,
      );
      emit(LaporanHafalanHalaqohState.generated(bytes));
    } catch (e, st) {
      _log.e('Hafalan Halaqoh PDF generation failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanHalaqohState.error(
          t.laporanConfig.errGenerate(error: e.toString()),
        ),
      );
    }
  }

  /// Opens the native PDF preview via the [printing] package.
  Future<void> previewPdf(Uint8List bytes, String filename) async {
    try {
      await Printing.layoutPdf(onLayout: (_) => bytes, name: filename);
    } catch (e, st) {
      _log.e('Hafalan Halaqoh PDF preview failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanHalaqohState.error(
          t.laporanConfig.errPreview(error: e.toString()),
        ),
      );
    }
  }

  /// Shares the PDF via the native share sheet (WhatsApp, email, save…).
  Future<void> sharePdf(Uint8List bytes, String filename) async {
    try {
      await Printing.sharePdf(bytes: bytes, filename: filename);
    } catch (e, st) {
      _log.e('Hafalan Halaqoh PDF share failed', error: e, stackTrace: st);
      emit(
        LaporanHafalanHalaqohState.error(
          t.laporanConfig.errShare(error: e.toString()),
        ),
      );
    }
  }

  /// Resets the cubit state back to initial so the teacher can reconfigure.
  void reset() => emit(const LaporanHafalanHalaqohState.initial());
}
