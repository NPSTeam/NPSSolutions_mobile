import 'package:get/get.dart';

import '../models/response_model.dart';
import '../models/task_model.dart';
import '../repositories/task_repo.dart';

class TaskListController extends GetxController {
  List<TaskModel>? tasks;
  int? remainingTasks;

  Future<bool> getTasks() async {
    ResponseModel? response = await taskRepo.getTaskList();

    if (response?.data != null) {
      tasks =
          (response?.data as List).map((e) => TaskModel.fromJson(e)).toList();

      updateRemainingTasks();
      return true;
    }

    return false;
  }

  void updateRemainingTasks() {
    remainingTasks = tasks
        ?.where((element) =>
            element.type == 'task' && !(element.completed ?? false))
        .length;
    update();
  }

  Future<bool> reorderTasks() async {
    ResponseModel? response = await taskRepo.reorderTaskList(tasks ?? []);

    if (response?.data != null) {
      return true;
    }

    return false;
  }

  Future<bool> updateTask(TaskModel task) async {
    ResponseModel? response = await taskRepo.updateTask(task);

    if (response?.data != null) {
      return true;
    }

    return false;
  }
}
