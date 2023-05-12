import 'package:json_annotation/json_annotation.dart';

import 'cards_order_model.dart';

part 'board_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BoardModel {
  int? id;
  int? order;
  List<int>? cards;
  List<CardsOrderModel>? cardsOrder;

  BoardModel({
    this.id,
    this.order,
    this.cards,
    this.cardsOrder,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) =>
      _$BoardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BoardModelToJson(this);
}
