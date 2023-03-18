import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/repositories/dio_repo.dart';

final workspaceRepo = _WorkspaceRepo();

class _WorkspaceRepo extends DioRepo {
  Future<ResponseModel?> getWorkspaceList() async {
    return await get('/api/v1/workspace/list');
  }
}
