import 'package:get/get.dart';
import 'package:npssolutions_mobile/models/tag_model.dart';
import 'package:npssolutions_mobile/models/task_model.dart';

import '../models/response_model.dart';
import '../repositories/task_repo.dart';

class TaskDetailController extends GetxController {
  TaskModel? task;
  List<TagModel>? tagList;

  Future getTaskDetail(int taskId) async {
    task = null;

    ResponseModel? response = await taskRepo.getTaskDetail(taskId);
    if (response?.data != null) {
      task = TaskModel.fromJson(response?.data);
      update();
      return true;
    }
    return false;
  }

  Future getTagList() async {
    tagList = null;

    ResponseModel? response = await taskRepo.getTagList();
    if (response?.data != null) {
      tagList =
          (response?.data as List).map((e) => TagModel.fromJson(e)).toList();
      update();
      return true;
    }
    return false;
  }

  Future<bool> createTag(String name) async {
    ResponseModel? response = await taskRepo.createTag(name);
    if (response?.data != null) {
      tagList?.add(TagModel.fromJson(response?.data));
      await getTagList();
      update();
      return true;
    }
    return false;
  }

  Future<bool> updateTask(TaskModel task) async {
    ResponseModel? response = await taskRepo.updateTask(task);
    if (response?.data != null) {
      await getTaskDetail(task.id!);
      update();
      return true;
    }
    return false;
  }

  Future<bool> deleteTask(int taskId) async {
    ResponseModel? response = await taskRepo.deleteTask(taskId);

    if (response?.data != null) {
      update();
      return true;
    }

    return false;
  }
}
