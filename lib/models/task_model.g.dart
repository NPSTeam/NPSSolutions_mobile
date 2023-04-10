// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as int?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      note: json['note'] as String?,
      completed: json['completed'] as bool?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as int?,
      order: json['order'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'note': instance.note,
      'completed': instance.completed,
      'dueDate': instance.dueDate?.toIso8601String(),
      'priority': instance.priority,
      'order': instance.order,
      'tags': instance.tags,
    };