import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/session_service.dart';
import '../model/user_model.dart';
import 'auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs;
  final SessionService _sessionService;

  ApiAuthRepository(this._apiService, this._prefs, this._sessionService);

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/signin',
        data: {
          'email': email,
          'password': password,
        },
      );

      final userData = response.data;
      
      // Store token if returned
      if (userData['token'] != null) {
        await _prefs.setString('auth_token', userData['token']);
      }

      // Map API response to User model
      return User(
        id: userData['id']?.toString() ?? '',
        email: userData['email'] ?? email,
        name: userData['name'] ?? '',
        userType: _mapRoleToUserType(userData['role']),
        phoneNumber: userData['phoneNumber'],
        createdAt: userData['createdAt'] != null 
            ? DateTime.parse(userData['createdAt']) 
            : DateTime.now(),
      );
    } catch (e) {
      throw Exception('로그인 실패: ${e.toString()}');
    }
  }

  @override
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? gender,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/signup',
        data: {
          'gymId': 1, // Default gym ID
          'email': email,
          'password': password,
          'name': name,
          'gender': gender?.toUpperCase() ?? 'MALE',
          'role': _mapUserTypeToRole(userType),
        },
      );

      final userData = response.data;
      
      // Store token if returned
      if (userData['token'] != null) {
        await _prefs.setString('auth_token', userData['token']);
      }

      return User(
        id: userData['id']?.toString() ?? '',
        email: userData['email'] ?? email,
        name: userData['name'] ?? name,
        userType: userType,
        phoneNumber: phoneNumber,
        createdAt: userData['createdAt'] != null 
            ? DateTime.parse(userData['createdAt']) 
            : DateTime.now(),
      );
    } catch (e) {
      throw Exception('회원가입 실패: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout API if session exists
      if (_sessionService.hasSession) {
        await _apiService.post('/auth/logout');
      }
    } catch (e) {
      // Even if logout API fails, we still clear local session
      print('Logout API error: $e');
    } finally {
      // Clear local session and tokens
      await _sessionService.clearSession();
      await _prefs.remove('auth_token');
    }
  }

  UserType _mapRoleToUserType(String? role) {
    switch (role?.toUpperCase()) {
      case 'TRAINER':
        return UserType.trainer;
      case 'MANAGER':
        return UserType.manager;
      case 'USER':
      case 'MEMBER':
      default:
        return UserType.member;
    }
  }

  String _mapUserTypeToRole(UserType userType) {
    switch (userType) {
      case UserType.trainer:
        return 'TRAINER';
      case UserType.manager:
        return 'MANAGER';
      case UserType.member:
        return 'USER';
    }
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final apiAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  final sessionService = ref.watch(sessionServiceProvider);
  return ApiAuthRepository(apiService, prefs, sessionService);
});