import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState extends ChangeNotifier {
  User? _user;

  User? get value => _user;
  bool get isLoggedIn => _user != null;

  void setUser(User? user) {
    _user = user;
    _saveUserToPrefs();
    notifyListeners();
  }

  void logout() {
    _user = null;
    _clearUserFromPrefs();
    notifyListeners();
  }

  // 사용자 정보를 SharedPreferences에 저장
  Future<void> _saveUserToPrefs() async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _user!.id);
      await prefs.setString('user_email', _user!.email);
      await prefs.setString('user_name', _user!.name);
      await prefs.setString('user_type', _user!.userType.toString());
      await prefs.setString('current_user', 'logged_in'); // 간단한 플래그
    } catch (e) {
      // 저장 실패시 로그 출력 등
    }
  }

  // 저장된 사용자 정보 삭제
  Future<void> _clearUserFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
      await prefs.remove('user_type');
      await prefs.remove('current_user');
    } catch (e) {
      // 삭제 실패시 로그 출력 등
    }
  }
}

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});
