import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/settings_repository.dart';
import '../model/profile_image_model.dart';
import '../model/privacy_settings_model.dart';

final workoutLogAccessProvider =
    StateNotifierProvider<WorkoutLogAccessNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return WorkoutLogAccessNotifier(repository);
});

class WorkoutLogAccessNotifier extends StateNotifier<AsyncValue<bool>> {
  final SettingsRepository _repository;

  WorkoutLogAccessNotifier(this._repository)
      : super(const AsyncValue.data(false));

  Future<void> toggleWorkoutLogAccess(bool isOpen) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updateWorkoutLogAccess(isOpen: isOpen);
      state = AsyncValue.data(isOpen);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// 프로필 이미지 관리 Provider
final profileImageProvider =
    StateNotifierProvider<ProfileImageNotifier, AsyncValue<ProfileImageInfo?>>(
        (ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ProfileImageNotifier(repository);
});

class ProfileImageNotifier
    extends StateNotifier<AsyncValue<ProfileImageInfo?>> {
  final SettingsRepository _repository;
  static const String _cacheKey = 'profile_image_url';
  static const String _timestampKey = 'profile_image_url_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 1); // 1시간 캐시

  ProfileImageNotifier(this._repository) : super(const AsyncValue.loading()) {
    // 초기화 시 바로 로드 시작
    _initializeProfileImage();
  }
  
  void _initializeProfileImage() async {
    await loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    // 캐시된 URL이 있고 유효한지 확인
    final cachedUrl = await _getCachedProfileImageUrl();
    if (cachedUrl != null) {
      print('Using cached profile image URL: $cachedUrl');
      state = AsyncValue.data(ProfileImageInfo(profileImageUrl: cachedUrl));
      return;
    }

    state = const AsyncValue.loading();
    try {
      print('Loading profile image URL from server...');
      final profileImage = await _repository.getProfileImage();

      // URL을 캐시에 저장
      if (profileImage?.profileImageUrl != null) {
        await _cacheProfileImageUrl(profileImage!.profileImageUrl);
      }

      state = AsyncValue.data(profileImage);
    } catch (e) {
      // 프로필 이미지 로드 실패시 default-profile.png로 fallback
      final defaultProfileImage = ProfileImageInfo(
        profileImageUrl: '/images/default-profile.png'
      );
      state = AsyncValue.data(defaultProfileImage);
    }
  }

  Future<void> uploadProfileImage(XFile imageFile) async {
    state = const AsyncValue.loading();
    try {
      final uploadResponse = await _repository.uploadProfileImage(imageFile);
      // 업로드 성공 후 현재 프로필 이미지 정보 새로고침
      final profileImage =
          ProfileImageInfo(profileImageUrl: uploadResponse.fileUrl);

      // 새로운 URL을 캐시에 저장
      await _cacheProfileImageUrl(uploadResponse.fileUrl);

      state = AsyncValue.data(profileImage);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProfileImage() async {
    state = const AsyncValue.loading();
    try {
      // API 호출 대신 바로 default-profile.png로 설정
      // 실제 삭제 API는 호출하지 않음 (복잡성 방지)

      // 캐시 클리어
      await _clearCachedProfileImageUrl();

      // default-profile.png로 설정
      final defaultProfileImage =
          ProfileImageInfo(profileImageUrl: '/images/default-profile.png');

      state = AsyncValue.data(defaultProfileImage);
    } catch (e, stack) {
      // 에러가 발생해도 default로 설정
      final defaultProfileImage =
          ProfileImageInfo(profileImageUrl: 'default-profile.png');
      state = AsyncValue.data(defaultProfileImage);
    }
  }

  Future<String?> _getCachedProfileImageUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedUrl = prefs.getString(_cacheKey);
      final timestamp = prefs.getInt(_timestampKey);

      if (cachedUrl != null && timestamp != null) {
        final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
        if (cacheAge < _cacheExpiry.inMilliseconds) {
          return cachedUrl;
        } else {
          // 캐시 만료됨, 삭제
          await _clearCachedProfileImageUrl();
        }
      }
    } catch (e) {
      print('Error loading cached profile image URL: $e');
    }
    return null;
  }

  Future<void> _cacheProfileImageUrl(String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, url);
      await prefs.setInt(_timestampKey, DateTime.now().millisecondsSinceEpoch);
      print('Cached profile image URL: $url');
    } catch (e) {
      print('Error caching profile image URL: $e');
    }
  }

  Future<void> _clearCachedProfileImageUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      await prefs.remove(_timestampKey);
      print('Cleared cached profile image URL');
    } catch (e) {
      print('Error clearing cached profile image URL: $e');
    }
  }

  // 캐시 강제 새로고침
  Future<void> refreshProfileImage() async {
    try {
      await _clearCachedProfileImageUrl();
      await loadProfileImage();
    } catch (e) {
      // refresh 실패시에도 default로 fallback
      final defaultProfileImage = ProfileImageInfo(
        profileImageUrl: '/images/default-profile.png'
      );
      state = AsyncValue.data(defaultProfileImage);
    }
  }
}

