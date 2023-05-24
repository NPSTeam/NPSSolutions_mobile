import 'package:get/get.dart';
import 'package:npssolutions_mobile/repositories/note_repo.dart';

import '../models/note_model.dart';
import '../models/response_model.dart';

class NoteDetailController extends GetxController {
  NoteModel? note;

  Future getNoteDetail(int noteId) async {
    note = null;

    ResponseModel? response = await noteRepo.getNoteDetail(noteId);
    if (response?.data != null) {
      note = NoteModel.fromJson(response?.data);
      update();
      return true;
    }
    return false;
  }

  Future updateNote(NoteModel noteModel) async {
    // noteModel.updatedAt = DateTime.now();
    ResponseModel? response = await noteRepo.updateNote(noteModel);
    if (response?.data != null) {
      noteModel = NoteModel.fromJson(response?.data);
      update();
      return true;
    }
    return false;
  }

  Future<bool> deleteNote(int noteId) async {
    ResponseModel? response = await noteRepo.deleteNote(noteId);

    if (response?.data != null) {
      update();
      return true;
    }

    return false;
  }
}
