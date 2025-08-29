import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/api_service.dart';
import '../model/reservation_models.dart';

part 'reservation_api_service.g.dart';

@riverpod
ReservationApiService reservationApiService(ReservationApiServiceRef ref) {
  return ReservationApiService(ref.watch(apiServiceProvider));
}

class ReservationApiService {
  final ApiService _apiService;

  ReservationApiService(this._apiService);

  Future<ReservationResponse> getReservationRequests({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };

    if (status != null) {
      queryParams['status'] = status;
    }

    final response = await _apiService.get(
      '/reservations/requests',
      queryParameters: queryParams,
    );

    return ReservationResponse.fromJson(response.data);
  }

  Future<RecommendationResponse> getReservationRecommendations({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };

    if (status != null) {
      queryParams['status'] = status;
    }

    final response = await _apiService.get(
      '/reservations/recommendations',
      queryParameters: queryParams,
    );

    return RecommendationResponse.fromJson(response.data);
  }

  Future<ReservationRequest> createReservationRequest({
    required String trainerId,
    required DateTime requestedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    final requestData = {
      'trainerId': trainerId,
      'requestedDateTime': requestedDateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'type': 'REQUEST',
      'message': message,
    };

    final response = await _apiService.post(
      '/reservations/requests',
      data: requestData,
    );

    return ReservationRequest.fromJson(response.data);
  }

  Future<ReservationRecommendation> createReservationRecommendation({
    required String memberId,
    required DateTime recommendedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    final requestData = {
      'memberId': memberId,
      'recommendedDateTime': recommendedDateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'message': message,
    };

    final response = await _apiService.post(
      '/reservations/recommendations',
      data: requestData,
    );

    return ReservationRecommendation.fromJson(response.data);
  }

  Future<ReservationRequest> respondToReservationRequest({
    required String requestId,
    required bool approve,
    String? responseMessage,
  }) async {
    final requestData = {
      'approve': approve,
      'responseMessage': responseMessage,
    };

    final response = await _apiService.patch(
      '/reservations/requests/$requestId/respond',
      data: requestData,
    );

    return ReservationRequest.fromJson(response.data);
  }

  Future<ReservationRecommendation> respondToRecommendation({
    required String recommendationId,
    required bool accept,
    String? responseMessage,
  }) async {
    final requestData = {
      'accept': accept,
      'responseMessage': responseMessage,
    };

    final response = await _apiService.patch(
      '/reservations/recommendations/$recommendationId/respond',
      data: requestData,
    );

    return ReservationRecommendation.fromJson(response.data);
  }

  Future<void> cancelReservationRequest(String requestId) async {
    await _apiService.delete('/api/reservations/requests/$requestId');
  }

  Future<void> cancelRecommendation(String recommendationId) async {
    await _apiService
        .delete('/api/reservations/recommendations/$recommendationId');
  }

  Future<ReservationResponse> getReservationHistory({
    int page = 0,
    int size = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
    };

    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String();
    }

    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String();
    }

    final response = await _apiService.get(
      '/reservations/history',
      queryParameters: queryParams,
    );

    return ReservationResponse.fromJson(response.data);
  }
}
