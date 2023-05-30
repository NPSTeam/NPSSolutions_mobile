import 'package:json_annotation/json_annotation.dart';

part 'event_extended_pros_model.g.dart';

@JsonSerializable()
class EventExtendedProsModel {
  String? desc;
  int? label;

  EventExtendedProsModel({
    this.desc,
    this.label,
  });

  factory EventExtendedProsModel.fromJson(Map<String, dynamic> json) =>
      _$EventExtendedProsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventExtendedProsModelToJson(this);
}
