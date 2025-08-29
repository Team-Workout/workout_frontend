import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pt_offering_model.dart';
import '../repository/pt_offering_repository.dart';

class PtOfferingNotifier extends StateNotifier<AsyncValue<List<PtOffering>>> {
  final PtOfferingRepository _repository;

  PtOfferingNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadPtOfferings(int trainerId) async {
    state = const AsyncValue.loading();
    
    try {
      final offerings = await _repository.getPtOfferingsByTrainerId(trainerId);
      state = AsyncValue.data(offerings);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> createPtOffering(CreatePtOfferingRequest request) async {
    try {
      final success = await _repository.createPtOffering(request);
      
      if (success) {
        // 생성 후 목록 새로고침
        await loadPtOfferings(request.trainerId);
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deletePtOffering(int offeringId, int trainerId) async {
    try {
      final success = await _repository.deletePtOffering(offeringId);
      
      if (success) {
        // 삭제 후 목록 새로고침
        await loadPtOfferings(trainerId);
      }
      
      return success;
    } catch (error) {
      rethrow;
    }
  }

  void clearOfferings() {
    state = const AsyncValue.data([]);
  }
}

final ptOfferingProvider = StateNotifierProvider<PtOfferingNotifier, AsyncValue<List<PtOffering>>>(
  (ref) {
    final repository = ref.watch(ptOfferingRepositoryProvider);
    return PtOfferingNotifier(repository);
  },
);