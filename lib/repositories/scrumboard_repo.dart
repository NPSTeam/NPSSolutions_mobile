import '../models/response_model.dart';
import 'dio_repo.dart';

final scrumboardRepo = _ScrumboardRepo();

class _ScrumboardRepo extends DioRepo {
  Future<ResponseModel?> getScrumboardList(int workspaceId) async {
    return await get('/api/v1/scrumboards/boards/$workspaceId/list');
  }
}
