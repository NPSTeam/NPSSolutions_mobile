import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int? id;
  String? username;
  String? displayName;
  String? email;
  String? password;
  String? phoneNumber;
  String? photoURL;
  DateTime? birthday;
  List<String>? roles;

  UserModel({
    this.id,
    this.username,
    this.displayName,
    this.email,
    this.password,
    this.phoneNumber,
    this.photoURL,
    this.birthday,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
