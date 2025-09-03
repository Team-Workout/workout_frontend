import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_image_model.freezed.dart';
part 'body_image_model.g.dart';

@freezed
class BodyImageResponse with _$BodyImageResponse {
  const factory BodyImageResponse({
    required int fileId,
    required String fileUrl,
    required String originalFileName,
    required String recordDate,
  }) = _BodyImageResponse;

  factory BodyImageResponse.fromJson(Map<String, dynamic> json) =>
      _$BodyImageResponseFromJson(json);
}