import 'package:npssolutions_mobile/models/board_card_model.dart';
import 'package:npssolutions_mobile/models/scrumboard_model.dart';

import '../models/response_model.dart';
import 'dio_repo.dart';

final scrumboardRepo = _ScrumboardRepo();

class _ScrumboardRepo extends DioRepo {
  Future<ResponseModel?> getScrumboardList(int workspaceId) async {
    return await get('/api/v1/scrumboards/boards/$workspaceId/list');
  }

  Future<ResponseModel?> getScrumboard(int scrumboardId) async {
    return await get('/api/v1/scrumboards/boards/$scrumboardId');
  }

  Future<ResponseModel?> getBoardLists(int scrumboardId) async {
    return await get('/api/v1/scrumboards/boards/$scrumboardId/lists');
  }

  Future<ResponseModel?> getBoardCards(int scrumboardId) async {
    return await get('/api/v1/scrumboards/boards/$scrumboardId/cards');
  }

  Future<ResponseModel?> createBoard(ScrumboardModel board) async {
    return await post('/api/v1/scrumboards/boards', data: board.toJson());
  }

  Future<ResponseModel?> updateScrumboard(ScrumboardModel board) async {
    return await put('/api/v1/scrumboards/boards/${board.id}',
        data: board.toJson());
  }

  Future<ResponseModel?> createCard({
    required int boardId,
    required BoardCardModel card,
  }) async {
    return await post('/api/v1/scrumboards/cards/$boardId/cards',
        data: card.toJson());
  }
}
