import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/response_model.dart';
import 'package:npssolutions_mobile/models/workspace_model.dart';
import 'package:npssolutions_mobile/repositories/workspace_repo.dart';

class WorkspaceManagementController extends GetxController {
  List<WorkspaceModel>? workspaces;

  Future<bool> getWorkspaces() async {
    ResponseModel? response = await workspaceRepo.getWorkspaceList();

    if (response?.data != null) {
      workspaces = (response?.data['datas'] as List)
          .map((e) => WorkspaceModel.fromJson(e))
          .toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> createWorkspace(WorkspaceModel workspace) async {
    ResponseModel? response = await workspaceRepo.createWorkspace(workspace);

    if (response?.data != null) {
      workspaces?.add(workspace);
      update();
      return true;
    }

    return false;
  }

  Future<bool> deleteWorkspace(int id) async {
    ResponseModel? response = await workspaceRepo.deleteWorkspace(id);

    if (response?.data != null) {
      workspaces?.removeWhere((element) => element.id == id);
      update();
      return true;
    }

    return false;
  }
}
