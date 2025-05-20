import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/cubit/connection/connection_cubit.dart';
import 'package:my_project/cubit/mqtt/mqtt_cubit.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';
import 'package:my_project/cubit/qr/qr_cubit.dart';
import 'package:my_project/screens/home_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/screens/qr_scanner_screen.dart';
import 'package:my_project/screens/saved_qr_screen.dart';
import 'package:my_project/services/local_auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthCubit _authCubit;
  late final ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();

    _authCubit = AuthCubit(LocalAuthRepository());
    _profileCubit = ProfileCubit();

    _authCubit.autoLogin().then((_) {
      final state = _authCubit.state;
      if (state is AuthSuccess) {
        _profileCubit.setEmail(state.email);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _authCubit.close();
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authCubit),
        BlocProvider(create: (_) => QRCubit()),
        BlocProvider(create: (_) => ConnectionCubit()),
        BlocProvider.value(value: _profileCubit),
        BlocProvider(create: (_) => MqttCubit()),
      ],
      child: MaterialApp(
        title: 'Smart Cup',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/scan': (_) => const QRScannerScreen(),
          '/saved': (_) => const SavedQrScreen(),
        },
      ),
    );
  }
}
