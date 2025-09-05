import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/settings_repository.dart';
import '../model/profile_image_model.dart';

final workoutLogAccessProvider = StateNotifierProvider<WorkoutLogAccessNotifier, AsyncValue<bool>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return WorkoutLogAccessNotifier(repository);
});

class WorkoutLogAccessNotifier extends StateNotifier<AsyncValue<bool>> {
  final SettingsRepository _repository;

  WorkoutLogAccessNotifier(this._repository) : super(const AsyncValue.data(false));

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
final profileImageProvider = StateNotifierProvider<ProfileImageNotifier, AsyncValue<ProfileImageInfo?>>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ProfileImageNotifier(repository);
});

class ProfileImageNotifier extends StateNotifier<AsyncValue<ProfileImageInfo?>> {
  final SettingsRepository _repository;
  static const String _cacheKey = 'profile_image_url';
  static const String _timestampKey = 'profile_image_url_timestamp';
  static const Duration _cacheExpiry = Duration(hours: 1); // 1시간 캐시

  ProfileImageNotifier(this._repository) : super(const AsyncValue.data(null));

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
    } catch (e, stack) {
      // 프로필 이미지가 없는 경우 null로 처리
      if (e.toString().contains('404') || e.toString().contains('찾을 수 없습니다')) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  Future<void> uploadProfileImage(XFile imageFile) async {
    state = const AsyncValue.loading();
    try {
      final uploadResponse = await _repository.uploadProfileImage(imageFile);
      // 업로드 성공 후 현재 프로필 이미지 정보 새로고침
      final profileImage = ProfileImageInfo(profileImageUrl: uploadResponse.fileUrl);
      
      // 새로운 URL을 캐시에 저장
      await _cacheProfileImageUrl(uploadResponse.fileUrl);
      
      state = AsyncValue.data(profileImage);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
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
    await _clearCachedProfileImageUrl();
    await loadProfileImage();
  }
}