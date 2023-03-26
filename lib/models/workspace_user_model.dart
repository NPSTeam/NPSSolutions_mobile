import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'workspace_user_model.g.dart';

@JsonSerializable()
class WorkspaceUserModel {
  int? userId;
  int? workspaceId;
  String? username;
  String? phoneNumber;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? birthDay;
  String? email;
  String? avatar;
  String? type;
  bool? checked;

  WorkspaceUserModel({
    this.userId,
    this.workspaceId,
    this.username,
    this.phoneNumber,
    this.birthDay,
    this.email,
    this.avatar,
    this.type,
    this.checked,
  });

  factory WorkspaceUserModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceUserModelToJson(this);

  static DateTime _fromJson(String dateTimeString) =>
      DateFormat("dd/MM/yyyy").parse(dateTimeString);
  static String _toJson(DateTime? dateTime) =>
      dateTime != null ? DateFormat("dd/MM/yyyy").format(dateTime) : "";
}
