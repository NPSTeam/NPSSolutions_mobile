import 'package:json_annotation/json_annotation.dart';
import 'package:npssolutions_mobile/models/user.dart';

part 'auth.g.dart';

@JsonSerializable(explicitToJson: true)
class Auth {
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @JsonKey(name: 'user')
  User? currentUser;

  Auth({
    this.accessToken,
    this.refreshToken,
    this.currentUser,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
