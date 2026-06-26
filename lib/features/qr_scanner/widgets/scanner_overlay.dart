import 'package:flutter/material.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';

class ScannerOverlay extends StatelessWidget {
  final Rect scanWindow;
  
  const ScannerOverlay({super.key, required this.scanWindow});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScannerOverlayPainter(scanWindow: scanWindow),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  
  ScannerOverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(24)),
      );

    final backgroundPaint = Paint()
      ..color = AppColors.backgroundDark.withOpacity(0.85)
      ..style = PaintingStyle.fill;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // Draw the glowing borders of the scanner
    final borderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
      
    // Shadow for neon glow effect
    final shadowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      
    final length = 40.0;
    
    void drawCorner(Offset p1, Offset p2, Offset p3) {
      final path = Path()
        ..moveTo(p2.dx, p2.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p3.dx, p3.dy);
      canvas.drawPath(path, shadowPaint);
      canvas.drawPath(path, borderPaint);
    }
    
    // Top left
    drawCorner(
      scanWindow.topLeft,
      scanWindow.topLeft.translate(length, 0),
      scanWindow.topLeft.translate(0, length),
    );
    
    // Top right
    drawCorner(
      scanWindow.topRight,
      scanWindow.topRight.translate(-length, 0),
      scanWindow.topRight.translate(0, length),
    );
    
    // Bottom left
    drawCorner(
      scanWindow.bottomLeft,
      scanWindow.bottomLeft.translate(length, 0),
      scanWindow.bottomLeft.translate(0, -length),
    );
    
    // Bottom right
    drawCorner(
      scanWindow.bottomRight,
      scanWindow.bottomRight.translate(-length, 0),
      scanWindow.bottomRight.translate(0, -length),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
