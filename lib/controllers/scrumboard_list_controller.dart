import 'package:get/get.dart';
import 'package:npssolutions_mobile/repositories/workspace_repo.dart';

import '../models/response_model.dart';
import '../models/scrumboard_model.dart';
import '../models/scrumboard_setting_model.dart';
import '../models/workspace_model.dart';
import '../repositories/scrumboard_repo.dart';

class ScrumboardListController extends GetxController {
  List<WorkspaceModel>? workspaces;
  List<ScrumboardModel>? scrumboards;

  Future<bool> getWorkspaces() async {
    ResponseModel? response = await workspaceRepo.getWorkspaceList();

    workspaces = null;
    if (response?.data != null) {
      workspaces = (response?.data['datas'] as List)
          .map((e) => WorkspaceModel.fromJson(e))
          .toList();

      update();

      return true;
    }

    return false;
  }

  Future<bool> getScrumboards(int workspaceId) async {
    ResponseModel? response =
        await scrumboardRepo.getScrumboardList(workspaceId);

    scrumboards = null;
    if (response?.data != null) {
      scrumboards = (response?.data as List)
          .map((e) => ScrumboardModel.fromJson(e))
          .toList();

      update();

      return true;
    }

    return false;
  }

  Future<ScrumboardModel?> createScrumboard(int workspaceId) async {
    ResponseModel? response = await scrumboardRepo.createBoard(ScrumboardModel(
      title: 'Untitled',
      icon: 'heroicons-outline:template',
      description: '...',
      lastActivity: DateTime.now(),
      settings: ScrumboardSettingModel(subscribed: true, cardCoverImages: true),
      members: [],
      lists: [],
      workspaceId: workspaceId,
    ));

    if (response?.data != null) {
      return ScrumboardModel.fromJson(response?.data);
    }

    return null;
  }

  Future<bool> deleteScrumboard(int scrumboardId) async {
    ResponseModel? response =
        await scrumboardRepo.deleteScrumboard(scrumboardId);

    if (response?.data != null) {
      return true;
    }

    return false;
  }
}
