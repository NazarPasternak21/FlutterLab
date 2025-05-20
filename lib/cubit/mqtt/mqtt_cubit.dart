import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:my_project/cubit/mqtt/mqtt_state.dart';

class MqttCubit extends Cubit<MqttState> {
  final MqttServerClient _client =
  MqttServerClient('test.mosquitto.org', 'flutter_client');

  MqttCubit() : super(MqttInitial()) {
    _connect();
  }

  Future<void> _connect() async {
    _client.port = 1883;
    _client.keepAlivePeriod = 20;
    _client.logging(on: false);
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;

    try {
      await _client.connect();
    } catch (e) {
      emit(MqttError('Не вдалося підключитися до MQTT: $e'));
      _client.disconnect();
    }
  }

  void _onConnected() {
    emit(MqttConnected());
    _client.subscribe('sensor/temperature', MqttQos.atLeastOnce);
    _client.updates!.listen(_onMessage);
  }

  void _onDisconnected() {
    emit(MqttDisconnected());
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? event) {
    final recMess = event![0].payload as MqttPublishMessage;
    final payload =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    try {
      final temperature = double.parse(payload);
      emit(MqttTemperatureReceived(temperature));
    } catch (e) {
      emit(MqttError('Помилка при парсингу температури: $e'));
    }
  }
}
