import 'package:json_annotation/json_annotation.dart';

part 'cards_order_model.g.dart';

@JsonSerializable()
class CardsOrderModel {
  int? id;
  int? order;

  CardsOrderModel({
    this.id,
    this.order,
  });

  factory CardsOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CardsOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardsOrderModelToJson(this);
}
