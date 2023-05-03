// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrumboard_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScrumboardSettingModel _$ScrumboardSettingModelFromJson(
        Map<String, dynamic> json) =>
    ScrumboardSettingModel(
      subscribed: json['subscribed'] as bool?,
      cardCoverImages: json['cardCoverImages'] as bool?,
    );

Map<String, dynamic> _$ScrumboardSettingModelToJson(
        ScrumboardSettingModel instance) =>
    <String, dynamic>{
      'subscribed': instance.subscribed,
      'cardCoverImages': instance.cardCoverImages,
    };
