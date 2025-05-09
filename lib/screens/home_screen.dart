import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_project/services/app_state.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:my_project/widgets/cup_status_card.dart';
import 'package:my_project/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isHeating = false;

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var mqttService = Provider.of<MqttService>(context);
    double currentTemperature = mqttService.currentTemperature ?? 45.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя розумна чашка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupStatusCard(
                temperature: _isHeating ? appState.preferredTemp : currentTemperature,
                isHeating: _isHeating,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isHeating ? 'Вимкнути підігрів' : 'Увімкнути підігрів',
                icon: _isHeating ? Icons.power_off : Icons.power,
                onPressed: () {
                  setState(() {
                    _isHeating = !_isHeating;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Сканувати QR-код',
                icon: Icons.qr_code_scanner,
                onPressed: () => Navigator.pushNamed(context, '/qr_scanner'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Збережені QR-коди',
                icon: Icons.save,
                onPressed: () => Navigator.pushNamed(context, '/saved_qr'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
