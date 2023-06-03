// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_attachment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardAttachmentModel _$CardAttachmentModelFromJson(Map<String, dynamic> json) =>
    CardAttachmentModel(
      name: json['name'] as String?,
      src: json['src'] as String?,
      time: CardAttachmentModel._fromJson(json['time'] as int?),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$CardAttachmentModelToJson(
        CardAttachmentModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'src': instance.src,
      'time': CardAttachmentModel._toJson(instance.time),
      'type': instance.type,
    };
