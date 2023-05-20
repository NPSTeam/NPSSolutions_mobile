import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/workspace_model.dart';

import '../models/response_model.dart';
import '../models/workspace_service_model.dart';
import '../models/workspace_user_model.dart';
import '../repositories/workspace_repo.dart';

class WorkspaceDetailController extends GetxController {
  WorkspaceModel? workspace;
  List<WorkspaceUserModel>? workspaceUsers;
  List<WorkspaceUserModel>? workspaceCheckedUsers;

  Future<bool> getWorkspaceDetail(int id) async {
    workspace = null;
    ResponseModel? response = await workspaceRepo.getWorkspaceDetail(id);

    if (response?.data != null) {
      workspace = WorkspaceModel.fromJson(response?.data);
      update();
      return true;
    }

    return false;
  }

  Future<bool> updateWorkspace(WorkspaceModel workspace) async {
    ResponseModel? response = await workspaceRepo.updateWorkspace(workspace);

    if (response?.data != null) {
      this.workspace = WorkspaceModel.fromJson(response?.data);
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

  Future<bool> getWorkspaceCheckedUsers(int workspaceId) async {
    workspaceCheckedUsers = null;
    ResponseModel? response =
        await workspaceRepo.getWorkspaceCheckedUsers(workspaceId);

    if (response?.data != null) {
      workspaceCheckedUsers = (response?.data as List)
          .map((e) => WorkspaceUserModel.fromJson(e))
          .toList();
      update();
      return true;
    }

    return false;
  }

  Future<bool> updateWorkspaceUsers(
    int workspaceId,
    List<WorkspaceUserModel> users,
  ) async {
    ResponseModel? response =
        await workspaceRepo.updateWorkspaceUsers(workspaceId, users);

    if (response?.data != null) {
      update();
      return true;
    }

    return false;
  }

  Future<List<WorkspaceServiceModel>> getWorkspaceServices() async {
    ResponseModel? response = await workspaceRepo.getServices();

    if (response?.data != null) {
      return (response?.data as List)
          .map((e) => WorkspaceServiceModel.fromJson(e))
          .toList();
    }

    return [];
  }
}
