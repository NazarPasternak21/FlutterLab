import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_project/services/app_state.dart';
import 'package:my_project/services/mqtt_service.dart';
import 'package:my_project/widgets/cup_status_card.dart';

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

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupStatusCard(
                temperature: _isHeating ? appState.preferredTemp : currentTemperature,
                isHeating: _isHeating,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isHeating = !_isHeating;
                  });
                },
                child: Text(_isHeating ? 'Вимкнути підігрів' : 'Увімкнути підігрів'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
