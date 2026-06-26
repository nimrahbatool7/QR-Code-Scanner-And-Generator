import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
            Container(color: Colors.black87),
            
          if (_scannedResult != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: QrResultCard(
                    result: _scannedResult!,
                    onReset: _resetScanner,
                  ),
                ),
              ),
            )
          else if (_isScanning)
            const Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 48.0),
                  child: Text(
                    "Align QR Code within the frame to scan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
