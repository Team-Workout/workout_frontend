import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'api_auth_repository.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? gender,
    String? goal,
  });
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'trainer@test.com' && password == '123456') {
      return const User(
        id: '1',
        email: 'trainer@test.com',
        name: '김트레이너',
        userType: UserType.trainer,
        phoneNumber: '010-1234-5678',
      );
    } else if (email == 'member@test.com' && password == '123456') {
      return const User(
        id: '2',
        email: 'member@test.com',
        name: '이회원',
        userType: UserType.member,
        phoneNumber: '010-2345-6789',
      );
    } else if (email == 'manager@test.com' && password == '123456') {
      return const User(
        id: '3',
        email: 'manager@test.com',
        name: '박관장',
        userType: UserType.manager,
        phoneNumber: '010-3456-7890',
      );
    }
    
    throw Exception('이메일 또는 비밀번호가 일치하지 않습니다');
  }
  
  @override
  Future<User> signup({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? gender,
    String? goal,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      userType: userType,
      phoneNumber: phoneNumber,
      createdAt: DateTime.now(),
    );
  }
  
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Using the API implementation instead of mock
  // If you want to use mock for testing, you can switch back to MockAuthRepository()
  return ref.watch(apiAuthRepositoryProvider);
});