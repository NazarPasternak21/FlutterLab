import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/app_state.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Cup',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), 
        '/register': (context) => RegisterScreen(), 
        '/home': (context) => HomeScreen(), 
        '/profile': (context) => ProfileScreen(), 
      },
    );
  }
}
