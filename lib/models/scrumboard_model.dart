import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:npssolutions_mobile/models/scrumboard_setting_model.dart';

import 'board_model.dart';

part 'scrumboard_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ScrumboardModel {
  int? id;
  int? workspaceId;
  String? title;
  String? description;
  String? icon;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? lastActivity;
  List<BoardModel>? lists;
  ScrumboardSettingModel? settings;
  List<int>? members;

  ScrumboardModel({
    this.id,
    this.workspaceId,
    this.title,
    this.description,
    this.icon,
    this.lastActivity,
    this.lists,
    this.settings,
    this.members,
  });

  factory ScrumboardModel.fromJson(Map<String, dynamic> json) =>
      _$ScrumboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrumboardModelToJson(this);

  static DateTime? _fromJson(String? dateTime) =>
      dateTime == null ? null : DateTime.parse(dateTime).toLocal();
  static String? _toJson(DateTime? dateTime) => dateTime == null
      ? null
      : '${DateFormat('yyyy-MM-ddTHH:mm:ss.mmm').format(dateTime.toUtc())}Z';
}
