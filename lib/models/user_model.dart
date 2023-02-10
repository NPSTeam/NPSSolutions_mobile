import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? avatar;
  DateTime? birthday;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.avatar,
    this.birthday,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
