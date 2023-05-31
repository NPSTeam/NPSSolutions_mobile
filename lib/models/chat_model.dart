import 'package:json_annotation/json_annotation.dart';
import 'package:npssolutions_mobile/models/contact_model.dart';

part 'chat_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatModel {
  int? id;
  int? contactId;
  int? unreadCount;
  bool? muted;
  String? lastMessage;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? lastMessageAt;
  ContactModel? contact;

  ChatModel({
    this.id,
    this.contactId,
    this.unreadCount,
    this.muted,
    this.lastMessage,
    this.lastMessageAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  static DateTime? _fromJson(String? dateTime) =>
      dateTime == null ? null : DateTime.parse(dateTime).toLocal();
  static String? _toJson(DateTime? dateTime) =>
      dateTime?.toUtc().toIso8601String();
}
