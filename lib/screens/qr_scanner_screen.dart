
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_project/cubit/qr/qr_cubit.dart';
import 'package:my_project/cubit/qr/qr_state.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Сканер QR")),
      body: BlocConsumer<QRCubit, QRState>(
        listener: (context, state) {
          if (state is QRFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Помилка: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: MobileScanner(
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final qr = barcodes.first.rawValue ?? 'QR не зчитано';
                      context.read<QRCubit>().processScannedQR(qr);
                    }
                  },
                ),
              ),
              if (state is QRSuccess)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Результат: ${state.data}",
                      style: const TextStyle(fontSize: 18)),
                ),
            ],
          );
        },
      ),
    );
  }
}
