import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/board_card_model.dart';
import 'package:npssolutions_mobile/models/board_model.dart';

import '../models/cards_order_model.dart';
import '../models/response_model.dart';
import '../models/board_list_model.dart';
import '../models/scrumboard_model.dart';
import '../repositories/scrumboard_repo.dart';

class ScrumboardBoardController extends GetxController {
  ScrumboardModel? scrumboard;
  List<BoardListModel>? boardLists;
  List<BoardCardModel>? boardCards;

  Future<bool> getScrumboard(int scrumboardId) async {
    ResponseModel? response = await scrumboardRepo.getScrumboard(scrumboardId);

    scrumboard = null;
    if (response?.data != null) {
      scrumboard = ScrumboardModel.fromJson(response?.data);

      update();

      return true;
    }

    return false;
  }

  Future<bool> getBoardLists(int scrumboardId) async {
    ResponseModel? response = await scrumboardRepo.getBoardLists(scrumboardId);

    boardLists = null;
    if (response?.data != null) {
      boardLists = (response?.data as List)
          .map((e) => BoardListModel.fromJson(e))
          .toList();

      update();

      return true;
    }

    return false;
  }

  Future<bool> getBoardCards(int scrumboardId) async {
    ResponseModel? response = await scrumboardRepo.getBoardCards(scrumboardId);

    boardCards = null;
    if (response?.data != null) {
      boardCards = (response?.data as List)
          .map((e) => BoardCardModel.fromJson(e))
          .toList();

      update();

      return true;
    }

    return false;
  }

  Future<bool> updateBoard() async {
    scrumboard?.lists?.forEach((board) {
      board.order = scrumboard?.lists?.indexOf(board);
      board.cardsOrder = board.cards
          ?.map((e) => CardsOrderModel(id: e, order: board.cards?.indexOf(e)))
          .toList();
    });

    ResponseModel? response =
        await scrumboardRepo.updateScrumboard(scrumboard!);

    if (response?.data != null) {
      return true;
    }

    return false;
  }

  Future<bool> createCard({
    required int boardId,
    required BoardCardModel card,
  }) async {
    ResponseModel? response =
        await scrumboardRepo.createCard(boardId: boardId, card: card);

    if (response?.data != null) {
      return true;
    }

    return false;
  }
}
