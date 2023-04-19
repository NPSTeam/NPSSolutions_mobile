import 'package:get/get.dart';

import '../models/response_model.dart';
import '../models/tag_model.dart';
import '../models/task_model.dart';
import '../repositories/task_repo.dart';

class TaskListController extends GetxController {
  List<TaskModel>? tasks;
  int? remainingTasks;
  List<TagModel>? tags;

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

  Future<bool> getTags() async {
    ResponseModel? response = await taskRepo.getTagList();

    if (response?.data != null) {
      tags = (response?.data as List).map((e) => TagModel.fromJson(e)).toList();
      update();
      return true;
    }

    return false;
  }

  Future<bool> createTask(TaskModel task) async {
    ResponseModel? response = await taskRepo.createTask(task);

    if (response?.data != null) {
      return true;
    }

    return false;
  }

  Future<bool> deleteTask(int taskId) async {
    ResponseModel? response = await taskRepo.deleteTask(taskId);

    if (response?.data != null) {
      tasks?.removeWhere((element) => element.id == taskId);
      update();
      return true;
    }

    return false;
  }
}
