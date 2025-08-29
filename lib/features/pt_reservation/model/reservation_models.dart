import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_models.freezed.dart';
part 'reservation_models.g.dart';

enum ReservationStatus {
  @JsonValue('REQUESTED')
  requested,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('COMPLETED')
  completed,
}

enum ReservationType {
  @JsonValue('REQUEST')
  request,
  @JsonValue('RECOMMENDATION')
  recommendation,
}

@freezed
class ReservationRequest with _$ReservationRequest {
  const factory ReservationRequest({
    required String id,
    required String memberId,
    required String memberName,
    required String trainerId,
    required String trainerName,
    required DateTime requestedDateTime,
    required int durationMinutes,
    required ReservationType type,
    required ReservationStatus status,
    String? message,
    String? responseMessage,
    DateTime? responseAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ReservationRequest;

  factory ReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$ReservationRequestFromJson(json);
}

@freezed
class ReservationResponse with _$ReservationResponse {
  const factory ReservationResponse({
    required List<ReservationRequest> data,
    required int total,
    required int page,
    required int size,
  }) = _ReservationResponse;

  factory ReservationResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationResponseFromJson(json);
}

@freezed
class CreateReservationRequest with _$CreateReservationRequest {
  const factory CreateReservationRequest({
    required String trainerId,
    required DateTime requestedDateTime,
    required int durationMinutes,
    required ReservationType type,
    String? message,
  }) = _CreateReservationRequest;

  factory CreateReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestFromJson(json);
}

@freezed
class ReservationRecommendation with _$ReservationRecommendation {
  const factory ReservationRecommendation({
    required String id,
    required String trainerId,
    required String trainerName,
    required String memberId,
    required String memberName,
    required DateTime recommendedDateTime,
    required int durationMinutes,
    required ReservationStatus status,
    String? message,
    String? responseMessage,
    DateTime? responseAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ReservationRecommendation;

  factory ReservationRecommendation.fromJson(Map<String, dynamic> json) =>
      _$ReservationRecommendationFromJson(json);
}

@freezed
class RecommendationResponse with _$RecommendationResponse {
  const factory RecommendationResponse({
    required List<ReservationRecommendation> data,
    required int total,
    required int page,
    required int size,
  }) = _RecommendationResponse;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationResponseFromJson(json);
}

extension ReservationStatusExtension on ReservationStatus {
  String get displayName {
    switch (this) {
      case ReservationStatus.requested:
        return '요청됨';
      case ReservationStatus.approved:
        return '승인됨';
      case ReservationStatus.rejected:
        return '거절됨';
      case ReservationStatus.cancelled:
        return '취소됨';
      case ReservationStatus.completed:
        return '완료됨';
    }
  }

  Color get color {
    switch (this) {
      case ReservationStatus.requested:
        return const Color(0xFF2196F3);
      case ReservationStatus.approved:
        return const Color(0xFF4CAF50);
      case ReservationStatus.rejected:
        return const Color(0xFFF44336);
      case ReservationStatus.cancelled:
        return const Color(0xFF9E9E9E);
      case ReservationStatus.completed:
        return const Color(0xFF4CAF50);
    }
  }
}

extension ReservationTypeExtension on ReservationType {
  String get displayName {
    switch (this) {
      case ReservationType.request:
        return '예약 요청';
      case ReservationType.recommendation:
        return '예약 권유';
    }
  }
}