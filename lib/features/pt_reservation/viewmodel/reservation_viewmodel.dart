import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/reservation_repository.dart';
import '../model/reservation_models.dart';

part 'reservation_viewmodel.g.dart';

@riverpod
class ReservationViewModel extends _$ReservationViewModel {
  @override
  AsyncValue<ReservationResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loadReservationRequests({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(reservationRepositoryProvider);
      final response = await repository.getReservationRequests(
        page: page,
        size: size,
        status: status,
      );
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createReservationRequest({
    required String trainerId,
    required DateTime requestedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.createReservationRequest(
        trainerId: trainerId,
        requestedDateTime: requestedDateTime,
        durationMinutes: durationMinutes,
        message: message,
      );
      
      // Refresh the list
      loadReservationRequests();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> respondToReservationRequest({
    required String requestId,
    required bool approve,
    String? responseMessage,
  }) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.respondToReservationRequest(
        requestId: requestId,
        approve: approve,
        responseMessage: responseMessage,
      );
      
      // Refresh the list
      loadReservationRequests();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> cancelReservationRequest(String requestId) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.cancelReservationRequest(requestId);
      
      // Refresh the list
      loadReservationRequests();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class RecommendationViewModel extends _$RecommendationViewModel {
  @override
  AsyncValue<RecommendationResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loadRecommendations({
    int page = 0,
    int size = 20,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(reservationRepositoryProvider);
      final response = await repository.getReservationRecommendations(
        page: page,
        size: size,
        status: status,
      );
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> createRecommendation({
    required String memberId,
    required DateTime recommendedDateTime,
    required int durationMinutes,
    String? message,
  }) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.createReservationRecommendation(
        memberId: memberId,
        recommendedDateTime: recommendedDateTime,
        durationMinutes: durationMinutes,
        message: message,
      );
      
      // Refresh the list
      loadRecommendations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> respondToRecommendation({
    required String recommendationId,
    required bool accept,
    String? responseMessage,
  }) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.respondToRecommendation(
        recommendationId: recommendationId,
        accept: accept,
        responseMessage: responseMessage,
      );
      
      // Refresh the list
      loadRecommendations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> cancelRecommendation(String recommendationId) async {
    try {
      final repository = ref.read(reservationRepositoryProvider);
      await repository.cancelRecommendation(recommendationId);
      
      // Refresh the list
      loadRecommendations();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

@riverpod
class ReservationHistoryViewModel extends _$ReservationHistoryViewModel {
  @override
  AsyncValue<ReservationResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loadHistory({
    int page = 0,
    int size = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(reservationRepositoryProvider);
      final response = await repository.getReservationHistory(
        page: page,
        size: size,
        startDate: startDate,
        endDate: endDate,
      );
      state = AsyncValue.data(response);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}