import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/board_card_model.dart';

import '../models/response_model.dart';
import '../repositories/scrumboard_repo.dart';

class CardDetailController extends GetxController {
  BoardCardModel? card;

  Future<bool> getCard({
    required int boardId,
    required int cardId,
  }) async {
    ResponseModel? response =
        await scrumboardRepo.getCard(boardId: boardId, cardId: cardId);

    card = null;
    if (response?.data != null) {
      card = BoardCardModel.fromJson(response?.data);

      update();

      return true;
    }

    return false;
  }
}
