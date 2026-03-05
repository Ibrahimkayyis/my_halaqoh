import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/widgets/scanner_result_sheet.dart';

/// Barcode scanner screen with camera view, card-shaped overlay, and animated scan line
@RoutePage()
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen>
    with SingleTickerProviderStateMixin {
  final MobileScannerController _scannerController = MobileScannerController();
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;
  bool _isScanned = false;
  bool _torchOn = false;

  // Simulated scanned data
  String _scannedName = '';
  String _scannedNis = '';

  // Card dimensions (landscape ratio like ID card)
  static const double _cardAspectRatio = 1.586; // standard ID card ratio

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    setState(() {
      _isScanned = true;
      // Simulate decoded data from QR
      _scannedName = 'Ahmad';
      _scannedNis = '22051214060';
    });
  }

  void _resetScanner() {
    setState(() {
      _isScanned = false;
      _scannedName = '';
      _scannedNis = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Scanner overlay with card shape
          _buildCardOverlay(colors),

          // Top bar with back and torch buttons
          _buildTopBar(colors),

          // Instruction text
          if (!_isScanned)
            Positioned(
              bottom: 100.h,
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

          // Bottom sheet when scanned
          if (_isScanned)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ScannerResultSheet(
                name: _scannedName,
                nis: _scannedNis,
                onCancel: _resetScanner,
                onSave: () {
                  _resetScanner();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Absensi disimpan!',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      backgroundColor: colors.primary,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(AppColorSet colors) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8.h,
      left: 16.w,
      right: 16.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.4),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 22.sp,
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
                  Icon(
                    Icons.flashlight_on,
                    color: Colors.white,
                    size: 18.sp,
                  ),
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

  Widget _buildCardOverlay(AppColorSet colors) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate card dimensions (landscape, like ID card)
          final cardWidth = constraints.maxWidth * 0.85;
          final cardHeight = cardWidth / _cardAspectRatio;

          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Stack(
              children: [
                // Card frame with rounded corners
                CustomPaint(
                  size: Size(cardWidth, cardHeight),
                  painter: _CardCornerPainter(color: colors.primary),
                ),

                // Animated scan line
                AnimatedBuilder(
                  animation: _scanLineAnimation,
                  builder: (context, child) {
                    final yPosition =
                        _scanLineAnimation.value * (cardHeight - 4);
                    return Positioned(
                      top: yPosition,
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
    );
  }
}

/// Paints rounded-corner brackets for a card-shaped scanner overlay
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

    // Top-left corner
    final topLeftPath = Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..lineTo(cornerLength, 0);
    canvas.drawPath(topLeftPath, paint);

    // Top-right corner
    final topRightPath = Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width - cornerRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
      ..lineTo(size.width, cornerLength);
    canvas.drawPath(topRightPath, paint);

    // Bottom-left corner
    final bottomLeftPath = Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height - cornerRadius)
      ..quadraticBezierTo(0, size.height, cornerRadius, size.height)
      ..lineTo(cornerLength, size.height);
    canvas.drawPath(bottomLeftPath, paint);

    // Bottom-right corner
    final bottomRightPath = Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width - cornerRadius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - cornerRadius)
      ..lineTo(size.width, size.height - cornerLength);
    canvas.drawPath(bottomRightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
