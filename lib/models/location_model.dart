class LocationModel {
  String? id;
  String? userId;
  String? fullName;
  String? avatar;
  double? lat;
  double? lng;

  LocationModel({
    this.id,
    this.userId,
    this.fullName,
    this.avatar,
    this.lat,
    this.lng,
  });

  LocationModel.fromJson(dynamic json) {
    id = json['_id'];
    userId = json['user_id'];
    fullName = json['fullname'];
    avatar = json['avatar'];
    lat = double.tryParse(json['lat'].toString()) ?? 0;
    lng = double.tryParse(json['lng'].toString()) ?? 0;
  }
}
