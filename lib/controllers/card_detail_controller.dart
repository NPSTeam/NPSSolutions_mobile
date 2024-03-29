import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/board_card_model.dart';

import '../models/response_model.dart';
import '../models/workspace_user_model.dart';
import '../repositories/scrumboard_repo.dart';
import '../repositories/workspace_repo.dart';

class CardDetailController extends GetxController {
  BoardCardModel? card;
  List<WorkspaceUserModel>? workspaceUsers;

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

  Future<bool> updateCard({
    required int boardId,
    required int cardId,
    required BoardCardModel card,
  }) async {
    ResponseModel? response = await scrumboardRepo.updateCard(
      boardId: boardId,
      cardId: cardId,
      card: card,
    );

    if (response?.data != null) {
      await getCard(boardId: boardId, cardId: cardId);

      update();

      return true;
    }

    return false;
  }

  Future<bool> getWorkspaceUsers(int workspaceId) async {
    workspaceUsers = null;
    ResponseModel? response =
        await workspaceRepo.getWorkspaceUsers(workspaceId);

    if (response?.data != null) {
      workspaceUsers = (response?.data as List)
          .map((e) => WorkspaceUserModel.fromJson(e))
          .toList();
      update();
      return true;
    }

    return false;
  }
}
