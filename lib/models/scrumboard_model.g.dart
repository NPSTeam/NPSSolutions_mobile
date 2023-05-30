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
      icon: json['icon'] as String?,
      lastActivity: ScrumboardModel._fromJson(json['lastActivity'] as String?),
      lists: (json['lists'] as List<dynamic>?)
          ?.map((e) => BoardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: json['settings'] == null
          ? null
          : ScrumboardSettingModel.fromJson(
              json['settings'] as Map<String, dynamic>),
      members:
          (json['members'] as List<dynamic>?)?.map((e) => e as int).toList(),
    )..isCreate = json['isCreate'] as bool?;

Map<String, dynamic> _$ScrumboardModelToJson(ScrumboardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'lastActivity': ScrumboardModel._toJson(instance.lastActivity),
      'lists': instance.lists?.map((e) => e.toJson()).toList(),
      'settings': instance.settings?.toJson(),
      'members': instance.members,
      'isCreate': instance.isCreate,
    };
