import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? avatar;
  DateTime? birthday;
  List<String>? roles;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.avatar,
    this.birthday,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
