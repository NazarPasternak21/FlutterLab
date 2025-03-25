import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  double _preferredTemp = 60.0;
  TimeOfDay _reminderTime = TimeOfDay(hour: 10, minute: 0);

  double get preferredTemp => _preferredTemp;
  TimeOfDay get reminderTime => _reminderTime;

  void setPreferredTemp(double temp) {
    _preferredTemp = temp;
    notifyListeners();
  }

  void setReminderTime(TimeOfDay time) {
    _reminderTime = time;
    notifyListeners();
  }
}
