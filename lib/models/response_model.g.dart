// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseModel _$ResponseModelFromJson(Map<String, dynamic> json) =>
    ResponseModel(
      data: json['data'],
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ErrorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
      status: json['status'] as int?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      title: json['title'] as String?,
      took: json['took'] as int?,
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors?.map((e) => e.toJson()).toList(),
      'message': instance.message,
      'status': instance.status,
      'time': instance.time?.toIso8601String(),
      'title': instance.title,
      'took': instance.took,
    };
