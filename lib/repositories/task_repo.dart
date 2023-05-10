import 'package:npssolutions_mobile/models/task_model.dart';

import '../models/response_model.dart';
import 'dio_repo.dart';

final taskRepo = _TaskRepo();

class _TaskRepo extends DioRepo {
  Future<ResponseModel?> getTaskList() async {
    return await get('/api/v1/tasks/list');
  }

  Future<ResponseModel?> reorderTaskList(List<TaskModel> tasks) async {
    return await put(
      '/api/v1/tasks/reorder-task',
      data: {
        "taskOrders":
            tasks.map((e) => {"taskId": e.id, "order": e.order}).toList(),
      },
    );
  }

  Future<ResponseModel?> updateTask(TaskModel task) async {
    return await put('/api/v1/tasks', data: task.toJson());
  }

  Future<ResponseModel?> deleteTask(int taskId) async {
    return await delete('/api/v1/tasks/$taskId');
  }

  Future<ResponseModel?> getTagList() async {
    return await get('/api/v1/tasks/tags');
  }

  Future<ResponseModel?> createTask(TaskModel task) async {
    return await post('/api/v1/tasks', data: task.toJson());
  }

  Future<ResponseModel?> getTaskDetail(int taskId) async {
    return await get('/api/v1/tasks/$taskId');
  }

  Future<ResponseModel?> createTag(String name) async {
    return await post('/api/v1/tasks/tags', data: {"title": name});
  }
}
