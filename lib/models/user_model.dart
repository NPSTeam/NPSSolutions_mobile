import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

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
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? birthDay;
  List<String>? roles;

  UserModel({
    this.id,
    this.username,
    this.displayName,
    this.email,
    this.password,
    this.phoneNumber,
    this.photoURL,
    this.birthDay,
    this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static DateTime _fromJson(String dateTimeString) =>
      DateFormat("dd/MM/yyyy").parse(dateTimeString);
  static String _toJson(DateTime? dateTime) =>
      dateTime != null ? DateFormat("dd/MM/yyyy").format(dateTime) : "";
}
