import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pt_service/features/profile/model/member_profile_model.dart';
import 'package:pt_service/features/profile/repository/profile_repository.dart';

final memberProfileProvider = FutureProvider.family<MemberProfile, String>((ref, memberId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getMemberProfile(memberId);
});

class ProfileViewModel extends StateNotifier<AsyncValue<void>> {
  final ProfileRepository _repository;
  
  ProfileViewModel(this._repository) : super(const AsyncValue.data(null));
  
  Future<void> updateProfile(MemberProfile profile) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.updateMemberProfile(profile);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> addWeightRecord(String memberId, double weight) async {
    state = const AsyncValue.loading();
    
    try {
      await _repository.addWeightRecord(memberId, weight, DateTime.now());
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final profileViewModelProvider = StateNotifierProvider<ProfileViewModel, AsyncValue<void>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileViewModel(repository);
});