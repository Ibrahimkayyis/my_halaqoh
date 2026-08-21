import 'dart:math' as math;
import 'package:flutter/material.dart';

/// CustomPainter that renders a graceful silhouette of a mosque dome,
/// minarets, arched windows, and subtle stars for the hero card background.
class MosqueSilhouettePainter extends CustomPainter {
  final Color color;

  const MosqueSilhouettePainter({
    this.color = const Color(0x22FFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final outlinePaint = Paint()
      ..color = color.withValues(alpha: (color.a * 1.5).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // ── 1. Main Central Dome ─────────────────────────────────────────
    final domeCenterX = w * 0.72;
    final domeBottom = h;
    final domeRadius = w * 0.28;
    final domeTop = h * 0.32;

    final domePath = Path();
    domePath.moveTo(domeCenterX - domeRadius, domeBottom);
    // Left shoulder
    domePath.cubicTo(
      domeCenterX - domeRadius * 0.95,
      domeBottom - domeRadius * 0.6,
      domeCenterX - domeRadius * 0.65,
      domeTop + domeRadius * 0.35,
      domeCenterX,
      domeTop,
    );
    // Right shoulder
    domePath.cubicTo(
      domeCenterX + domeRadius * 0.65,
      domeTop + domeRadius * 0.35,
      domeCenterX + domeRadius * 0.95,
      domeBottom - domeRadius * 0.6,
      domeCenterX + domeRadius,
      domeBottom,
    );
    domePath.close();
    canvas.drawPath(domePath, paint);

    // Crescent / Finial on top of main dome
    final finialPath = Path();
    finialPath.moveTo(domeCenterX, domeTop);
    finialPath.lineTo(domeCenterX, domeTop - 12);
    canvas.drawPath(finialPath, outlinePaint..strokeWidth = 1.5);
    canvas.drawCircle(
      Offset(domeCenterX, domeTop - 14),
      2.5,
      paint,
    );

    // ── 2. Left Secondary Dome (Smaller) ────────────────────────────
    final subDomeCenterX = w * 0.40;
    final subDomeRadius = w * 0.16;
    final subDomeTop = h * 0.52;

    final subDomePath = Path();
    subDomePath.moveTo(subDomeCenterX - subDomeRadius, domeBottom);
    subDomePath.cubicTo(
      subDomeCenterX - subDomeRadius * 0.9,
      domeBottom - subDomeRadius * 0.5,
      subDomeCenterX - subDomeRadius * 0.55,
      subDomeTop + subDomeRadius * 0.3,
      subDomeCenterX,
      subDomeTop,
    );
    subDomePath.cubicTo(
      subDomeCenterX + subDomeRadius * 0.55,
      subDomeTop + subDomeRadius * 0.3,
      subDomeCenterX + subDomeRadius * 0.9,
      domeBottom - subDomeRadius * 0.5,
      subDomeCenterX + subDomeRadius,
      domeBottom,
    );
    subDomePath.close();
    canvas.drawPath(subDomePath, paint);

    // Finial on left dome
    canvas.drawLine(
      Offset(subDomeCenterX, subDomeTop),
      Offset(subDomeCenterX, subDomeTop - 8),
      outlinePaint..strokeWidth = 1.2,
    );
    canvas.drawCircle(
      Offset(subDomeCenterX, subDomeTop - 9),
      1.8,
      paint,
    );

    // ── 3. Right Minaret (Tower) ────────────────────────────────────
    final minaretX = w * 0.93;
    final minaretWidth = w * 0.07;
    final minaretTop = h * 0.18;

    final minaretPath = Path();
    // Tower body
    minaretPath.moveTo(minaretX - minaretWidth / 2, domeBottom);
    minaretPath.lineTo(minaretX - minaretWidth / 2, minaretTop + 14);
    // Balcony
    minaretPath.lineTo(minaretX - minaretWidth * 0.75, minaretTop + 14);
    minaretPath.lineTo(minaretX - minaretWidth * 0.75, minaretTop + 10);
    minaretPath.lineTo(minaretX - minaretWidth / 2, minaretTop + 10);
    minaretPath.lineTo(minaretX - minaretWidth * 0.4, minaretTop + 5);
    // Spire
    minaretPath.lineTo(minaretX, minaretTop);
    minaretPath.lineTo(minaretX + minaretWidth * 0.4, minaretTop + 5);
    minaretPath.lineTo(minaretX + minaretWidth / 2, minaretTop + 10);
    minaretPath.lineTo(minaretX + minaretWidth * 0.75, minaretTop + 10);
    minaretPath.lineTo(minaretX + minaretWidth * 0.75, minaretTop + 14);
    minaretPath.lineTo(minaretX + minaretWidth / 2, minaretTop + 14);
    minaretPath.lineTo(minaretX + minaretWidth / 2, domeBottom);
    minaretPath.close();
    canvas.drawPath(minaretPath, paint);

    // Spire finial on top of minaret
    canvas.drawLine(
      Offset(minaretX, minaretTop),
      Offset(minaretX, minaretTop - 10),
      outlinePaint..strokeWidth = 1.2,
    );
    canvas.drawCircle(
      Offset(minaretX, minaretTop - 11),
      2.0,
      paint,
    );

    // ── 4. Arched Windows in Main Dome ──────────────────────────────
    final windowWidth = 6.0;
    final windowHeight = 12.0;
    final windowY = domeBottom - 20;

    for (int i = -2; i <= 2; i++) {
      final wx = domeCenterX + (i * 12.0);
      final winPath = Path();
      winPath.moveTo(wx - windowWidth / 2, windowY + windowHeight);
      winPath.lineTo(wx - windowWidth / 2, windowY + windowWidth / 2);
      winPath.addArc(
        Rect.fromCircle(
          center: Offset(wx, windowY + windowWidth / 2),
          radius: windowWidth / 2,
        ),
        math.pi,
        math.pi,
      );
      winPath.lineTo(wx + windowWidth / 2, windowY + windowHeight);
      winPath.close();
      canvas.drawPath(
        winPath,
        Paint()
          ..color = color.withValues(alpha: (color.a * 1.6).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill,
      );
    }

    // ── 5. Twinkling Night Stars in Sky ─────────────────────────────
    final starPaint = Paint()
      ..color = color.withValues(alpha: (color.a * 2.0).clamp(0.0, 1.0))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(w * 0.25, h * 0.22), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.45, h * 0.16), 1.6, starPaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.26), 1.0, starPaint);
    canvas.drawCircle(Offset(w * 0.78, h * 0.12), 1.4, starPaint);
    canvas.drawCircle(Offset(w * 0.15, h * 0.40), 1.0, starPaint);
  }

  @override
  bool shouldRepaint(covariant MosqueSilhouettePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
