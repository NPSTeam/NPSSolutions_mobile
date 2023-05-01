import 'package:get/get.dart';

import '../models/response_model.dart';
import '../models/scrumboard_model.dart';
import '../models/workspace_model.dart';
import '../repositories/scrumboard_repo.dart';

class ScrumboardListController extends GetxController {
  List<WorkspaceModel>? workspaces;
  List<ScrumboardModel>? scrumboards;

  Future<bool> getScrumboards(String workspaceId) async {
    ResponseModel? response =
        await scrumboardRepo.getScrumboardList(workspaceId);

    if (response?.data != null) {
      scrumboards = (response?.data as List)
          .map((e) => ScrumboardModel.fromJson(e))
          .toList();

      update();

      return true;
    }

    return false;
  }
}
