// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDetailModel _$ContactDetailModelFromJson(Map<String, dynamic> json) =>
    ContactDetailModel(
      emails: (json['emails'] as List<dynamic>?)
          ?.map((e) =>
              ContactDetailEmailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>?)
          ?.map((e) =>
              ContactDetailPhoneNumberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$ContactDetailModelToJson(ContactDetailModel instance) =>
    <String, dynamic>{
      'emails': instance.emails?.map((e) => e.toJson()).toList(),
      'phoneNumbers': instance.phoneNumbers?.map((e) => e.toJson()).toList(),
      'title': instance.title,
      'address': instance.address,
    };
