import 'package:flutter/material.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/services/local_auth_repository.dart';
import 'package:my_project/services/app_state.dart';
import 'package:my_project/services/connectivity_service.dart';
import 'package:my_project/services/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authRepo = LocalAuthRepository();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final isConnected = await ConnectivityService.checkInternetConnection();
    if (!mounted) return;

    if (!isConnected) {
      showSnackBar(context, 'Немає з’єднання з Інтернетом');
      return;
    }

    if (_formKey.currentState!.validate()) {
      final success = await _authRepo.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        await AuthService.saveLoginStatus(true);

        if (!mounted) return;

        await Provider.of<AppState>(context, listen: false)
            .loadUserSettings(_emailController.text);

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Невірний email або пароль')),
        );
      }
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value != null && value.contains('@') ? null : 'Введіть коректний email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) =>
                value != null && value.length >= 6 ? null : 'Пароль має містити щонайменше 6 символів',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Увійти'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _goToRegister,
                child: const Text("Ще не маєш акаунта? Зареєструйся"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
