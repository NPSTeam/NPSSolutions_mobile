// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrumboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScrumboardModel _$ScrumboardModelFromJson(Map<String, dynamic> json) =>
    ScrumboardModel(
      id: json['id'] as int?,
      workspaceId: json['workspaceId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      icons: json['icons'] as String?,
      lastActivity: json['lastActivity'] == null
          ? null
          : DateTime.parse(json['lastActivity'] as String),
      lists: (json['lists'] as List<dynamic>?)
          ?.map((e) => BoardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: json['settings'] == null
          ? null
          : ScrumboardSettingModel.fromJson(
              json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ScrumboardModelToJson(ScrumboardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'title': instance.title,
      'description': instance.description,
      'icons': instance.icons,
      'lastActivity': instance.lastActivity?.toIso8601String(),
      'lists': instance.lists?.map((e) => e.toJson()).toList(),
      'settings': instance.settings?.toJson(),
    };
