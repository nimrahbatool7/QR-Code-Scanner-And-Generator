import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_code_scanner/core/constants/app_colors.dart';
import 'package:qr_code_scanner/features/qr_scanner/widgets/qr_result_card.dart';
import 'package:qr_code_scanner/features/qr_scanner/widgets/scanner_overlay.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  String? _scannedResult;
  bool _isScanning = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() {
        _scannedResult = barcodes.first.rawValue;
        _isScanning = false;
      });
      _controller.stop();
    }
  }

  void _resetScanner() {
    setState(() {
      _scannedResult = null;
      _isScanning = true;
    });
    _controller.start();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 250,
      height: 250,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            scanWindow: scanWindow,
            onDetect: _handleDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Text(
                  "Error: \${error.errorCode}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            },
          ),
          if (_isScanning)
            ScannerOverlay(scanWindow: scanWindow)
          else
            Container(color: AppColors.backgroundDark.withOpacity(0.9)),
            
          // Animated Laser Line
          if (_isScanning)
            Positioned.fromRect(
              rect: scanWindow,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .slideY(begin: 0, end: (250 - 4) / 4, duration: 2.seconds, curve: Curves.easeInOut),
                ],
              ),
            ),
            
          if (_scannedResult != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: QrResultCard(
                    result: _scannedResult!,
                    onReset: _resetScanner,
                  ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                ),
              ),
            )
          else if (_isScanning)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: const Text(
                      "Align QR Code within the frame to scan",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ).animate().fadeIn(duration: 1.seconds).shimmer(delay: 1.seconds, duration: 2.seconds),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
