import 'package:json_annotation/json_annotation.dart';

import 'note_task_model.dart';

part 'note_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NoteModel {
  int? id;
  int? userId;
  String? title;
  String? content;
  String? image;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? reminder;
  bool? archived;
  List<int>? labels;
  List<NoteTaskModel>? tasks;

  NoteModel({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.image,
    this.reminder,
    this.archived,
    this.labels,
    this.tasks,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  static DateTime? _fromJson(String? dateTime) =>
      dateTime == null ? null : DateTime.parse(dateTime).toLocal();
  static String? _toJson(DateTime? dateTime) =>
      dateTime?.toUtc().toIso8601String();
}
