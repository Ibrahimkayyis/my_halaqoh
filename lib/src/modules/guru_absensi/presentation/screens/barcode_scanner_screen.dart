import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

/// Barcode scanner screen.
@RoutePage()
class BarcodeScannerScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedSesi;

  const BarcodeScannerScreen({
    super.key,
    required this.selectedDate,
    required this.selectedSesi,
  });

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController _scannerController;
  bool _torchOn = false;

  late AnimationController _animController;
  late Animation<double> _scanLineAnim;

  List<SantriModel> _santriList = [];
  final Set<String> _scannedNisSet = {};

  String? _flashNis;
  String? _errorMessage;
  String? _successMessage;

  // ── Anti-Ghost Read ──
  // Bukan cooldown global — melainkan validasi format + konfirmasi 2x baca
  // untuk barcode yang valid secara format tapi tidak ada di daftar halaqoh.
  String? _lastUnrecognizedNis;
  int _unrecognizedCount = 0;

  // Regex untuk format NIS yang valid (4–13 digit angka).
  // NIS bervariasi panjangnya (contoh: 3100002603 = 10 digit).
  // Tetap memfilter ghost read karena noise kamera menghasilkan
  // huruf, simbol, atau string sangat pendek/panjang.
  static final _nisPattern = RegExp(r'^\d{4,13}$');

  // Debounce: barcode terakhir yang berhasil di-scan (agar tidak re-proses)
  String? _lastAcceptedBarcode;
  DateTime _lastAcceptedTime = DateTime(2000);
  String? _lastSuccessfulNis;
  DateTime _lastSuccessfulScanTime = DateTime(2000);
  static const _postSuccessUnrecognizedGrace = Duration(milliseconds: 1800);
  static const double _cardAspectRatio = 1.586;

  @override
  void initState() {
    super.initState();

    _scannerController = MobileScannerController(
      cameraResolution: const Size(1280, 720),
      detectionSpeed: DetectionSpeed.unrestricted,
      facing: CameraFacing.back,
      formats: const [
        BarcodeFormat.codabar,
        BarcodeFormat.code39,
        BarcodeFormat.code93,
        BarcodeFormat.code128,
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
        BarcodeFormat.itf,
        BarcodeFormat.upcA,
        BarcodeFormat.upcE,
      ],
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSantriList());
  }

  void _loadSantriList() {
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final halaqohState = context.read<HalaqohCubit>().state;
    final santriState = context.read<SantriCubit>().state;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    if (myHalaqoh != null) {
      santriState.maybeWhen(
        loaded: (sList) {
          setState(() {
            _santriList = sList
                .where((s) => myHalaqoh!.santriIds.contains(s.id))
                .toList();
          });
        },
        orElse: () {},
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  // ── Scan handler — Fast + Ghost-Free ──────────────────────────────────────
  //
  // Strategi anti-ghost-read tanpa mengorbankan kecepatan:
  //
  // 1. FORMAT FILTER: Ghost read menghasilkan string acak (huruf, simbol,
  //    panjang tidak sesuai). NIS selalu 12 digit angka. Dengan satu cek
  //    regex, >99% ghost read langsung terbuang di frame pertama — GRATIS,
  //    tanpa cooldown, tanpa delay.
  //
  // 2. VALID NIS MATCH → TERIMA LANGSUNG: Jika barcode lolos format DAN
  //    cocok dengan NIS santri di halaqoh, langsung diterima. Probabilitas
  //    ghost read menghasilkan NIS 12 digit yang kebetulan cocok = ~0%.
  //
  // 3. VALID FORMAT TAPI TIDAK DIKENAL → KONFIRMASI 2x: Jika NIS formatnya
  //    benar tapi bukan anggota halaqoh, mungkin kartu santri lain. Tunggu
  //    2 pembacaan konsisten sebelum tampilkan error (berjaga-jaga dari
  //    misread 1 digit, tetap sangat cepat karena hanya butuh 2 frame).
  //
  // 4. DEBOUNCE PER-BARCODE: Setelah NIS diterima, barcode yang SAMA
  //    diabaikan selama 1 detik. Barcode LAIN tetap bisa langsung terbaca.
  //    Tidak ada global cooldown yang memblokir semua scan.
  //
  void _onDetect(BarcodeCapture capture) {
    final candidates = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .where((value) => value.isNotEmpty && _nisPattern.hasMatch(value))
        .toSet()
        .toList();

    if (candidates.isEmpty) return;

    final knownCandidates = candidates.where(
      (value) => _santriList.any((s) => s.nis == value),
    );

    for (final cleanValue in [...knownCandidates, ...candidates]) {
      if (_handleDetectedNis(cleanValue)) return;
    }
  }

  bool _handleDetectedNis(String cleanValue) {
    // ── STEP 1: Format filter — buang ghost read instan ──────────────────
    if (!_nisPattern.hasMatch(cleanValue)) return false;

    // ── STEP 2: Debounce — abaikan barcode yang baru saja diproses ───────
    final now = DateTime.now();
    if (_lastAcceptedBarcode == cleanValue &&
        now.difference(_lastAcceptedTime).inMilliseconds < 1000) {
      if (_scannedNisSet.contains(cleanValue)) {
        _lastSuccessfulNis = cleanValue;
        _lastSuccessfulScanTime = now;
      }
      return true;
    }

    // ── STEP 3: Cek apakah NIS ada di daftar santri halaqoh ─────────────
    final index = _santriList.indexWhere((s) => s.nis == cleanValue);

    if (index == -1) {
      if (_lastSuccessfulNis != null &&
          now.difference(_lastSuccessfulScanTime) <
              _postSuccessUnrecognizedGrace) {
        _lastUnrecognizedNis = null;
        _unrecognizedCount = 0;
        return true;
      }

      // Format NIS valid tapi bukan anggota halaqoh.
      // Konfirmasi 2x pembacaan konsisten sebelum tampilkan error.
      if (_lastUnrecognizedNis == cleanValue) {
        _unrecognizedCount++;
      } else {
        _lastUnrecognizedNis = cleanValue;
        _unrecognizedCount = 1;
      }

      if (_unrecognizedCount >= 2) {
        // Sudah terbaca 2x berturut — ini memang kartu yang salah.
        _lastAcceptedBarcode = cleanValue;
        _lastAcceptedTime = now;
        _lastUnrecognizedNis = null;
        _unrecognizedCount = 0;

        if (_errorMessage == null) {
          HapticFeedback.heavyImpact();
          setState(() {
            _errorMessage = t.absensi.barcodeScanner.notMember(nis: cleanValue);
            _flashNis = null;
            // Paksa hapus success message agar tidak ada kilatan hijau
            _successMessage = null;
          });
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _errorMessage = null);
          });
        }
      }
      return true;
    }

    // ── STEP 4: NIS dikenali — sudah pernah di-scan? ────────────────────
    if (_scannedNisSet.contains(cleanValue)) {
      _lastSuccessfulNis = cleanValue;
      _lastSuccessfulScanTime = now;
      _lastUnrecognizedNis = null;
      _unrecognizedCount = 0;
      return true;
    }

    // ── STEP 5: SUKSES — terima langsung tanpa delay ────────────────────
    _lastAcceptedBarcode = cleanValue;
    _lastAcceptedTime = now;
    _lastSuccessfulNis = cleanValue;
    _lastSuccessfulScanTime = now;
    _lastUnrecognizedNis = null;
    _unrecognizedCount = 0;

    HapticFeedback.mediumImpact();
    final scannedSantriName = _santriList[index].nama;

    setState(() {
      _scannedNisSet.add(cleanValue);
      _flashNis = cleanValue;
      _errorMessage = null;
      _successMessage = scannedSantriName;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _flashNis = null);
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _successMessage = null);
    });

    return true;
  }

  // ── Navigate to detail screen ─────────────────────────────────────────────
  void _onSimpan() {
    context.router.replace(
      DetailAbsensiHariIniRoute(
        scannedNisList: _scannedNisSet.toList(),
        selectedDate: widget.selectedDate,
        selectedSesi: widget.selectedSesi,
      ),
    );
  }

  // ── Counts ─────────────────────────────────────────────────────────────────
  int get _scannedCount => _scannedNisSet.length;
  int get _totalCount => _santriList.length;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera
          MobileScanner(
            controller: _scannerController,
            // No scanWindow: decoder processes the full camera frame.
            // The overlay is only a visual guide for positioning the card.
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              return Center(
                child: Text(
                  t.absensi.barcodeScanner.cameraError(
                    error: error.errorCode.toString(),
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),

          // Card overlay + scan line
          _buildCardOverlay(colors),

          // Top bar
          _buildTopBar(colors),

          // Error banner
          if (_errorMessage != null) _buildErrorBanner(colors),

          // Success banner — Positioned harus selalu jadi direct child Stack.
          // AnimatedSwitcher dipindah ke DALAM Positioned agar layout tidak rusak.
          Positioned(
            top: MediaQuery.of(context).padding.top + 70.h,
            left: 20.w,
            right: 20.w,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: _successMessage != null
                  ? _buildSuccessBannerContent(colors)
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ),

          // Instruction text (Hanya tampil jika tidak ada error)
          if (_errorMessage == null)
            Positioned(
              bottom: 320.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.absensi.scanInstruction,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        t.absensi.barcodeScanner.clearPosition,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Draggable bottom sheet
          _buildDraggableSheet(colors),
        ],
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar(AppColorSet colors) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 22.sp),
            ),
          ),

          // Title
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              t.absensi.scanBarcode,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          // Torch toggle
          GestureDetector(
            onTap: () async {
              await _scannerController.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flashlight_on, color: Colors.white, size: 18.sp),
                  SizedBox(width: 6.w),
                  Container(
                    width: 36.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: _torchOn ? colors.primary : Colors.grey,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: AnimatedAlign(
                      alignment: _torchOn
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card overlay ──────────────────────────────────────────────────────────
  Widget _buildCardOverlay(AppColorSet colors) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 280.h, // leave room for the bottom sheet
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth * 0.85;
            final cardHeight = cardWidth / _cardAspectRatio;
            return SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Stack(
                children: [
                  // Corner painter
                  CustomPaint(
                    size: Size(cardWidth, cardHeight),
                    painter: _CardCornerPainter(color: colors.primary),
                  ),
                  // Scan line
                  AnimatedBuilder(
                    animation: _scanLineAnim,
                    builder: (_, _) {
                      final y = _scanLineAnim.value * (cardHeight - 4);
                      return Positioned(
                        top: y,
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withValues(alpha: 0.0),
                                Colors.red.withValues(alpha: 0.8),
                                Colors.red,
                                Colors.red.withValues(alpha: 0.8),
                                Colors.red.withValues(alpha: 0.0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withValues(alpha: 0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Success Pop-up Banner ─────────────────────────────────────────────────
  // Hanya mengembalikan konten banner (Container) — bukan Positioned.
  // Positioned ada di build() sebagai direct child Stack agar layout tidak rusak.
  Widget _buildSuccessBannerContent(AppColorSet colors) {
    return Center(
      key: ValueKey(
        _successMessage,
      ), // key agar AnimatedSwitcher deteksi perubahan
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.green.shade600.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20.sp),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                t.absensi.barcodeScanner.scannedSuccess(
                  name: _successMessage ?? '',
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Error banner ──────────────────────────────────────────────────────────
  Widget _buildErrorBanner(AppColorSet colors) {
    return Positioned(
      bottom: 290.h,
      left: 24.w,
      right: 24.w,
      child: AnimatedOpacity(
        opacity: _errorMessage != null ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: colors.red,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: colors.red.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  _errorMessage ?? '',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _errorMessage = null),
                child: Icon(Icons.close, color: Colors.white, size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Draggable bottom sheet ────────────────────────────────────────────────
  Widget _buildDraggableSheet(AppColorSet colors) {
    return DraggableScrollableSheet(
      initialChildSize: 0.38,
      minChildSize: 0.18,
      maxChildSize: 0.75,
      snap: true,
      snapSizes: const [0.18, 0.38, 0.75],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ── Drag handle ──────────────────────────────────
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),

              // ── Header ───────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                child: Row(
                  children: [
                    // Title + Total Santri (Kiri)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.absensi.daftarSantri,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            t.absensi.barcodeScanner.totalSantri(
                              count: _totalCount.toString(),
                            ),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Progress pill (Kanan)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.qr_code_scanner,
                            size: 14.sp,
                            color: colors.primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            t.absensi.barcodeScanner.progress(
                              scanned: _scannedCount.toString(),
                              total: _totalCount.toString(),
                            ),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ──────────────────────────────────────
              Divider(height: 1, color: colors.border),

              // ── Santri list ───────────────────────────────────
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  itemCount: _santriList.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colors.border.withValues(alpha: 0.3),
                  ),
                  itemBuilder: (context, index) {
                    final santri = _santriList[index];
                    final isPresent = _scannedNisSet.contains(santri.nis);
                    final isFlashing = _flashNis == santri.nis;
                    return _buildSantriRow(
                      santri,
                      isPresent,
                      isFlashing,
                      colors,
                    );
                  },
                ),
              ),

              // ── Simpan button ─────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  8.h,
                  20.w,
                  MediaQuery.of(context).padding.bottom + 16.h,
                ),
                child: PrimaryButton(
                  width: double.infinity,
                  height: 50.h,
                  onPressed: _onSimpan,
                  icon: Icons.check_circle_outline,
                  label: '${t.absensi.simpan}  ($_scannedCount/$_totalCount)',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Single santri row ─────────────────────────────────────────────────────
  Widget _buildSantriRow(
    SantriModel santri,
    bool isPresent,
    bool isFlashing,
    AppColorSet colors,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: isFlashing
          ? colors.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPresent
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.border.withValues(alpha: 0.3),
            ),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: isPresent ? colors.primary : colors.textSecondary,
            ),
          ),
          SizedBox(width: 12.w),

          // Name + NIS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  santri.nama,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isPresent ? colors.primary : colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  t.absensi.barcodeScanner.nisLabel(nis: santri.nis),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Checkbox
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPresent ? colors.primary : Colors.transparent,
              border: Border.all(
                color: isPresent ? colors.primary : colors.border,
                width: 2,
              ),
            ),
            child: isPresent
                ? Icon(Icons.check, size: 15.sp, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}

// ── Card corner painter ──────────────────────────────────────────────────────
class _CardCornerPainter extends CustomPainter {
  final Color color;
  _CardCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;
    const cornerRadius = 16.0;

    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, cornerRadius)
        ..quadraticBezierTo(0, 0, cornerRadius, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - cornerRadius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
        ..lineTo(size.width, cornerLength),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - cornerRadius)
        ..quadraticBezierTo(0, size.height, cornerRadius, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width - cornerRadius, size.height)
        ..quadraticBezierTo(
          size.width,
          size.height,
          size.width,
          size.height - cornerRadius,
        )
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
