import 'package:json_annotation/json_annotation.dart';

import 'contact_detail_email_model.dart';
import 'contact_detail_phone_number_model.dart';

part 'contact_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactDetailModel {
  List<ContactDetailEmailModel>? emails;
  List<ContactDetailPhoneNumberModel>? phoneNumbers;
  String? title;
  String? address;

  ContactDetailModel({
    this.emails,
    this.phoneNumbers,
    this.title,
    this.address,
  });

  factory ContactDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailModelToJson(this);
}
