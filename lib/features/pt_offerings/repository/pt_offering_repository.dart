import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/pt_offering_api_service.dart';
import '../model/pt_offering_model.dart';

class PtOfferingRepository {
  final PtOfferingApiService _apiService;

  PtOfferingRepository(this._apiService);

  Future<bool> createPtOffering(CreatePtOfferingRequest request) async {
    return await _apiService.createPtOffering(request);
  }

  Future<List<PtOffering>> getPtOfferingsByTrainerId(int trainerId) async {
    return await _apiService.getPtOfferingsByTrainerId(trainerId);
  }

  Future<bool> deletePtOffering(int offeringId) async {
    return await _apiService.deletePtOffering(offeringId);
  }
}

final ptOfferingRepositoryProvider = Provider<PtOfferingRepository>((ref) {
  final apiService = ref.watch(ptOfferingApiServiceProvider);
  return PtOfferingRepository(apiService);
});