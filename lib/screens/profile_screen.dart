import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/connection/connection_cubit.dart';
import 'package:my_project/cubit/connection/connection_state.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/cubit/profile/profile_state.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      context.read<ProfileCubit>().setEmail(authState.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final email = authState is AuthSuccess ? authState.email : '';

              if (context.watch<ConnectionCubit>().state is InternetFailure) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Немає інтернету'))
                  );
                });
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Зареєстровано на'),
                      subtitle: Text(email),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.thermostat),
                      title: const Text('Температура чашки'),
                      subtitle: Text('${profileState.temperature}°C'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final controller = TextEditingController(
                              text: profileState.temperature.toString()
                          );
                          final result = await showDialog<String>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Змінити температуру'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Скасувати'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, controller.text),
                                  child: const Text('Зберегти'),
                                ),
                              ],
                            ),
                          );
                          if (result != null) {
                            final temp = double.tryParse(result);
                            if (temp != null) {
                              context.read<ProfileCubit>().setTemperature(temp);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Час нагадування'),
                      subtitle: Text(profileState.reminderTime),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final controller = TextEditingController(
                              text: profileState.reminderTime);
                          final result = await showDialog<String>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Змінити час нагадування'),
                              content: TextField(controller: controller),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Скасувати'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, controller.text),
                                  child: const Text('Зберегти'),
                                ),
                              ],
                            ),
                          );
                          if (result != null) {
                            context.read<ProfileCubit>().setReminderTime(result);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
