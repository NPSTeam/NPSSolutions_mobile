// ignore_for_file: non_constant_identifier_names

class ImageModel {
  String? public_id;
  String? url;

  ImageModel({
    this.public_id,
    this.url,
  });

  ImageModel.fromJson(dynamic json) {
    public_id = json['public_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['public_id'] = public_id;
    map['url'] = url;
    return map;
  }
}
