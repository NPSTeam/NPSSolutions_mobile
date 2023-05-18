import 'package:get/get.dart';

import '../models/note_model.dart';
import '../models/response_model.dart';
import '../repositories/note_repo.dart';

class NoteListController extends GetxController {
  List<NoteModel>? notes;

  Future<bool> getNotes() async {
    ResponseModel? response = await noteRepo.getNoteList();

    if (response?.data != null) {
      notes =
          (response?.data as List).map((e) => NoteModel.fromJson(e)).toList();

      update();
      return true;
    }

    return false;
  }
}
