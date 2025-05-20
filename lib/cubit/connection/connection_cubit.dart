import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/connection/connection_state.dart';
import 'package:my_project/services/connectivity_service.dart';

class ConnectionCubit extends Cubit<InternetState> {
  Timer? _timer;

  ConnectionCubit() : super(InternetInitial()) {
    _startMonitoring();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => checkConnection());
  }

  Future<void> checkConnection() async {
    final connected = await ConnectivityService.checkInternetConnection();
    if (connected) {
      emit(InternetSuccess());
    } else {
      emit(InternetFailure());
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}