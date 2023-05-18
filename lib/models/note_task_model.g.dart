// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteTaskModel _$NoteTaskModelFromJson(Map<String, dynamic> json) =>
    NoteTaskModel(
      content: json['content'] as String?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$NoteTaskModelToJson(NoteTaskModel instance) =>
    <String, dynamic>{
      'content': instance.content,
      'completed': instance.completed,
    };