// 회원 정보 Provider
final memberInfoProvider = StateNotifierProvider<MemberInfoNotifier, AsyncValue<MemberInfo?>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return MemberInfoNotifier(repository);
});

class MemberInfoNotifier extends StateNotifier<AsyncValue<MemberInfo?>> {
  final SettingsRepository _repository;

  MemberInfoNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> loadMemberInfo() async {
    state = const AsyncValue.loading();
    try {
      final memberInfo = await _repository.getMemberInfo();
      state = AsyncValue.data(memberInfo);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// 개인정보 공개 설정 Provider
final privacySettingsProvider = StateNotifierProvider<PrivacySettingsNotifier, AsyncValue<PrivacySettings?>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return PrivacySettingsNotifier(repository);
});

class PrivacySettingsNotifier extends StateNotifier<AsyncValue<PrivacySettings?>> {
  final SettingsRepository _repository;

  PrivacySettingsNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> loadPrivacySettings() async {
    state = const AsyncValue.loading();
    try {
      final memberInfo = await _repository.getMemberInfo();
      final privacySettings = PrivacySettings(
        isOpenWorkoutRecord: memberInfo.isOpenWorkoutRecord,
        isOpenBodyImg: memberInfo.isOpenBodyImg,
        isOpenBodyComposition: memberInfo.isOpenBodyComposition,
      );
      state = AsyncValue.data(privacySettings);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updatePrivacySettings(PrivacySettings settings) async {
    state = const AsyncValue.loading();
    try {
      await _repository.updatePrivacySettings(settings);
      state = AsyncValue.data(settings);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggleWorkoutRecord(bool value) async {
    final current = state.value;
    if (current == null) return;

    // 낙관적 업데이트: 즉시 UI 업데이트
    final updated = current.copyWith(isOpenWorkoutRecord: value);
    state = AsyncValue.data(updated);

    try {
      // 백그라운드에서 서버 업데이트
      await _repository.updatePrivacySettings(updated);
    } catch (e) {
      // 실패 시 이전 상태로 롤백
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, StackTrace.current);
      rethrow; // UI에서 에러를 처리할 수 있도록
    }
  }

  Future<void> toggleBodyImg(bool value) async {
    final current = state.value;
    if (current == null) return;

    // 낙관적 업데이트: 즉시 UI 업데이트
    final updated = current.copyWith(isOpenBodyImg: value);
    state = AsyncValue.data(updated);

    try {
      // 백그라운드에서 서버 업데이트
      await _repository.updatePrivacySettings(updated);
    } catch (e) {
      // 실패 시 이전 상태로 롤백
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> toggleBodyComposition(bool value) async {
    final current = state.value;
    if (current == null) return;

    // 낙관적 업데이트: 즉시 UI 업데이트
    final updated = current.copyWith(isOpenBodyComposition: value);
    state = AsyncValue.data(updated);

    try {
      // 백그라운드에서 서버 업데이트
      await _repository.updatePrivacySettings(updated);
    } catch (e) {
      // 실패 시 이전 상태로 롤백
      state = AsyncValue.data(current);
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
