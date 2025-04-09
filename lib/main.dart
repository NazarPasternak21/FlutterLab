import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/services/app_state.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/register_screen.dart';
import 'package:untitled/screens/home_screen.dart';
import 'package:untitled/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final savedEmail = prefs.getString('email');

  final appState = AppState();
  if (isLoggedIn && savedEmail != null) {
    await appState.loadUserSettings(savedEmail);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Cup',
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
