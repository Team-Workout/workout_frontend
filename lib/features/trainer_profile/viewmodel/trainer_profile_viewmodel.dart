import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../model/trainer_profile_model.dart';
import '../repository/trainer_profile_repository.dart';

final trainerProfileRepositoryProvider = Provider<TrainerProfileRepository?>((ref) {
  final apiService = ref.watch(apiServiceProvider); 
  final currentUser = ref.read(currentUserProvider); // 사용자는 read로 유지
  
  // 현재 로그인한 사용자가 없으면 null 반환
  if (currentUser == null) return null;
  
  return TrainerProfileRepository(apiService, currentUser.id);
});

final trainerProfileViewModelProvider = 
    StateNotifierProvider<TrainerProfileViewModel, AsyncValue<TrainerProfile>>((ref) {
  final repository = ref.watch(trainerProfileRepositoryProvider);
  
  // repository가 null이면 (로그인하지 않은 경우) 에러 상태 반환
  if (repository == null) {
    return TrainerProfileViewModel(null);
  }
  
  return TrainerProfileViewModel(repository);
});

class TrainerProfileViewModel extends StateNotifier<AsyncValue<TrainerProfile>> {
  final TrainerProfileRepository? _repository;

  TrainerProfileViewModel(this._repository) : super(const AsyncValue.loading()) {
    if (_repository != null) {
      loadProfile();
    } else {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
    }
  }

  Future<void> loadProfile() async {
    if (_repository == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }
    
    try {
      state = const AsyncValue.loading();
      print('=== LOADING PROFILE ===');
      final profile = await _repository!.getTrainerProfile();
      print('Loaded profile in viewmodel:');
      print('- trainerId: ${profile.trainerId}');
      print('- name: ${profile.name}');
      print('- email: ${profile.email}');
      print('- introduction: ${profile.introduction}');
      print('- awards: ${profile.awards.map((a) => 'id:${a.id}, name:${a.awardName}').toList()}');
      print('- certifications: ${profile.certifications.map((c) => 'id:${c.id}, name:${c.certificationName}').toList()}');
      print('- educations: ${profile.educations.map((e) => 'id:${e.id}, school:${e.schoolName}').toList()}');
      print('- workExperiences: ${profile.workExperiences.map((w) => 'id:${w.id}, name:${w.workName}').toList()}');
      print('- specialties: ${profile.specialties}');
      print('=======================');
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      print('Error loading profile: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(TrainerProfile profile) async {
    if (_repository == null) {
      state = AsyncValue.error('로그인이 필요합니다', StackTrace.current);
      return;
    }
    
    try {
      state = const AsyncValue.loading();
      
      print('=== VIEWMODEL UPDATE PROFILE ===');
      print('Profile to update:');
      print('- trainerId: ${profile.trainerId}');
      print('- name: ${profile.name}');
      print('- email: ${profile.email}');
      print('- introduction: ${profile.introduction}');
      print('- awards: ${profile.awards.map((a) => 'id:${a.id}, name:${a.awardName}').toList()}');
      print('- certifications: ${profile.certifications.map((c) => 'id:${c.id}, name:${c.certificationName}').toList()}');
      print('- educations: ${profile.educations.map((e) => 'id:${e.id}, school:${e.schoolName}').toList()}');
      print('- workExperiences: ${profile.workExperiences.map((w) => 'id:${w.id}, name:${w.workName}').toList()}');
      print('- specialties: ${profile.specialties}');
      print('================================');
      
      await _repository!.updateTrainerProfile(profile);
      state = AsyncValue.data(profile);
      print('Profile update successful in viewmodel');
    } catch (e, stack) {
      print('Error updating profile in viewmodel: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProfile() async {
    if (_repository == null) {
      throw Exception('로그인이 필요합니다');
    }
    
    try {
      print('=== VIEWMODEL DELETE PROFILE ===');
      await _repository!.deleteTrainerProfile();
      print('Profile deleted successfully in viewmodel');
      
      // 상태를 빈 프로필로 설정
      state = AsyncValue.data(TrainerProfile.empty());
    } catch (e, stack) {
      print('Error deleting profile in viewmodel: $e');
      throw e; // UI에서 에러 처리하도록 rethrow
    }
  }

  void addAward() {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        awards: [...currentProfile.awards, Award.empty()],
      );
      state = AsyncValue.data(updatedProfile);
    }
  }

  void removeAward(int index) {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedAwards = List<Award>.from(currentProfile.awards);
      updatedAwards.removeAt(index);
      final updatedProfile = currentProfile.copyWith(awards: updatedAwards);
      state = AsyncValue.data(updatedProfile);
    }
  }

  void addCertification() {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        certifications: [...currentProfile.certifications, Certification.empty()],
      );
      state = AsyncValue.data(updatedProfile);
    }
  }

  void removeCertification(int index) {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedCertifications = List<Certification>.from(currentProfile.certifications);
      updatedCertifications.removeAt(index);
      final updatedProfile = currentProfile.copyWith(certifications: updatedCertifications);
      state = AsyncValue.data(updatedProfile);
    }
  }

  void addEducation() {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        educations: [...currentProfile.educations, Education.empty()],
      );
      state = AsyncValue.data(updatedProfile);
    }
  }

  void removeEducation(int index) {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedEducations = List<Education>.from(currentProfile.educations);
      updatedEducations.removeAt(index);
      final updatedProfile = currentProfile.copyWith(educations: updatedEducations);
      state = AsyncValue.data(updatedProfile);
    }
  }

  void addWorkExperience() {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedProfile = currentProfile.copyWith(
        workExperiences: [...currentProfile.workExperiences, WorkExperience.empty()],
      );
      state = AsyncValue.data(updatedProfile);
    }
  }

  void removeWorkExperience(int index) {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedWorkExperiences = List<WorkExperience>.from(currentProfile.workExperiences);
      updatedWorkExperiences.removeAt(index);
      final updatedProfile = currentProfile.copyWith(workExperiences: updatedWorkExperiences);
      state = AsyncValue.data(updatedProfile);
    }
  }

  void addSpecialty(String specialty) {
    final currentProfile = state.value;
    if (currentProfile != null && !currentProfile.specialties.contains(specialty)) {
      final updatedProfile = currentProfile.copyWith(
        specialties: [...currentProfile.specialties, specialty],
      );
      state = AsyncValue.data(updatedProfile);
    }
  }

  void removeSpecialty(String specialty) {
    final currentProfile = state.value;
    if (currentProfile != null) {
      final updatedSpecialties = currentProfile.specialties.where((s) => s != specialty).toList();
      final updatedProfile = currentProfile.copyWith(specialties: updatedSpecialties);
      state = AsyncValue.data(updatedProfile);
    }
  }
}