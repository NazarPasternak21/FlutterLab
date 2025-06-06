import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/services/local_auth_repository.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/services/app_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _editTemperature(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    double temp = appState.preferredTemp;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редагувати температуру'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${temp.toStringAsFixed(1)}°C', style: const TextStyle(fontSize: 20)),
              Slider(
                value: temp,
                min: 30,
                max: 100,
                divisions: 70,
                label: '${temp.toStringAsFixed(1)}°C',
                onChanged: (value) {
                  temp = value;
                  (context as Element).markNeedsBuild();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.setPreferredTemp(temp);
                Navigator.pop(context);
              },
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editReminderTime(BuildContext context) async {
    final appState = Provider.of<AppState>(context, listen: false);
    final picked = await showTimePicker(
      context: context,
      initialTime: appState.reminderTime,
    );

    if (picked != null && picked != appState.reminderTime) {
      appState.setReminderTime(picked);
    }
  }

  Future<void> _confirmAndLogout(BuildContext context) async {
    final authRepo = LocalAuthRepository();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вийти з додатку'),
        content: const Text('Ви впевнені, що хочете вийти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Скасувати'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authRepo.logoutUser();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = LocalAuthRepository();
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmAndLogout(context),
          )
        ],
      ),
      body: FutureBuilder<String?>(
        future: authRepo.getCurrentUserEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final email = snapshot.data ?? 'Невідомо';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListTile(
                    title: const Text('Email'),
                    subtitle: Text(email),
                    leading: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListTile(
                    title: const Text('Температура чашки'),
                    subtitle: Text('${appState.preferredTemp.toStringAsFixed(1)}°C'),
                    leading: const Icon(Icons.thermostat),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editTemperature(context),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: ListTile(
                    title: const Text('Час нагадування'),
                    subtitle: Text(appState.reminderTime.format(context)),
                    leading: const Icon(Icons.alarm),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editReminderTime(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
