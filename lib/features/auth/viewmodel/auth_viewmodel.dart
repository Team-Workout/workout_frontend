import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/auth/repository/auth_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewState {
  final bool isLoading;
  final String? error;

  const AuthViewState({
    this.isLoading = false,
    this.error,
  });

  AuthViewState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AuthViewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthViewState> {
  final AuthRepository _repository;
  final AuthState _authState;
  final SessionService _sessionService;

  AuthViewModel(this._repository, this._authState, this._sessionService)
      : super(const AuthViewState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(email, password);
      _authState.setUser(user); // 로그인 성공 시 사용자 상태 설정
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is Exception ? e.toString() : '인증 오류가 발생했습니다.',
      );
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? gender,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.signup(
        email: email,
        password: password,
        name: name,
        userType: userType,
        phoneNumber: phoneNumber,
        gender: gender,
      );
      _authState.setUser(user); // 회원가입 성공 시 사용자 상태 설정
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e is Exception ? e.toString() : '인증 오류가 발생했습니다.',
      );
    }
  }

  Future<void> logout() async {
    // logout 메서드를 repository를 통해 호출
    await _repository.logout();
    _authState.logout();
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  final sessionService = ref.watch(sessionServiceProvider);
  return AuthViewModel(repository, authState, sessionService);
});
