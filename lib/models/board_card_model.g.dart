// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardCardModel _$BoardCardModelFromJson(Map<String, dynamic> json) =>
    BoardCardModel(
      id: json['id'] as int?,
      boardId: json['boardId'] as int?,
      listId: json['listId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      dueDate: BoardCardModel._fromJson(json['dueDate'] as int?),
      memberIds:
          (json['memberIds'] as List<dynamic>?)?.map((e) => e as int).toList(),
      subscribed: json['subscribed'] as bool?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => CardAttachmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BoardCardModelToJson(BoardCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'boardId': instance.boardId,
      'listId': instance.listId,
      'title': instance.title,
      'description': instance.description,
      'dueDate': BoardCardModel._toJson(instance.dueDate),
      'memberIds': instance.memberIds,
      'subscribed': instance.subscribed,
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
    };
