class UserModel {
  String? firstName;
  String? lastName;
  String? fullName;
  String? mobile;
  String? email;
  String? password;
  String? avatar;
  String? gender;

  UserModel({
    this.firstName,
    this.lastName,
    this.fullName,
    this.mobile,
    this.email,
    this.password,
    this.avatar,
    this.gender,
  });

  UserModel.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['fullName'] = fullName;
    map['mobile'] = mobile;
    map['email'] = email;
    map['password'] = password;
    map['avatar'] = avatar;
    map['gender'] = gender;
    return map;
  }
}
