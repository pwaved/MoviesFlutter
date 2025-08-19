import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movies_fullstack/api/backend_api_service.dart';

class AuthService extends ChangeNotifier {
  final BackendApiService _apiService = BackendApiService();
  String? _token;
  int? _userId;
  bool _isLoggedIn = false;

  String? get token => _token;
  int? get userId => _userId; 
  bool get isLoggedIn => _isLoggedIn;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userId = prefs.getInt('userId');
    if (_token != null && _userId != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final response = await _apiService.login(email, password);
    _token = response['token'];
    _userId = response['user']['id'];
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setInt('userId', _userId!);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    notifyListeners();
  }
}