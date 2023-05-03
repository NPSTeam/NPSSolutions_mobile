import 'package:json_annotation/json_annotation.dart';

part 'scrumboard_setting_model.g.dart';

@JsonSerializable()
class ScrumboardSettingModel {
  bool? subscribed;
  bool? cardCoverImages;

  ScrumboardSettingModel({
    this.subscribed,
    this.cardCoverImages,
  });

  factory ScrumboardSettingModel.fromJson(Map<String, dynamic> json) =>
      _$ScrumboardSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrumboardSettingModelToJson(this);
}
