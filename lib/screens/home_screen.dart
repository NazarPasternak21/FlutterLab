import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/connection/connection_cubit.dart';
import 'package:my_project/cubit/connection/connection_state.dart';
import 'package:my_project/cubit/mqtt/mqtt_cubit.dart';
import 'package:my_project/cubit/mqtt/mqtt_state.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/widgets/cup_status_card.dart';
import 'package:my_project/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.watch<ProfileCubit>().state;
    final preferredTemp = profileState.temperature;

    return BlocListener<ConnectionCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Немає інтернету')),
          );
        }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<MqttCubit, MqttState>(
              builder: (context, mqttState) {
                double currentTemp = 45.0;
                bool isHeating = false;

                if (mqttState is MqttTemperatureReceived) {
                  currentTemp = mqttState.temperature;
                } else if (mqttState is MqttHeatingStateChanged) {
                  isHeating = mqttState.isHeating;
                } else if (mqttState is MqttError) {
                  currentTemp = 0.0;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(mqttState.message)),
                    );
                  });
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupStatusCard(
                      temperature: isHeating ? preferredTemp : currentTemp,
                      isHeating: isHeating,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: isHeating ? 'Вимкнути підігрів' : 'Увімкнути підігрів',
                      icon: isHeating ? Icons.power_off : Icons.power,
                      onPressed: () {
                        context.read<MqttCubit>().toggleHeating();
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
