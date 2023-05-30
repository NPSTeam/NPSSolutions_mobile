import 'package:json_annotation/json_annotation.dart';

part 'note_label_model.g.dart';

@JsonSerializable()
class NoteLabelModel {
  int? id;
  String? title;

  NoteLabelModel({
    this.id,
    this.title,
  });

  factory NoteLabelModel.fromJson(Map<String, dynamic> json) =>
      _$NoteLabelModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteLabelModelToJson(this);
}
