import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/services/connectivity_service.dart';

class LocalAuthRepository {
  static const _usersKey = 'users';
  static const _emailKey = 'email';
  static const _isLoggedInKey = 'isLoggedIn';

  Future<void> registerUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    final users = usersJson != null ? Map<String, String>.from(jsonDecode(usersJson)) : {};

    users[email] = password;

    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_emailKey, email);
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return false;

    final users = Map<String, String>.from(jsonDecode(usersJson));
    final isMatch = users[email] == password;
    if (isMatch) {
      await prefs.setString(_emailKey, email);
      await prefs.setBool(_isLoggedInKey, true);
    }
    return isMatch;
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_emailKey);
  }

  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getUserPassword(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    final users = Map<String, String>.from(jsonDecode(usersJson));
    return users[email];
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

    if (isLoggedIn && email != null) {
      final isConnected = await ConnectivityService.checkInternetConnection();
      if (!isConnected) {
        print('Автологін без Інтернету');
      }
      return true;
    }
    return false;
  }
}
