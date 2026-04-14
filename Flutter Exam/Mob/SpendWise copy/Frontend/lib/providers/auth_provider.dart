import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../database/database_helper.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _token != null;
  String? get token => _token;
  String get userName => _userName ?? 'User';
  String? get userEmail => _userEmail;

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    DatabaseHelper.setToken(_token); // keep API calls authorised after app restart
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    try {
      final data = await AuthService.login(email: email, password: password);
      if (data.containsKey('error')) return data['error'] as String;
      await _persistUser(data);
      return null;
    } catch (e) {
      return 'Connection failed. Is the server running?';
    }
  }

  Future<String?> register(String name, String email, String password) async {
    try {
      final data = await AuthService.register(name: name, email: email, password: password);
      if (data.containsKey('error')) return data['error'] as String;
      await _persistUser(data);
      return null;
    } catch (e) {
      return 'Connection failed. Is the server running?';
    }
  }

  Future<void> _persistUser(Map<String, dynamic> data) async {
    _token = data['token'] as String;
    final user = data['user'] as Map<String, dynamic>;
    _userName = user['name'] as String;
    _userEmail = user['email'] as String;
    DatabaseHelper.setToken(_token); // authorise future API calls
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', _token!);
    await prefs.setString('user_name', _userName!);
    await prefs.setString('user_email', _userEmail!);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userName = null;
    _userEmail = null;
    DatabaseHelper.setToken(null); // clear token from API layer
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    notifyListeners();
  }
}
