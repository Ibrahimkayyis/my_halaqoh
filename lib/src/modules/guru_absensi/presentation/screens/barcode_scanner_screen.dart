import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_save_dialog.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

// ---------------------------------------------------------------------------
// Dummy santri model — replace with real domain model later
// ---------------------------------------------------------------------------
class _SantriItem {
  final String nis;
  final String name;
  bool isPresent = false;

  _SantriItem({required this.nis, required this.name});
}

/// Barcode scanner screen.
///
/// Flow:
/// 1. Screen opens → draggable bottom sheet shows list of santri in the group.
/// 2. Guru scans a barcode → matching santri is auto-checked (haptic + green flash).
/// 3. Scanning a barcode NOT in the list shows an error banner.
/// 4. Guru taps SIMPAN → navigates to [DetailAbsensiHariIniScreen] with
///    scanned NIS list so those santri start with status "hadir".
@RoutePage()
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  // ── Scanner ────────────────────────────────────────────────────────────────
  final MobileScannerController _scannerController = MobileScannerController();
  bool _torchOn = false;

  // ── Scan-line animation ────────────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _scanLineAnim;

  // ── Santri list (dummy — swap with real data from Cubit) ───────────────────
  final List<_SantriItem> _santriList = [
    _SantriItem(nis: '220512140601', name: 'Ahmad'),
    _SantriItem(nis: '220512140602', name: 'Fauzan'),
    _SantriItem(nis: '220512140603', name: 'Yusuf'),
    _SantriItem(nis: '220512140604', name: 'Ibrahim'),
    _SantriItem(nis: '220512140605', name: 'Khalid'),
    _SantriItem(nis: '220512140606', name: 'Usman'),
    _SantriItem(nis: '220512140607', name: 'Ghulam'),
    _SantriItem(nis: '220512140608', name: 'Haikal'),
    _SantriItem(nis: '220512140609', name: 'Fikrie'),
    _SantriItem(nis: '220512140610', name: 'Ghatfhan'),
  ];

  // ── Flash-highlight state (index of last scanned) ─────────────────────────
  int? _flashIndex;

  // ── Error banner ──────────────────────────────────────────────────────────
  String? _errorMessage;

  // ── Cooldown to avoid duplicate scans ─────────────────────────────────────
  bool _scanCooldown = false;

  // ── Card overlay ratio ────────────────────────────────────────────────────
  static const double _cardAspectRatio = 1.586;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  // ── Scan handler ──────────────────────────────────────────────────────────
  void _onDetect(BarcodeCapture capture) {
    if (_scanCooldown) return;
    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null) return;

    _setCooldown();

    final index = _santriList.indexWhere((s) => s.nis == rawValue);

    if (index == -1) {
      // Santri not in this halaqoh
      HapticFeedback.heavyImpact();
      setState(() {
        _errorMessage =
            'Santri dengan NIS $rawValue bukan anggota halaqoh Anda';
        _flashIndex = null;
      });
      // Auto-dismiss error after 3 s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _errorMessage = null);
      });
      return;
    }

    if (_santriList[index].isPresent) return; // already checked

    HapticFeedback.mediumImpact();
    setState(() {
      _santriList[index].isPresent = true;
      _flashIndex = index;
      _errorMessage = null;
    });

    // Remove highlight after 800 ms
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _flashIndex = null);
    });
  }

  void _setCooldown() {
    _scanCooldown = true;
    Future.delayed(
      const Duration(milliseconds: 800),
      () => _scanCooldown = false,
    );
  }

  // ── Navigate to detail screen ─────────────────────────────────────────────
  void _onSimpan() {
    final scannedNisList = _santriList
        .where((s) => s.isPresent)
        .map((s) => s.nis)
        .toList();

    // AutoRoute generates DetailAbsensiHariIniRouteArgs from constructor params.
    // List<String> is fully supported this way — no @PathParam needed.
    context.router.replace(
      DetailAbsensiHariIniRoute(scannedNisList: scannedNisList),
    );
  }

  // ── Counts ─────────────────────────────────────────────────────────────────
  int get _scannedCount => _santriList.where((s) => s.isPresent).length;
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
          MobileScanner(controller: _scannerController, onDetect: _onDetect),

          // Card overlay + scan line
          _buildCardOverlay(colors),

          // Top bar
          _buildTopBar(colors),

          // Error banner
          if (_errorMessage != null) _buildErrorBanner(colors),

          // Instruction text (only when error is absent)
          if (_errorMessage == null)
            Positioned(
              bottom: 320.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    t.absensi.scanInstruction,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
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
            onTap: () {
              _scannerController.toggleTorch();
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
                  // Toggle pill
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
                    builder: (_, __) {
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
                    // Title + counter
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$_scannedCount',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' / $_totalCount '
                                      '${t.absensi.santriCount(count: _totalCount.toString())}',
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
                        ],
                      ),
                    ),

                    // Progress pill
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
                      child: Text(
                        '$_scannedCount/$_totalCount',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          fontFamily: 'Poppins',
                        ),
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
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: colors.borderLight),
                  itemBuilder: (context, index) {
                    final santri = _santriList[index];
                    final isFlashing = _flashIndex == index;
                    return _buildSantriRow(santri, isFlashing, colors);
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
    _SantriItem santri,
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
              color: santri.isPresent
                  ? colors.primary.withValues(alpha: 0.15)
                  : colors.border.withValues(alpha: 0.3),
            ),
            child: Icon(
              Icons.person,
              size: 20.sp,
              color: santri.isPresent ? colors.primary : colors.textSecondary,
            ),
          ),
          SizedBox(width: 12.w),

          // Name + NIS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  santri.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: santri.isPresent
                        ? colors.primary
                        : colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'NIS: ${santri.nis}',
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
              color: santri.isPresent ? colors.primary : Colors.transparent,
              border: Border.all(
                color: santri.isPresent ? colors.primary : colors.border,
                width: 2,
              ),
            ),
            child: santri.isPresent
                ? Icon(Icons.check, size: 15.sp, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}

// ── Card corner painter (unchanged) ──────────────────────────────────────────
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

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, cornerRadius)
        ..quadraticBezierTo(0, 0, cornerRadius, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width - cornerRadius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
        ..lineTo(size.width, cornerLength),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height - cornerRadius)
        ..quadraticBezierTo(0, size.height, cornerRadius, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );
    // Bottom-right
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
