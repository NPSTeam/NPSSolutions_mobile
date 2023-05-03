// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardListModel _$BoardListModelFromJson(Map<String, dynamic> json) =>
    BoardListModel(
      id: json['id'] as int?,
      order: json['order'] as int?,
      boardId: json['boardId'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$BoardListModelToJson(BoardListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'boardId': instance.boardId,
      'title': instance.title,
    };
