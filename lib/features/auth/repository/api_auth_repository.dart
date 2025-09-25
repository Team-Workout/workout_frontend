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
      
      // 서버 응답이 {data: {...}} 구조인지 확인
      final actualUserData = userData['data'] ?? userData;

      // Session is automatically handled by SessionService via interceptor

      // role을 확인하여 UserType 결정
      UserType userType;
      final roleValue = actualUserData['role']?.toString()?.toUpperCase();

      print('=== Login API Response Debug ===');
      print('Raw role from server: ${actualUserData['role']}');
      print('Converted role: $roleValue');

      if (roleValue == 'TRAINER') {
        userType = UserType.trainer;
        print('Mapped to UserType.trainer');
      } else if (roleValue == 'MANAGER') {
        userType = UserType.manager;
        print('Mapped to UserType.manager');
      } else {
        userType = UserType.member; // 기본값 (MEMBER or USER)
        print('Mapped to UserType.member (default)');
      }

      // 간단한 응답 처리: id와 name만 받음
      return User(
        id: actualUserData['id']?.toString() ?? '',
        email: email, // 로그인 시 입력한 이메일 사용
        name: actualUserData['name'] ?? '',
        userType: userType,
        phoneNumber: null,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      throw Exception('로그인 실패: 인증 오류가 발생했습니다.');
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
      // Use correct endpoints based on user type
      final endpoint = userType == UserType.trainer
          ? '/auth/signup/trainer'  // 트레이너 전용 엔드포인트
          : '/auth/signup/user';    // 일반 회원 전용 엔드포인트

      final requestData = {
        'gymId': 1,
        'email': email,
        'password': password,
        'name': name,
        'gender': gender?.toUpperCase() ?? 'MALE',
        'role': _mapUserTypeToRole(userType),
      };

      print('=== Signup Request Debug ===');
      print('Endpoint: $endpoint');
      print('UserType: $userType');
      print('Mapped Role: ${_mapUserTypeToRole(userType)}');
      print('Request Data: $requestData');

      final response = await _apiService.post(
        endpoint,
        data: requestData,
      );

      // 서버가 단순히 ID만 반환하는 경우 처리
      String userId;
      if (response.data is int || response.data is String) {
        // 응답이 단순 ID 값인 경우
        userId = response.data.toString();
      } else if (response.data is Map) {
        // 응답이 객체인 경우
        final userData = response.data as Map;
        userId = userData['id']?.toString() ?? userData['userId']?.toString() ?? '';
      } else {
        // 예상치 못한 응답 형식
        userId = '';
      }

      // Session is automatically handled by SessionService via interceptor

      return User(
        id: userId,
        email: email,
        name: name,
        userType: userType,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      // 더 구체적인 에러 메시지 전달
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('회원가입 실패: 서버 오류가 발생했습니다.');
    }
  }

  @override
  Future<Map<String, dynamic>> signupSocial({
    required int gymId,
    required String name,
    required String gender,
    required String role,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/signup/social',
        data: {
          'gymId': gymId,
          'name': name,
          'gender': gender,
          'role': role,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else if (response.data is int || response.data is String) {
        return {'id': response.data.toString()};
      } else {
        return {'id': ''};
      }
    } catch (e) {
      if (e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception('소셜 회원가입 실패: 서버 오류가 발생했습니다.');
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
    } finally {
      // Clear local session
      await _sessionService.clearSession();
    }
  }


  String _mapUserTypeToRole(UserType userType) {
    switch (userType) {
      case UserType.trainer:
        return 'TRAINER';
      case UserType.manager:
        return 'MANAGER';
      case UserType.member:
        return 'MEMBER';
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
