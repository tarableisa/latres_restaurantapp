import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyUsername);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPassword, password);
  }

  Future<bool> validateLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUsername = prefs.getString(_keyUsername);
    final storedPassword = prefs.getString(_keyPassword);
    return username == storedUsername && password == storedPassword;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
  }
}
