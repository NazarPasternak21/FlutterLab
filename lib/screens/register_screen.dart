import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'), 
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть email';
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Некоректний формат email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),  
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введіть пароль';
                  }
                  if (value.length < 6) {
                    return 'Пароль має містити щонайменше 6 символів';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),  
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Підтвердити пароль'),  
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Підтвердьте пароль';
                  }
                  if (value != _passwordController.text) {
                    return 'Паролі не співпадають';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),  
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: const Text('Зареєструватися'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вже є акаунт? Увійти'),  
              ),
            ],
          ),
        ),
      ),
    );
  }
}
