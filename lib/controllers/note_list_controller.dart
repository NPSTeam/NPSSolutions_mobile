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

  Future<bool> createNote(NoteModel note) async {
    // note.createdAt = DateTime.now();
    ResponseModel? response = await noteRepo.createNote(note);

    if (response?.data != null) {
      notes?.add(NoteModel.fromJson(response?.data));
      update();
      return true;
    }

    return false;
  }

  Future<bool> deleteNote(int noteId) async {
    ResponseModel? response = await noteRepo.deleteNote(noteId);

    if (response?.data != null) {
      notes?.removeWhere((element) => element.id == noteId);
      update();
      return true;
    }

    return false;
  }
}
