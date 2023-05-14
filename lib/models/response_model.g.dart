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
      time: ResponseModel._fromJson(json['time'] as String?),
      title: json['title'] as String?,
      took: json['took'] as int?,
    );

Map<String, dynamic> _$ResponseModelToJson(ResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errors': instance.errors?.map((e) => e.toJson()).toList(),
      'message': instance.message,
      'status': instance.status,
      'time': ResponseModel._toJson(instance.time),
      'title': instance.title,
      'took': instance.took,
    };
