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
  List<dynamic>? followers;
  List<dynamic>? following;
  List<String>? saved;

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
    this.saved,
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
    if (json['followers'] != null && json['followers']?.length != 0) {
      followers = (json['followers']?[0] ?? '') is String
          ? List<String>.from(json['followers'].map((e) => e))
          : List<UserModel>.from(
              json['followers'].map((e) => UserModel.fromJson(e)));
    }
    if (json['following'] != null && json['following']?.length != 0) {
      following = (json['following']?[0] ?? '') is String
          ? List<String>.from(json['following'].map((e) => e))
          : List<UserModel>.from(
              json['following'].map((e) => UserModel.fromJson(e)));
    }
    saved = (json['saved'] != null && json['saved']?.length != 0)
        ? List<String>.from(json['saved'].map((e) => e))
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
    map['followers'] = List.from(followers?.map((e) => (e is String)
            ? UserModel(id: e).toJson()
            : (e as UserModel).toJson()) ??
        []);
    map['following'] = List.from(following?.map((e) => (e is String)
            ? UserModel(id: e).toJson()
            : (e as UserModel).toJson()) ??
        []);
    return map;
  }
}
