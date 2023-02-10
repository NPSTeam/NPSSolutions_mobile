import 'package:json_annotation/json_annotation.dart';
import 'package:npssolutions_mobile/models/error_model.dart';

part 'response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseModel {
  dynamic data;
  List<ErrorModel>? errors;
  String? message;
  int? status;
  DateTime? time;
  String? title;
  int? took;

  ResponseModel({
    this.data,
    this.errors,
    this.message,
    this.status,
    this.time,
    this.title,
    this.took,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
