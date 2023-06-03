import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  int? id;
  int? chatId;
  int? contactId;
  String? value;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? createdAt;

  MessageModel({
    this.id,
    this.chatId,
    this.contactId,
    this.value,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  static DateTime? _fromJson(String? dateTime) =>
      dateTime == null ? null : DateTime.parse(dateTime).toLocal();

  static String? _toJson(DateTime? dateTime) =>
      dateTime?.toUtc().toIso8601String();
}
