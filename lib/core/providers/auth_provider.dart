import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 라우팅용 간단한 인증 상태 (로그인/로그아웃만 추적)
class AuthRouterState extends ChangeNotifier {
  bool _isLoggedIn = false;
  UserType? _userType;
  
  bool get isLoggedIn => _isLoggedIn;
  UserType? get userType => _userType;
  
  void setLoginState(bool isLoggedIn, UserType? userType) {
    if (_isLoggedIn != isLoggedIn || _userType != userType) {
      _isLoggedIn = isLoggedIn;
      _userType = userType;
      notifyListeners(); // 라우터 refresh
    }
  }
}

class AuthState extends ChangeNotifier {
  User? _user;
  bool _initialized = false;
  AuthRouterState? _routerState;

  User? get value => _user;
  bool get isLoggedIn => _user != null;
  bool get initialized => _initialized;
  
  void setRouterState(AuthRouterState routerState) {
    _routerState = routerState;
  }

  void setUser(User? user) {
    _user = user;
    _saveUserToPrefs();
    // 라우터 상태도 업데이트 (로그인/로그아웃 시에만)
    _routerState?.setLoginState(user != null, user?.userType);
    notifyListeners();
  }

  void logout() {
    _user = null;
    _clearUserFromPrefs();
    // 라우터 상태도 업데이트 (로그인/로그아웃 시에만)
    _routerState?.setLoginState(false, null);
    notifyListeners();
  }

  // 초기화 - 저장된 사용자 정보 로드
  Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUserFlag = prefs.getString('current_user');
      
      if (currentUserFlag == 'logged_in') {
        final userId = prefs.getString('user_id');
        final email = prefs.getString('user_email');
        final name = prefs.getString('user_name');
        final userTypeStr = prefs.getString('user_type');
        final profileImageUrl = prefs.getString('user_profile_image_url');
        
        if (userId != null && email != null && name != null && userTypeStr != null) {
          // UserType enum 변환
          UserType? userType;
          if (userTypeStr.contains('trainer')) {
            userType = UserType.trainer;
          } else if (userTypeStr.contains('member')) {
            userType = UserType.member;
          } else if (userTypeStr.contains('manager')) {
            userType = UserType.manager;
          }
          
          if (userType != null) {
            _user = User(
              id: userId,
              email: email,
              name: name,
              userType: userType,
              profileImageUrl: profileImageUrl,
            );
            // 라우터 상태도 업데이트
            _routerState?.setLoginState(true, userType);
            print('✅ AuthState initialized with saved user: $name (${userType.toString()})');
          }
        }
      }
    } catch (e) {
      print('Error initializing AuthState: $e');
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  // 프로필 이미지 URL 업데이트
  void updateProfileImageUrl(String? profileImageUrl) {
    print('🔄 AuthState.updateProfileImageUrl called with: $profileImageUrl');
    print('🔄 Current user before update: $_user');
    if (_user != null) {
      _user = _user!.copyWith(profileImageUrl: profileImageUrl);
      print('🔄 User after update: $_user');
      _saveUserToPrefs();
      notifyListeners();
      print('🔄 notifyListeners() called');
    } else {
      print('❌ _user is null, cannot update profile image URL');
    }
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
      if (_user!.profileImageUrl != null) {
        await prefs.setString('user_profile_image_url', _user!.profileImageUrl!);
      }
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
      await prefs.remove('user_profile_image_url');
      await prefs.remove('current_user');
    } catch (e) {
      // 삭제 실패시 로그 출력 등
    }
  }
}

// 라우터용 인증 상태 (로그인/로그아웃만 추적)
final authRouterStateProvider = ChangeNotifierProvider<AuthRouterState>((ref) {
  return AuthRouterState();
});

final authStateProvider = ChangeNotifierProvider<AuthState>((ref) {
  final authState = AuthState();
  final routerState = ref.read(authRouterStateProvider);
  authState.setRouterState(routerState); // 라우터 상태 연결
  authState.initialize(); // 저장된 사용자 정보 로드
  return authState;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});
