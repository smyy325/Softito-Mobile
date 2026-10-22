import 'package:flutter/material.dart';

/// Kimlik doğrulama ve kullanıcı oturumu için Provider
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _userName = 'Sümeyye';
  String _userEmail = 'sumeyye@modumgalaxy.com';

  bool get isAuthenticated => _isAuthenticated;
  String get userName => _userName;
  String get userEmail => _userEmail;

  /// Giriş Yap simülasyonu
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Asenkron Event Loop uyumu
    _isAuthenticated = true;
    _userEmail = email.trim();
    if (_userEmail.contains('@')) {
      _userName = _userEmail.split('@').first;
      _userName = _userName[0].toUpperCase() + _userName.substring(1);
    }
    notifyListeners();
    return true;
  }

  /// Kayıt Ol simülasyonu
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _isAuthenticated = true;
    _userName = name.trim();
    _userEmail = email.trim();
    notifyListeners();
    return true;
  }

  /// Şifre Sıfırlama simülasyonu
  Future<bool> resetPassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
    return true;
  }

  /// Çıkış Yap
  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
