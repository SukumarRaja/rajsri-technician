import 'package:json_annotation/json_annotation.dart';

part 'change_password_request.g.dart';

@JsonSerializable()
class ChangePasswordRequest {
  @JsonKey(name: 'current_password')
  final String currentPassword;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.password,
    required this.passwordConfirmation,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}
