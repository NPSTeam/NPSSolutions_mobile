import 'package:json_annotation/json_annotation.dart';

part 'workspace_service_model.g.dart';

@JsonSerializable()
class WorkspaceServiceModel {
  String? label;
  String? value;

  WorkspaceServiceModel({this.label, this.value});

  factory WorkspaceServiceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceServiceModelToJson(this);
}
