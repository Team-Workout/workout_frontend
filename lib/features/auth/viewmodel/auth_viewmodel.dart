import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/auth/repository/auth_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';
import 'package:pt_service/core/services/session_service.dart';
import 'package:pt_service/core/services/storage_service.dart';
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

  String _getKoreanErrorMessage(String errorMessage) {
    final error = errorMessage.toLowerCase();
    
    if (error.contains('password') || error.contains('비밀번호')) {
      return '비밀번호가 올바르지 않습니다.';
    } else if (error.contains('email') || error.contains('이메일')) {
      return '존재하지 않는 이메일입니다.';
    } else if (error.contains('invalid credentials') || error.contains('로그인 실패')) {
      return '이메일 또는 비밀번호를 확인해주세요.';
    } else if (error.contains('user not found') || error.contains('사용자를 찾을 수 없습니다')) {
      return '등록되지 않은 사용자입니다.';
    } else if (error.contains('already exists') || error.contains('이미 존재')) {
      return '이미 등록된 이메일입니다.';
    } else if (error.contains('weak password') || error.contains('약한 비밀번호')) {
      return '비밀번호가 너무 약합니다. 8자 이상 입력해주세요.';
    } else if (error.contains('invalid email') || error.contains('잘못된 이메일')) {
      return '올바른 이메일 형식을 입력해주세요.';
    } else if (error.contains('network') || error.contains('네트워크')) {
      return '네트워크 연결을 확인해주세요.';
    } else if (error.contains('server') || error.contains('서버')) {
      return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
    } else if (error.contains('timeout') || error.contains('시간 초과')) {
      return '요청 시간이 초과되었습니다. 다시 시도해주세요.';
    } else if (error.contains('회원가입 실패') || error.contains('signup failed')) {
      return '회원가입 중 오류가 발생했습니다. 다시 시도해주세요.';
    } else if (error.contains('exception:')) {
      // "Exception: " 부분 제거하고 나머지 메시지 반환
      return errorMessage.replaceAll(RegExp(r'Exception:\s*'), '');
    } else if (errorMessage.startsWith('Exception: ')) {
      // "Exception: " 부분 제거하고 나머지 메시지 반환  
      return errorMessage.substring(11);
    } else {
      return '인증 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
  }

  Future<void> login(String email, String password, {bool isAutoLogin = false}) async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(email, password);
      if (!mounted) return;
      _authState.setUser(user); // 로그인 성공 시 사용자 상태 설정
      
      // 자동 로그인이 아닌 경우에만 자동로그인 설정을 저장
      if (!isAutoLogin) {
        final autoLoginEnabled = await StorageService.getAutoLoginEnabled();
        if (autoLoginEnabled) {
          await StorageService.saveUserCredentials(email, password);
        }
      }
      
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
      final errorMessage = e.toString();
      state = state.copyWith(
        isLoading: false,
        error: _getKoreanErrorMessage(errorMessage),
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
      final errorMessage = e.toString();
      state = state.copyWith(
        isLoading: false,
        error: _getKoreanErrorMessage(errorMessage),
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

  // 자동 로그인 설정 저장
  Future<void> setAutoLogin(bool enabled) async {
    await StorageService.setAutoLoginEnabled(enabled);
  }

  // 자동 로그인 체크
  Future<bool> tryAutoLogin() async {
    try {
      final autoLoginEnabled = await StorageService.getAutoLoginEnabled();
      if (!autoLoginEnabled) return false;

      final credentials = await StorageService.getUserCredentials();
      final email = credentials['email'];
      final password = credentials['password'];

      if (email != null && password != null && email.isNotEmpty && password.isNotEmpty) {
        await login(email, password, isAutoLogin: true);
        return true;
      }
      return false;
    } catch (e) {
      print('Auto login failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    // 자동 로그인 데이터 정리
    await StorageService.clearAutoLoginData();
    
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
