// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      image: json['image'] as String?,
      reminder: NoteModel._fromJson(json['reminder'] as String?),
      archived: json['archived'] as bool?,
      labels: (json['labels'] as List<dynamic>?)?.map((e) => e as int).toList(),
      tasks: (json['tasks'] as List<dynamic>?)
          ?.map((e) => NoteTaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: NoteModel._fromJson(json['createdAt'] as String?),
      updatedAt: NoteModel._fromJson(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'content': instance.content,
      'image': instance.image,
      'reminder': NoteModel._toJson(instance.reminder),
      'archived': instance.archived,
      'labels': instance.labels,
      'tasks': instance.tasks?.map((e) => e.toJson()).toList(),
      'createdAt': NoteModel._toJson(instance.createdAt),
      'updatedAt': NoteModel._toJson(instance.updatedAt),
    };
