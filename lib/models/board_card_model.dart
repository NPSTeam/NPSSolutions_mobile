import 'package:json_annotation/json_annotation.dart';

part 'board_card_model.g.dart';

@JsonSerializable()
class BoardCardModel {
  int? id;
  int? boardId;
  int? listId;
  String? title;
  String? description;
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
}
