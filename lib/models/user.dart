import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? avatar;
  DateTime? birthday;

  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.avatar,
    this.birthday,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
