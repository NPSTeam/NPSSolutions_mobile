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
  String? icons;
  DateTime? lastActivity;
  List<BoardModel>? lists;
  ScrumboardSettingModel? settings;

  ScrumboardModel({
    this.id,
    this.workspaceId,
    this.title,
    this.description,
    this.icons,
    this.lastActivity,
    this.lists,
    this.settings,
  });

  factory ScrumboardModel.fromJson(Map<String, dynamic> json) =>
      _$ScrumboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrumboardModelToJson(this);
}
