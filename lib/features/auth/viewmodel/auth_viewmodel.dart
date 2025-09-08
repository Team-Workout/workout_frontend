import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/auth/repository/auth_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:pt_service/features/fcm/service/fcm_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewState {
  final bool isLoading;
  final String? error;
  final bool signupSuccess;
  final String? successMessage;

  const AuthViewState({
    this.isLoading = false,
    this.error,
    this.signupSuccess = false,
    this.successMessage,
  });

  AuthViewState copyWith({
    bool? isLoading,
    String? error,
    bool? signupSuccess,
    String? successMessage,
  }) {
    return AuthViewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      signupSuccess: signupSuccess ?? this.signupSuccess,
      successMessage: successMessage,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthViewState> {
  final AuthRepository _repository;
  final AuthState _authState;
  final SessionService _sessionService;
  final FCMApiService _fcmApiService;

  AuthViewModel(this._repository, this._authState, this._sessionService, this._fcmApiService)
      : super(const AuthViewState());

  Future<void> login(String email, String password) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(email, password);
      if (!mounted) return;
      _authState.setUser(user); // 로그인 성공 시 사용자 상태 설정
      
      // 로그인 성공 후 FCM 토큰을 백엔드로 전송
      try {
        await _fcmApiService.updateFCMToken();
        print('FCM token sent to backend after login');
      } catch (fcmError) {
        print('Failed to send FCM token after login: $fcmError');
        // FCM 토큰 전송 실패는 로그인 자체를 실패시키지 않음
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      if (!mounted) return;
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
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.signup(
        email: email,
        password: password,
        name: name,
        userType: userType,
        phoneNumber: phoneNumber,
        gender: gender,
      );
      if (!mounted) return;
      
      // 회원가입 성공 후 자동 로그인 시도
      try {
        final user = await _repository.login(email, password);
        if (!mounted) return;
        _authState.setUser(user);
        
        // FCM 토큰을 백엔드로 전송
        try {
          await _fcmApiService.updateFCMToken();
          print('FCM token sent to backend after signup');
        } catch (fcmError) {
          print('Failed to send FCM token after signup: $fcmError');
        }
        
        state = state.copyWith(
          isLoading: false,
          signupSuccess: true,
          successMessage: '회원가입이 완료되었습니다!',
        );
      } catch (loginError) {
        // 자동 로그인 실패 시 - 수동 로그인 유도
        if (!mounted) return;
        state = state.copyWith(
          isLoading: false,
          signupSuccess: true,
          successMessage: '회원가입이 완료되었습니다! 로그인해주세요.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e is Exception ? e.toString() : '인증 오류가 발생했습니다.',
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(
      error: null,
      successMessage: null,
      signupSuccess: false,
    );
  }

  Future<void> logout() async {
    // 로그아웃 시 FCM 토큰 삭제
    try {
      await _fcmApiService.deleteFCMToken();
      print('FCM token deleted from backend');
    } catch (e) {
      print('Failed to delete FCM token: $e');
      // FCM 토큰 삭제 실패는 로그아웃 자체를 실패시키지 않음
    }
    
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
  final fcmApiService = ref.watch(fcmApiServiceProvider);
  return AuthViewModel(repository, authState, sessionService, fcmApiService);
});
