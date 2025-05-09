import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_project/services/usb_manager.dart';
import 'package:my_project/services/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

class QRScannerScreen extends StatelessWidget {
  QRScannerScreen({super.key});

  final UsbManager _usb = UsbManager(UsbService());

  Future<String> _getArduinoReply(UsbPort port, {Duration timeout = const Duration(seconds: 2)}) async {
    final completer = Completer<String>();
    String response = '';
    late StreamSubscription<Uint8List> subscription;

    subscription = port.inputStream!.listen((bytes) {
      response += String.fromCharCodes(bytes);
      if (response.contains('\n')) {
        subscription.cancel();
        completer.complete(response.trim());
      }
    });

    return completer.future.timeout(timeout, onTimeout: () {
      subscription.cancel();
      return 'Arduino не відповів';
    });
  }

  Future<void> _handleQRCode(BuildContext context, String data) async {
    final port = await _usb.selectDevice();
    if (!context.mounted) return;

    if (port == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arduino не знайдено')),
      );
      return;
    }

    await _usb.sendData('$data\n');
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR надіслано: $data')),
    );

    final arduinoResponse = await _getArduinoReply(port);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Arduino відповів: $arduinoResponse')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканування QR-коду')),
      body: MobileScanner(
        onDetect: (capture) {
          final qrCode = capture.barcodes.first.rawValue;
          if (qrCode != null) {
            _handleQRCode(context, qrCode);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
