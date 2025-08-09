import 'package:freezed_annotation/freezed_annotation.dart';

part 'pt_schedule_model.freezed.dart';
part 'pt_schedule_model.g.dart';

enum PTScheduleStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class PTSchedule with _$PTSchedule {
  const factory PTSchedule({
    required String id,
    required String trainerId,
    required String trainerName,
    required String memberId,
    required String memberName,
    required DateTime dateTime,
    required int durationMinutes,
    @Default(PTScheduleStatus.scheduled) PTScheduleStatus status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _PTSchedule;

  factory PTSchedule.fromJson(Map<String, dynamic> json) =>
      _$PTScheduleFromJson(json);
}