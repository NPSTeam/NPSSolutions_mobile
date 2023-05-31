// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactModel _$ContactModelFromJson(Map<String, dynamic> json) => ContactModel(
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
      name: json['name'] as String?,
      about: json['about'] as String?,
      status: json['status'] as String?,
      visible: json['visible'] as bool?,
      details: json['details'] == null
          ? null
          : ContactDetailModel.fromJson(
              json['details'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContactModelToJson(ContactModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'name': instance.name,
      'about': instance.about,
      'status': instance.status,
      'visible': instance.visible,
      'details': instance.details?.toJson(),
    };
