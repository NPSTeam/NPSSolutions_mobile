// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_detail_email_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDetailEmailModel _$ContactDetailEmailModelFromJson(
        Map<String, dynamic> json) =>
    ContactDetailEmailModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$ContactDetailEmailModelToJson(
        ContactDetailEmailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'label': instance.label,
    };
