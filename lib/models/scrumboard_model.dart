import 'package:json_annotation/json_annotation.dart';

part 'scrumboard_model.g.dart';

@JsonSerializable()
class ScrumboardModel {
  int? scrumboardId;
  int? workspaceId;
  String? title;
  String? description;
  String? icons;
  DateTime? lastActivity;

  ScrumboardModel({
    this.scrumboardId,
    this.workspaceId,
    this.title,
    this.description,
    this.icons,
    this.lastActivity,
  });

  factory ScrumboardModel.fromJson(Map<String, dynamic> json) =>
      _$ScrumboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrumboardModelToJson(this);
}
