import 'package:json_annotation/json_annotation.dart';

part 'note_task_model.g.dart';

@JsonSerializable()
class NoteTaskModel {
  String? content;
  bool? completed;

  NoteTaskModel({
    this.content,
    this.completed,
  });

  factory NoteTaskModel.fromJson(Map<String, dynamic> json) =>
      _$NoteTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteTaskModelToJson(this);
}
