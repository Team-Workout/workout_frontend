import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_image_model.freezed.dart';
part 'profile_image_model.g.dart';

@freezed
class ProfileImageResponse with _$ProfileImageResponse {
  const factory ProfileImageResponse({
    required int fileId,
    required String fileUrl,
    required String originalFileName,
    String? recordDate,
  }) = _ProfileImageResponse;

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageResponseFromJson(json);
}

@freezed
class ProfileImageInfo with _$ProfileImageInfo {
  const factory ProfileImageInfo({
    required String profileImageUrl,
  }) = _ProfileImageInfo;

  factory ProfileImageInfo.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageInfoFromJson(json);
}