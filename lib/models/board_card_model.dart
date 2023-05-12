import 'package:json_annotation/json_annotation.dart';

part 'board_card_model.g.dart';

@JsonSerializable()
class BoardCardModel {
  int? id;
  int? boardId;
  int? listId;
  String? title;
  String? description;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? dueDate;
  List<int>? memberIds;
  bool? subscribed;

  BoardCardModel({
    this.id,
    this.boardId,
    this.listId,
    this.title,
    this.description,
    this.dueDate,
    this.memberIds,
    this.subscribed,
  });

  factory BoardCardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardCardModelToJson(this);

  static DateTime? _fromJson(int? dateTime) => dateTime == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(dateTime).toLocal();
  static int? _toJson(DateTime? dateTime) =>
      dateTime?.toUtc().millisecondsSinceEpoch;
}
