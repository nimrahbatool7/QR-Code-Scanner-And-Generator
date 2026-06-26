import 'package:flutter/material.dart';

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
        RRect.fromRectAndRadius(scanWindow, const Radius.circular(12)),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withAlpha(128)
      ..style = PaintingStyle.fill;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // Draw the borders of the scanner
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
      
    final length = 30.0;
    
    // Top left
    canvas.drawLine(scanWindow.topLeft, scanWindow.topLeft.translate(length, 0), borderPaint);
    canvas.drawLine(scanWindow.topLeft, scanWindow.topLeft.translate(0, length), borderPaint);
    
    // Top right
    canvas.drawLine(scanWindow.topRight, scanWindow.topRight.translate(-length, 0), borderPaint);
    canvas.drawLine(scanWindow.topRight, scanWindow.topRight.translate(0, length), borderPaint);
    
    // Bottom left
    canvas.drawLine(scanWindow.bottomLeft, scanWindow.bottomLeft.translate(length, 0), borderPaint);
    canvas.drawLine(scanWindow.bottomLeft, scanWindow.bottomLeft.translate(0, -length), borderPaint);
    
    // Bottom right
    canvas.drawLine(scanWindow.bottomRight, scanWindow.bottomRight.translate(-length, 0), borderPaint);
    canvas.drawLine(scanWindow.bottomRight, scanWindow.bottomRight.translate(0, -length), borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
