import 'package:json_annotation/json_annotation.dart';

part 'card_attachment_model.g.dart';

@JsonSerializable()
class CardAttachmentModel {
  String? name;
  String? src;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? time;
  String? type;

  CardAttachmentModel({
    this.name,
    this.src,
    this.time,
    this.type,
  });

  factory CardAttachmentModel.fromJson(Map<String, dynamic> json) =>
      _$CardAttachmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardAttachmentModelToJson(this);

  static DateTime? _fromJson(int? dateTime) => dateTime == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(dateTime * 1000).toLocal();
  static int? _toJson(DateTime? dateTime) =>
      (dateTime?.toUtc().millisecondsSinceEpoch ?? 0) ~/ 1000;
}
