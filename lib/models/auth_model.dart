import 'package:flutter/foundation.dart';
import 'package:nps_social/models/user_model.dart';

class AuthModel {
  String? refreshToken;
  String? accessToken;
  UserModel? user;

  AuthModel({
    this.refreshToken,
    this.accessToken,
    this.user,
  });

  AuthModel.fromJson(dynamic json) {
    refreshToken = json['refreshToken'];
    accessToken = json['accessToken'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['refreshToken'] = refreshToken;
    map['accessToken'] = accessToken;
    // if (user != null) map['user'] = user?.toJson();
    return map;
  }
}
