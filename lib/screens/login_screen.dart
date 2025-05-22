import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth/auth_cubit.dart';
import 'package:my_project/cubit/auth/auth_state.dart';
import 'package:my_project/cubit/connection/connection_cubit.dart';
import 'package:my_project/cubit/connection/connection_state.dart';
import 'package:my_project/cubit/profile/profile_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _handleAutoLogin();
  }

  Future<void> _handleAutoLogin() async {
    final authCubit = context.read<AuthCubit>();
    final profileCubit = context.read<ProfileCubit>();

    final loggedIn = await authCubit.autoLogin();
    if (!mounted) return;

    final state = authCubit.state;
    if (loggedIn && state is AuthSuccess) {
      profileCubit.setEmail(state.email);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _submitLogin() {
    final connectionState = context.read<ConnectionCubit>().state;
    if (connectionState is InternetFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Немає інтернету')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      context.read<AuthCubit>().login(email, password);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final connectionState = context.watch<ConnectionCubit>().state;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (connectionState is InternetFailure)
                    const Text(
                      'Немає інтернету',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                    value!.isEmpty ? 'Введіть email' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    validator: (value) =>
                    value!.isEmpty ? 'Введіть пароль' : null,
                  ),
                  const SizedBox(height: 20),
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submitLogin,
                      child: const Text('Увійти'),
                    ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Зареєструватися'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
