import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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

  ProfileImageNotifier(this._repository) : super(const AsyncValue.data(null));

  Future<void> loadProfileImage() async {
    state = const AsyncValue.loading();
    try {
      final profileImage = await _repository.getProfileImage();
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
      state = AsyncValue.data(profileImage);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}