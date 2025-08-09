import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:pt_service/features/auth/repository/auth_repository.dart';
import 'package:pt_service/core/providers/auth_provider.dart';

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

  AuthViewModel(this._repository, this._authState) : super(const AuthViewState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(email, password);
      _authState.setUser(user);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
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
    String? goal,
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
        goal: goal,
      );
      _authState.setUser(user);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void logout() {
    _authState.logout();
  }
}

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthViewState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  return AuthViewModel(repository, authState);
});
