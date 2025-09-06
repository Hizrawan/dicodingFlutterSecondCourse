import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  String? _username;
  bool _isLoggedIn = false;

  String? get username => _username;
  bool get isLoggedIn => _isLoggedIn;

  void login(String email, String password) {
    // Simple validation - in real app, you'd validate with backend
    if (email.isNotEmpty && password.isNotEmpty) {
      _username = email.split('@').first; // Extract username from email
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _username = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void checkLoginStatus() {
    // Since we're not using persistent storage, 
    // user will need to login again when app restarts
    _isLoggedIn = false;
    _username = null;
    notifyListeners();
  }
}
