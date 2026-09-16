import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool success;
  final String message;
  final LoginData data;

  LoginResponse({required this.success, required this.message, required this.data});

  String get token => data.accessToken;
  UserModel get user => data.user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'token', readValue: _readToken)
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String? tokenType;
  final UserModel user;

  LoginData({required this.accessToken, this.tokenType, required this.user});

  static Object? _readToken(Map json, String key) {
    return json['token'] ?? json['access_token'];
  }

  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}
