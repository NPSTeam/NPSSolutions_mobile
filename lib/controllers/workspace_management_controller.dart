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
}
