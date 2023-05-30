// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as int?,
      workspaceId: json['workspaceId'] as int?,
      title: json['title'] as String?,
      allDay: json['allDay'] as bool?,
      start: EventModel._fromJson(json['start'] as String?),
      end: EventModel._fromJson(json['end'] as String?),
      extendedProps: json['extendedProps'] == null
          ? null
          : EventExtendedProsModel.fromJson(
              json['extendedProps'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'workspaceId': instance.workspaceId,
      'title': instance.title,
      'allDay': instance.allDay,
      'start': EventModel._toJson(instance.start),
      'end': EventModel._toJson(instance.end),
      'extendedProps': instance.extendedProps?.toJson(),
    };
