import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/models/workspace_model.dart';
import 'package:npssolutions_mobile/repositories/dio_repo.dart';

final workspaceRepo = _WorkspaceRepo();

class _WorkspaceRepo extends DioRepo {
  Future<ResponseModel?> getWorkspaceList() async {
    return await get('/api/v1/workspace/list');
  }

  Future<ResponseModel?> createWorkspace(WorkspaceModel workspace) async {
    return await post(
      '/api/v1/workspace/add',
      data: {
        'code': workspace.code,
        'name': workspace.name,
        'address': workspace.address,
        'registerServices': workspace.registerServices,
      },
    );
  }

  Future<ResponseModel?> deleteWorkspace(int id) async {
    return await delete('/api/v1/workspace/$id/delete');
  }

  Future<ResponseModel?> getWorkspaceDetail(int id) async {
    return await get('/api/v1/workspace/$id/detail');
  }

  Future<ResponseModel?> updateWorkspace(WorkspaceModel workspace) async {
    return await put(
      '/api/v1/workspace/update',
      data: {
        'id': workspace.id,
        'name': workspace.name,
        'address': workspace.address,
        'registerServices': workspace.registerServices,
      },
    );
  }
}
