import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';

class AuthState extends ChangeNotifier {
  User? _user;
  
  User? get value => _user;
  
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }
  
  void logout() {
    _user = null;
    notifyListeners();
  }
}

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  return AuthState();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});