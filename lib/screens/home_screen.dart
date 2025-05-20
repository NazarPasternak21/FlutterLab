import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/connection/connection_cubit.dart';
import 'package:my_project/cubit/connection/connection_state.dart';
import 'package:my_project/cubit/mqtt/mqtt_cubit.dart';
import 'package:my_project/cubit/mqtt/mqtt_state.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
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
    final profileState = context.watch<ProfileCubit>().state;
    final connectionState = context.watch<ConnectionCubit>().state;
    final preferredTemp = profileState.temperature;

    if (connectionState is InternetFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Немає інтернету')),
        );
      });
    }

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
              BlocBuilder<MqttCubit, MqttState>(
                builder: (context, mqttState) {
                  double currentTemperature = 45.0;

                  if (mqttState is MqttTemperatureReceived) {
                    currentTemperature = mqttState.temperature;
                  } else if (mqttState is MqttError) {
                    currentTemperature = 0.0;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(mqttState.message)),
                      );
                    });
                  }

                  return CupStatusCard(
                    temperature:
                    _isHeating ? preferredTemp : currentTemperature,
                    isHeating: _isHeating,
                  );
                },
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
                onPressed: () => Navigator.pushNamed(context, '/scan'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Збережені QR-коди',
                icon: Icons.save,
                onPressed: () => Navigator.pushNamed(context, '/saved'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
