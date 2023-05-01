// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardModel _$BoardModelFromJson(Map<String, dynamic> json) => BoardModel(
      id: json['id'] as int?,
      order: json['order'] as int?,
      cards: (json['cards'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$BoardModelToJson(BoardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'cards': instance.cards,
    };
