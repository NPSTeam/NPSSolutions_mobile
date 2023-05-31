// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as int?,
      contactId: json['contactId'] as int?,
      unreadCount: json['unreadCount'] as int?,
      muted: json['muted'] as bool?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: ChatModel._fromJson(json['lastMessageAt'] as String?),
    )..contact = json['contact'] == null
        ? null
        : ContactModel.fromJson(json['contact'] as Map<String, dynamic>);

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'contactId': instance.contactId,
      'unreadCount': instance.unreadCount,
      'muted': instance.muted,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': ChatModel._toJson(instance.lastMessageAt),
      'contact': instance.contact?.toJson(),
    };
