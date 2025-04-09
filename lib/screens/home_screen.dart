import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/services/app_state.dart';
import 'package:untitled/widgets/cup_status_card.dart';

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
    double currentTemperature = _isHeating ? appState.preferredTemp : 45.0;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupStatusCard(
              temperature: currentTemperature,
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
    );
  }
}
