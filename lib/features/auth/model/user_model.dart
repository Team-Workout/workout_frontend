import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserType {
  @JsonValue('trainer')
  trainer,
  @JsonValue('member')
  member,
  @JsonValue('manager')
  manager,
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required UserType userType,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? birthDate,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}