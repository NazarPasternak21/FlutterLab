import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/services/app_state.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/services/connectivity_service.dart';
import 'package:my_project/services/connectivity_listener.dart';
import 'package:my_project/services/mqtt_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final savedEmail = prefs.getString('email');

  final appState = AppState();

  if (isLoggedIn && savedEmail != null) {
    await appState.loadUserSettings(savedEmail);
    final connected = await ConnectivityService.checkInternetConnection();
    if (!connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(navigatorKey.currentContext!, 'Автологін виконано без Інтернету');
      });
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appState),
        ChangeNotifierProvider(create: (_) => MqttService()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Cup',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => ConnectivityListener(child: const LoginScreen()),
        '/register': (context) =>
            ConnectivityListener(child: const RegisterScreen()),
        '/home': (context) => ConnectivityListener(child: const HomeScreen()),
        '/profile': (context) =>
            ConnectivityListener(child: const ProfileScreen()),
      },
    );
  }
}
