import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:my_project/services/usb_manager.dart';
import 'package:my_project/services/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

class SavedQrScreen extends StatefulWidget {
  const SavedQrScreen({super.key});

  @override
  State<SavedQrScreen> createState() => _SavedQrScreenState();
}

class _SavedQrScreenState extends State<SavedQrScreen> {
  final UsbManager _usb = UsbManager(UsbService());
  String _storedText = 'Зчитування...';

  @override
  void initState() {
    super.initState();
    _loadFromArduino();
  }

  Future<void> _loadFromArduino() async {
    setState(() => _storedText = 'Зчитування...');

    await _usb.dispose();
    final port = await _usb.selectDevice();

    if (port == null) {
      setState(() => _storedText = 'Arduino не знайдено');
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    final result = await _receiveMessage(port);
    if (mounted) {
      setState(() => _storedText = result);
    }
  }

  Future<String> _receiveMessage(UsbPort port) async {
    final completer = Completer<String>();
    String content = '';
    StreamSubscription<Uint8List>? listener;

    listener = port.inputStream?.listen(
          (chunk) {
        content += String.fromCharCodes(chunk);
        if (content.contains('\n')) {
          listener?.cancel();
          completer.complete(content.trim());
        }
      },
      onError: (error) {
        listener?.cancel();
        completer.completeError('Помилка читання: $error');
      },
      cancelOnError: true,
    );

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        listener?.cancel();
        return 'Немає відповіді від Arduino';
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Збережене повідомлення')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _storedText,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
