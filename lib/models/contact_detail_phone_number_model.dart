import 'package:json_annotation/json_annotation.dart';

part 'contact_detail_phone_number_model.g.dart';

@JsonSerializable()
class ContactDetailPhoneNumberModel {
  int? id;
  String? country;
  String? phoneNumber;
  String? label;

  ContactDetailPhoneNumberModel({
    this.id,
    this.country,
    this.phoneNumber,
    this.label,
  });

  factory ContactDetailPhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailPhoneNumberModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailPhoneNumberModelToJson(this);
}
