
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/qr/qr_state.dart';
import 'package:my_project/services/usb_manager.dart';
import 'package:my_project/services/usb_service.dart';
import 'dart:async';
import 'dart:typed_data';

class QRCubit extends Cubit<QRState> {
  final UsbManager usb;

  QRCubit() : usb = UsbManager(UsbService()), super(QRInitial());

  void processScannedQR(String data) {
    emit(QRSuccess(data));
  }

  Future<void> scanFromArduino() async {
    emit(QRLoading());
    try {
      await usb.dispose();
      final port = await usb.selectDevice();
      if (port == null) throw Exception("Порт не знайдено");

      String response = '';
      final completer = Completer<String>();

      late StreamSubscription<Uint8List> subscription;
      subscription = port.inputStream!.listen((bytes) {
        response += String.fromCharCodes(bytes);
        if (response.contains('\n')) {
          subscription.cancel();
          completer.complete(response.trim());
        }
      });

      final result = await completer.future.timeout(
        const Duration(seconds: 2),
        onTimeout: () {
          subscription.cancel();
          return 'Arduino не відповів';
        },
      );

      emit(QRSuccess(result));
    } catch (e) {
      emit(QRFailure(e.toString()));
    }
  }
}
