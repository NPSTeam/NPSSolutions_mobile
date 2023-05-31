import 'package:json_annotation/json_annotation.dart';

import 'contact_detail_model.dart';

part 'contact_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactModel {
  int? id;
  String? avatar;
  String? name;
  String? about;
  String? status;
  bool? visible;
  ContactDetailModel? details;

  ContactModel({
    this.id,
    this.avatar,
    this.name,
    this.about,
    this.status,
    this.visible,
    this.details,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
}
