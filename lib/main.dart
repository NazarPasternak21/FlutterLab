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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(LocalAuthRepository())),
        BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
        BlocProvider<QRCubit>(create: (_) => QRCubit()),
        BlocProvider<ConnectionCubit>(create: (_) => ConnectionCubit()..checkConnection()),
        BlocProvider<MqttCubit>(create: (_) => MqttCubit()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => current is AuthSuccess,
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<ProfileCubit>().setEmail(state.email);
          }
        },
        child: MaterialApp(
          title: 'Smart Cup',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/home': (_) => const HomeScreen(),
            '/profile': (_) => const ProfileScreen(),
            '/login': (_) => const LoginScreen(),
            '/register': (_) => const RegisterScreen(),
            '/scan': (_) => const QRScannerScreen(),
            '/saved': (_) => const SavedQrScreen(),
          },
        ),
      ),
    );
  }
}