class UserModel {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? picture;
  String? cover;
  String? gender;
  int? bYear;
  int? bMonth;
  int? bDay;
  bool? verified;
  // List<Object>? friends;
  // List<Object>? following;
  // List<Object>? followers;
  // List<Object>? requests;

  UserModel.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    picture = json['picture'];
    cover = json['cover'];
    gender = json['gender'];
    bYear = json['bYear'];
    bMonth = json['bMonth'];
    bDay = json['bDay'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    map['picture'] = picture;
    map['cover'] = cover;
    map['gender'] = gender;
    map['bYear'] = bYear;
    map['bMonth'] = bMonth;
    map['bDay'] = bDay;
    map['verified'] = verified;
    return map;
  }
}
