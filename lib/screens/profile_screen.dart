import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_state.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Профіль користувача')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.thermostat),
              title: Text('Бажана температура напою'),
              subtitle: Text('${appState.preferredTemp.toStringAsFixed(1)}°C'),
            ),
            Slider(
              min: 40,
              max: 80,
              divisions: 40,
              value: appState.preferredTemp,
              label: '${appState.preferredTemp.toStringAsFixed(1)}°C',
              onChanged: (value) {
                appState.setPreferredTemp(value);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Час нагадування випити каву/чай'),
              subtitle: Text('${appState.reminderTime.format(context)}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: appState.reminderTime,
                  );
                  if (picked != null) {
                    appState.setReminderTime(picked);
                  }
                },
              ),
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Зберегти',
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(height: 16),
            CustomButton(
              text: 'Вийти',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
