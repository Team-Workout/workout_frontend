import '../../../core/services/api_service.dart';
import '../model/trainer_profile_model.dart';

class TrainerProfileRepository {
  final ApiService _apiService;
  final String trainerId;

  TrainerProfileRepository(this._apiService, this.trainerId);

  Future<TrainerProfile> getTrainerProfile() async {
    try {
      final response = await _apiService.get('/trainers/$trainerId/profile');

      print('=== GET TRAINER PROFILE RESPONSE ===');
      print('Response data: ${response.data}');
      
      if (response.data == null || response.data.isEmpty) {
        print('Response is null or empty, returning empty profile');
        return TrainerProfile.empty();
      }

      final profile = TrainerProfile.fromJson(response.data);
      print('Parsed profile: ${profile.toJson()}');
      print('====================================');
      
      return profile;
    } catch (e) {
      print('Error getting trainer profile: $e');
      // 프로필이 없는 경우 빈 프로필 반환
      return TrainerProfile.empty();
    }
  }

  Future<void> deleteTrainerProfile() async {
    try {
      print('=== DELETE TRAINER PROFILE ===');
      await _apiService.delete('/trainers/profile');
      print('DELETE request successful');
    } catch (e) {
      print('DELETE request failed: $e');
      throw Exception('프로필 삭제 실패: ${e.toString()}');
    }
  }

  Future<void> updateTrainerProfile(TrainerProfile profile) async {
    try {
      print('=== PROFILE UPDATE: CLEAR THEN UPDATE ===');
      
      // 1단계: 빈 프로필로 초기화 (기존 데이터 모두 제거)
      final emptyProfile = TrainerProfile(
        trainerId: profile.trainerId,
        name: profile.name,
        email: profile.email,
        introduction: '',
        awards: [],
        certifications: [],
        educations: [],
        workExperiences: [],
        specialties: [],
      );
      
      print('=== STEP 1: CLEARING PROFILE ===');
      await _apiService.put(
        '/trainers/profile',
        data: emptyProfile.toJson(),
      );
      print('Profile cleared successfully');
      
      // 2단계: 실제 데이터로 업데이트
      print('=== STEP 2: UPDATING WITH NEW DATA ===');
      final jsonData = profile.toJson();
      print('Request data: $jsonData');
      print('Awards count: ${profile.awards.length}');
      print('Certifications count: ${profile.certifications.length}');
      print('Educations count: ${profile.educations.length}');
      print('Work experiences count: ${profile.workExperiences.length}');
      print('Specialties count: ${profile.specialties.length}');
      print('Specialties: ${profile.specialties}');
      print('===================================');
      
      await _apiService.put(
        '/trainers/profile',
        data: jsonData,
      );
      
      print('PUT request successful - Profile updated');
    } catch (e) {
      print('Profile update failed: $e');
      throw Exception('프로필 업데이트 실패: ${e.toString()}');
    }
  }
}
