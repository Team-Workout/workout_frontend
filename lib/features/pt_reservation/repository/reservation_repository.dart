import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../service/reservation_api_service.dart';
import '../model/reservation_models.dart';

part 'reservation_repository.g.dart';

@riverpod
ReservationRepository reservationRepository(ReservationRepositoryRef ref) {
  return ReservationRepository(ref.watch(reservationApiServiceProvider));
}

class ReservationRepository {
  final ReservationApiService _apiService;

  ReservationRepository(this._apiService);

  Future<ReservationResponse> getReservationRequests({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    try {
      return await _apiService.getReservationRequests(
        page: page,
        size: size,
        status: status,
      );
    } catch (e) {
      throw Exception('예약 요청 목록을 불러올 수 없습니다: $e');
    }
  }

  Future<RecommendationResponse> getReservationRecommendations({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    try {
      return await _apiService.getReservationRecommendations(
        page: page,
        size: size,
        status: status,
      );
    } catch (e) {
      throw Exception('예약 권유 목록을 불러올 수 없습니다: $e');
    }
  }

  Future<ReservationRequest> createReservationRequest({
    required String trainerId,
    required DateTime requestedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    try {
      return await _apiService.createReservationRequest(
        trainerId: trainerId,
        requestedDateTime: requestedDateTime,
        durationMinutes: durationMinutes,
        message: message,
      );
    } catch (e) {
      throw Exception('예약 요청을 생성할 수 없습니다: $e');
    }
  }

  Future<ReservationRecommendation> createReservationRecommendation({
    required String memberId,
    required DateTime recommendedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    try {
      return await _apiService.createReservationRecommendation(
        memberId: memberId,
        recommendedDateTime: recommendedDateTime,
        durationMinutes: durationMinutes,
        message: message,
      );
    } catch (e) {
      throw Exception('예약 권유를 생성할 수 없습니다: $e');
    }
  }

  Future<ReservationRequest> respondToReservationRequest({
    required String requestId,
    required bool approve,
    String? responseMessage,
  }) async {
    try {
      return await _apiService.respondToReservationRequest(
        requestId: requestId,
        approve: approve,
        responseMessage: responseMessage,
      );
    } catch (e) {
      throw Exception('예약 요청에 응답할 수 없습니다: $e');
    }
  }

  Future<ReservationRecommendation> respondToRecommendation({
    required String recommendationId,
    required bool accept,
    String? responseMessage,
  }) async {
    try {
      return await _apiService.respondToRecommendation(
        recommendationId: recommendationId,
        accept: accept,
        responseMessage: responseMessage,
      );
    } catch (e) {
      throw Exception('예약 권유에 응답할 수 없습니다: $e');
    }
  }

  Future<void> cancelReservationRequest(String requestId) async {
    try {
      return await _apiService.cancelReservationRequest(requestId);
    } catch (e) {
      throw Exception('예약 요청을 취소할 수 없습니다: $e');
    }
  }

  Future<void> cancelRecommendation(String recommendationId) async {
    try {
      return await _apiService.cancelRecommendation(recommendationId);
    } catch (e) {
      throw Exception('예약 권유를 취소할 수 없습니다: $e');
    }
  }

  Future<ReservationResponse> getReservationHistory({
    int page = 0,
    int size = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _apiService.getReservationHistory(
        page: page,
        size: size,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('예약 내역을 불러올 수 없습니다: $e');
    }
  }
}