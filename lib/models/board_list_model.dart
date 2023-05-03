import 'package:json_annotation/json_annotation.dart';

part 'board_list_model.g.dart';

@JsonSerializable()
class BoardListModel {
  int? id;
  int? order;
  int? boardId;
  String? title;

  BoardListModel({
    this.id,
    this.order,
    this.boardId,
    this.title,
  });

  factory BoardListModel.fromJson(Map<String, dynamic> json) =>
      _$BoardListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardListModelToJson(this);
}
