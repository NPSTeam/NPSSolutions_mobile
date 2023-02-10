import 'package:json_annotation/json_annotation.dart';
import 'package:npssolutions_mobile/models/user_model.dart';

part 'auth_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthModel {
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @JsonKey(name: 'user')
  UserModel? currentUser;

  AuthModel({
    this.accessToken,
    this.refreshToken,
    this.currentUser,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
