// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrumboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScrumboardModel _$ScrumboardModelFromJson(Map<String, dynamic> json) =>
    ScrumboardModel(
      scrumboardId: json['scrumboardId'] as int?,
      workspaceId: json['workspaceId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      icons: json['icons'] as String?,
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
    );

Map<String, dynamic> _$ScrumboardModelToJson(ScrumboardModel instance) =>
    <String, dynamic>{
      'scrumboardId': instance.scrumboardId,
      'workspaceId': instance.workspaceId,
      'title': instance.title,
      'description': instance.description,
      'icons': instance.icons,
      'lastActivity': instance.lastActivity?.toIso8601String(),
    };
