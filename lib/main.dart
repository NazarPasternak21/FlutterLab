import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  const PasswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  const PasswordGeneratorScreen({super.key});

  @override
  State<PasswordGeneratorScreen> createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  double _passwordLength = 12;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = false;

  String _generatedPassword = '';

  void _generatePassword() {
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numberChars = '0123456789';
    const symbolChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    String chars = '';
    if (_includeLowercase) chars += lowercaseChars;
    if (_includeUppercase) chars += uppercaseChars;
    if (_includeNumbers) chars += numberChars;
    if (_includeSymbols) chars += symbolChars;

    if (chars.isEmpty) {
      setState(() {
        _generatedPassword = 'Оберіть хоча б одну опцію!';
      });
      return;
    }

    final rand = Random.secure();
    final password = List.generate(
      _passwordLength.toInt(),
      (index) => chars[rand.nextInt(chars.length)],
    ).join();

    setState(() {
      _generatedPassword = password;
    });
  }

  void _copyPassword() {
    if (_generatedPassword.isNotEmpty &&
        _generatedPassword != 'Оберіть хоча б одну опцію!') {
      Clipboard.setData(ClipboardData(text: _generatedPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароль скопійовано!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _generatePassword();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Генератор паролів'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        _generatedPassword,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: _copyPassword,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionSwitch(
              title: 'Великі літери',
              value: _includeUppercase,
              onChanged: (val) =>
                  setState(() => _includeUppercase = val),
            ),
            _buildOptionSwitch(
              title: 'Малі літери',
              value: _includeLowercase,
              onChanged: (val) =>
                  setState(() => _includeLowercase = val),
            ),
            _buildOptionSwitch(
              title: 'Цифри',
              value: _includeNumbers,
              onChanged: (val) => setState(() => _includeNumbers = val),
            ),
            _buildOptionSwitch(
              title: 'Символи',
              value: _includeSymbols,
              onChanged: (val) => setState(() => _includeSymbols = val),
            ),
            const SizedBox(height: 20),
            Text('Довжина пароля: ${_passwordLength.toInt()}'),
            Slider(
              value: _passwordLength,
              min: 4,
              max: 32,
              divisions: 28,
              label: _passwordLength.toInt().toString(),
              onChanged: (val) => setState(() => _passwordLength = val),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Згенерувати пароль'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: _generatePassword,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}
