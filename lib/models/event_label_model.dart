import 'package:json_annotation/json_annotation.dart';

part 'event_label_model.g.dart';

@JsonSerializable()
class EventLabelModel {
  int? id;
  int? workspaceId;
  String? title;
  String? color;

  EventLabelModel({
    this.id,
    this.workspaceId,
    this.title,
    this.color,
  });

  factory EventLabelModel.fromJson(Map<String, dynamic> json) =>
      _$EventLabelModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventLabelModelToJson(this);
}
