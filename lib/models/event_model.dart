import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'event_extended_pros_model.dart';

part 'event_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EventModel {
  int? id;
  int? workspaceId;
  String? title;
  bool? allDay;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? start;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? end;
  EventExtendedProsModel? extendedProps;

  EventModel({
    this.id,
    this.workspaceId,
    this.title,
    this.allDay,
    this.start,
    this.end,
    this.extendedProps,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  static DateTime? _fromJson(String? dateTime) =>
      dateTime == null ? null : DateTime.parse(dateTime).toLocal();
  static String? _toJson(DateTime? dateTime) => dateTime == null
      ? null
      : '${DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime.toUtc())}+07:00';
}
