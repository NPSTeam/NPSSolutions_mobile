// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_phone_number_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDetailPhoneNumberModel _$ContactDetailPhoneNumberModelFromJson(
        Map<String, dynamic> json) =>
    ContactDetailPhoneNumberModel(
      id: json['id'] as int?,
      country: json['country'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$ContactDetailPhoneNumberModelToJson(
        ContactDetailPhoneNumberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'phoneNumber': instance.phoneNumber,
      'label': instance.label,
    };
