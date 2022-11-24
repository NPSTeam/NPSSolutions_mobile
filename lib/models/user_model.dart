import 'package:flutter/foundation.dart';

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? mobile;
  String? email;
  String? password;
  String? avatar;
  String? sex;
  List<UserModel>? followers;
  List<UserModel>? following;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.mobile,
    this.email,
    this.password,
    this.avatar,
    this.sex,
    this.followers,
    this.following,
  });

  UserModel.fromJson(dynamic json) {
    debugPrint("$json");
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    sex = json['sex'];
    followers = (json['followers'] != null && json['followers']?.length != 0)
        ? ((json['followers']?[0] ?? '') is! String
            ? List<UserModel>.from(
                json['followers'].map((e) => UserModel.fromJson(e)))
            : null)
        : null;
    following = (json['following'] != null && json['following']?.length != 0)
        ? ((json['following']?[0] ?? '') is! String
            ? List<UserModel>.from(
                json['following'].map((e) => UserModel.fromJson(e)))
            : null)
        : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['_id'] = id;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['fullName'] = fullName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['password'] = password;
    map['avatar'] = avatar;
    map['sex'] = sex;
    return map;
  }
}
