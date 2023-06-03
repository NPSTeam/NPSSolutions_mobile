// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      id: json['id'] as int?,
      chatId: json['chatId'] as int?,
      contactId: json['contactId'] as int?,
      value: json['value'] as String?,
      createdAt: MessageModel._fromJson(json['createdAt'] as String?),
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'contactId': instance.contactId,
      'value': instance.value,
      'createdAt': MessageModel._toJson(instance.createdAt),
    };
