import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  final _client = MqttServerClient('test.mosquitto.org', 'flutter_client');
  double? _currentTemperature;

  double? get currentTemperature => _currentTemperature;

  MqttService() {
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
      debugPrint('MQTT connection failed: $e');
      _client.disconnect();
    }
  }

  void _onConnected() {
    debugPrint('MQTT Connected');
    _client.subscribe('sensor/temperature', MqttQos.atLeastOnce);
    _client.updates!.listen(_onMessage);
  }

  void _onDisconnected() {
    debugPrint('MQTT Disconnected');
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage?>>? event) {
    final recMess = event![0].payload as MqttPublishMessage;
    final payload =
    MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    try {
      final temp = double.parse(payload);
      _currentTemperature = temp;
      notifyListeners();
    } catch (e) {
      debugPrint('Error parsing temperature: $e');
    }
  }
}
