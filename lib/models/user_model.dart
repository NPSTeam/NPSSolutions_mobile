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
  });

  UserModel.fromJson(dynamic json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    avatar = json['avatar'];
    sex = json['sex'];
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
