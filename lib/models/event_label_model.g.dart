// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_label_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventLabelModel _$EventLabelModelFromJson(Map<String, dynamic> json) =>
    EventLabelModel(
      id: json['id'] as int?,
      workspaceId: json['workspaceId'] as int?,
      title: json['title'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$EventLabelModelToJson(EventLabelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'title': instance.title,
      'color': instance.color,
    };
