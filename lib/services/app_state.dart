import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  double _preferredTemp = 35.0;
  TimeOfDay _reminderTime = TimeOfDay(hour: 8, minute: 0);
  String? _userEmail;

  double get preferredTemp => _preferredTemp;
  TimeOfDay get reminderTime => _reminderTime;
  String? get userEmail => _userEmail;

  Future<void> loadUserSettings(String email) async {
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();

    _preferredTemp = prefs.getDouble('temp_$email') ?? 35.0;

    final hour = prefs.getInt('reminder_hour_$email') ?? 8;
    final minute = prefs.getInt('reminder_minute_$email') ?? 0;
    _reminderTime = TimeOfDay(hour: hour, minute: minute);

    notifyListeners();
  }

  Future<void> setPreferredTemp(double value) async {
    _preferredTemp = value;
    notifyListeners();

    if (_userEmail != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('temp_${_userEmail!}', value);
    }
  }

  Future<void> setReminderTime(TimeOfDay value) async {
    _reminderTime = value;
    notifyListeners();

    if (_userEmail != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('reminder_hour_${_userEmail!}', value.hour);
      await prefs.setInt('reminder_minute_${_userEmail!}', value.minute);
    }
  }
}