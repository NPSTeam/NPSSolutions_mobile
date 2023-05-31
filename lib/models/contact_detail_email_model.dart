import 'package:json_annotation/json_annotation.dart';

part 'contact_detail_email_model.g.dart';

@JsonSerializable()
class ContactDetailEmailModel {
  int? id;
  String? email;
  String? label;

  ContactDetailEmailModel({
    this.id,
    this.email,
    this.label,
  });

  factory ContactDetailEmailModel.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailEmailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailEmailModelToJson(this);
}
