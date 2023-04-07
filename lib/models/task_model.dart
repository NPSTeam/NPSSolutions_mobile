import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  int? id;
  String? type;
  String? title;
  String? note;
  bool? completed;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? dueDate;
  int? priority;
  int? order;
  List<int>? tags;

  TaskModel({
    this.id,
    this.type,
    this.title,
    this.note,
    this.completed,
    this.dueDate,
    this.priority,
    this.order,
    this.tags,
  });

  static DateTime _fromJson(String dateTimeString) =>
      DateFormat("dd/MM/yyyy").parse(dateTimeString);
  static String _toJson(DateTime? dateTime) =>
      dateTime != null ? DateFormat("dd/MM/yyyy").format(dateTime) : "";
}
