// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';


// class ScanQrCode extends StatefulWidget {
//   const ScanQrCode({super.key});

//   @override
//   State<ScanQrCode> createState() => _ScanQrCodeState();
// }

// class _ScanQrCodeState extends State<ScanQrCode> {
//   String QrResult = "Scanned Code Will Appear here";
//   Future<void> ScanQr()async
//   {
//     try {
//       final QrCode = await flutterbarcodescanner.ScanQrCode("#ff6666", "cancel", true, scanmode.qr );
//     } catch (e) {
//       QrResult="failed to read Qr code";
      
//     }

//   }


//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar:  AppBar(
//         title: Text("Scan Qr Code"),

//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 30,),
//           Text(QrResult,style: TextStyle(color: Colors.black),),
//           SizedBox(height: 30,),
//           ElevatedButton(onPressed: ()=>
//           {

//           }, child: Text("Scan Code"),),
//         ],
//       ),
//     );
//   }
// }