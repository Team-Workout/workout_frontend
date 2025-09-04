import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_contract_model.freezed.dart';
part 'pt_contract_model.g.dart';

@freezed
class PtContract with _$PtContract {
  const factory PtContract({
    required int contractId,
    required String trainerName,
    required String memberName,
    required int totalSessions,
    required int remainingSessions,
    required String status,
    required String paymentDate,
    required int price,
  }) = _PtContract;

  factory PtContract.fromJson(Map<String, dynamic> json) =>
      _$PtContractFromJson(json);
}

@freezed
class PtContractResponse with _$PtContractResponse {
  const factory PtContractResponse({
    required List<PtContract> data,
    required PageInfo pageInfo,
  }) = _PtContractResponse;

  factory PtContractResponse.fromJson(Map<String, dynamic> json) =>
      _$PtContractResponseFromJson(json);
}

@freezed
class PageInfo with _$PageInfo {
  const factory PageInfo({
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _PageInfo;

  factory PageInfo.fromJson(Map<String, dynamic> json) =>
      _$PageInfoFromJson(json);
}

enum PtContractStatus {
  @JsonValue('ACTIVE')
  active('ACTIVE', '진행중'),
  @JsonValue('COMPLETED')
  completed('COMPLETED', '완료'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED', '취소'),
  @JsonValue('PENDING')
  pending('PENDING', '대기중');

  const PtContractStatus(this.value, this.displayName);
  final String value;
  final String displayName;
}

// 확장 메서드 추가
extension PtContractExtension on PtContract {
  PtContractStatus get contractStatus {
    return PtContractStatus.values.firstWhere(
      (status) => status.value == this.status,
      orElse: () => PtContractStatus.pending,
    );
  }

  bool get isActive => contractStatus == PtContractStatus.active;
  bool get isCompleted => contractStatus == PtContractStatus.completed;
  
  String get statusDisplayName => contractStatus.displayName;
  
  double get completionRate {
    if (totalSessions == 0) return 0.0;
    return ((totalSessions - remainingSessions) / totalSessions).clamp(0.0, 1.0);
  }
  
  String get formattedPrice {
    return '${(price / 10000).toStringAsFixed(0)}만원';
  }
}