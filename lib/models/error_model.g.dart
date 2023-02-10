// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorModel _$ErrorModelFromJson(Map<String, dynamic> json) => ErrorModel(
      code: json['code'] as String?,
      field: json['field'] as String?,
      message: json['message'] as String?,
      objectName: json['objectName'] as String?,
      rejectValue: json['rejectValue'],
    );

Map<String, dynamic> _$ErrorModelToJson(ErrorModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'field': instance.field,
      'message': instance.message,
      'objectName': instance.objectName,
      'rejectValue': instance.rejectValue,
    };
