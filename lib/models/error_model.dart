import 'package:json_annotation/json_annotation.dart';

part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  String? code;
  String? field;
  String? message;
  String? objectName;
  dynamic rejectValue;

  ErrorModel({
    this.code,
    this.field,
    this.message,
    this.objectName,
    this.rejectValue,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
