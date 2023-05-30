import 'package:get/get.dart';

import '../models/note_label_model.dart';
import '../models/note_model.dart';
import '../models/response_model.dart';
import '../repositories/note_repo.dart';

class NoteListController extends GetxController {
  List<NoteModel>? notes;
  List<NoteLabelModel> labels = [];

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

  Future<bool> getNotesWithLabel(String labelId) async {
    ResponseModel? response = await noteRepo.getNoteListWithLabel(labelId);

    if (response?.data != null) {
      notes =
          (response?.data as List).map((e) => NoteModel.fromJson(e)).toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> getLabels() async {
    ResponseModel? response = await noteRepo.getLabels();

    if (response?.data != null) {
      labels = (response?.data as List)
          .map((e) => NoteLabelModel.fromJson(e))
          .toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> getReminders() async {
    ResponseModel? response = await noteRepo.getReminderList();

    if (response?.data != null) {
      notes =
          (response?.data as List).map((e) => NoteModel.fromJson(e)).toList();

      update();
      return true;
    }

    return false;
  }

  Future<bool> getArchives() async {
    ResponseModel? response = await noteRepo.getArchiveList();

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
