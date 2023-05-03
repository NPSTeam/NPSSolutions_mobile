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
}
