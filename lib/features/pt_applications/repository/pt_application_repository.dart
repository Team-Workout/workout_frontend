import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/pt_application_api_service.dart';
import '../model/pt_application_model.dart';

class PtApplicationRepository {
  final PtApplicationApiService _apiService;

  PtApplicationRepository(this._apiService);

  Future<bool> createPtApplication(CreatePtApplicationRequest request) async {
    return await _apiService.createPtApplication(request);
  }

  Future<List<PtApplication>> getPtApplications() async {
    return await _apiService.getPtApplications();
  }

  Future<bool> cancelPtApplication(int applicationId) async {
    return await _apiService.cancelPtApplication(applicationId);
  }

  Future<bool> acceptPtApplication(int applicationId) async {
    return await _apiService.acceptPtApplication(applicationId);
  }

  Future<bool> rejectPtApplication(int applicationId) async {
    return await _apiService.rejectPtApplication(applicationId);
  }
}

final ptApplicationRepositoryProvider = Provider<PtApplicationRepository>((ref) {
  final apiService = ref.watch(ptApplicationApiServiceProvider);
  return PtApplicationRepository(apiService);
});