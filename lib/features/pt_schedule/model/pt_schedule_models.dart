import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_schedule_models.freezed.dart';
part 'pt_schedule_models.g.dart';

@freezed
class PtSchedule with _$PtSchedule {
  const factory PtSchedule({
    @JsonKey(name: 'id') required int appointmentId,
    required int contractId,
    required String trainerName,
    required String memberName,
    required String startTime,
    required String endTime,
    required String status,
    String? requestedStartTime,
    String? requestedEndTime,
    bool? hasChangeRequest,
    String? changeRequestBy, // 'member' or 'trainer'
  }) = _PtSchedule;

  factory PtSchedule.fromJson(Map<String, dynamic> json) =>
      _$PtScheduleFromJson(json);
}