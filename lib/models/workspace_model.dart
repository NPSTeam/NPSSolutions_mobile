import 'package:json_annotation/json_annotation.dart';

part 'workspace_model.g.dart';

@JsonSerializable()
class WorkspaceModel {
  int? id;
  String? code;
  String? name;
  String? address;
  List<String>? registerServices;

  WorkspaceModel({
    this.id,
    this.code,
    this.name,
    this.address,
    this.registerServices,
  });

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceModelToJson(this);
}
