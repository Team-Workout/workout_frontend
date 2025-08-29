import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pt_application_model.dart';
import '../repository/pt_application_repository.dart';

class PtApplicationNotifier extends StateNotifier<AsyncValue<List<PtApplication>>> {
  final PtApplicationRepository _repository;

  PtApplicationNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadPtApplications() async {
    state = const AsyncValue.loading();
    
    try {
      final applications = await _repository.getPtApplications();
      state = AsyncValue.data(applications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> createPtApplication(int offeringId) async {
    try {
      final request = CreatePtApplicationRequest(offeringId: offeringId);
      final success = await _repository.createPtApplication(request);
      
      if (success) {
        // 신청 후 목록 새로고침
        await loadPtApplications();
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> cancelPtApplication(int applicationId) async {
    try {
      final success = await _repository.cancelPtApplication(applicationId);
      
      if (success) {
        // 취소 후 목록 새로고침
        await loadPtApplications();
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> acceptPtApplication(int applicationId) async {
    try {
      final success = await _repository.acceptPtApplication(applicationId);
      
      if (success) {
        // 수락 후 목록 새로고침
        await loadPtApplications();
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> rejectPtApplication(int applicationId) async {
    try {
      final success = await _repository.rejectPtApplication(applicationId);
      
      if (success) {
        // 거절 후 목록 새로고침
        await loadPtApplications();
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  void clearApplications() {
    state = const AsyncValue.data([]);
  }
}

final ptApplicationProvider = StateNotifierProvider<PtApplicationNotifier, AsyncValue<List<PtApplication>>>(
  (ref) {
    final repository = ref.watch(ptApplicationRepositoryProvider);
    return PtApplicationNotifier(repository);
  },
);