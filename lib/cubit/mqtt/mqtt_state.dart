abstract class MqttState {}

class MqttInitial extends MqttState {}

class MqttConnected extends MqttState {}

class MqttDisconnected extends MqttState {}

class MqttTemperatureReceived extends MqttState {
  final double temperature;
  MqttTemperatureReceived(this.temperature);
}

class MqttHeatingStateChanged extends MqttState {
  final bool isHeating;
  MqttHeatingStateChanged(this.isHeating);
}

class MqttError extends MqttState {
  final String message;
  MqttError(this.message);
}
