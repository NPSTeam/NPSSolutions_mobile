import '../models/note_model.dart';
import '../models/response_model.dart';
import 'dio_repo.dart';

final noteRepo = _NoteRepo();

class _NoteRepo extends DioRepo {
  Future<ResponseModel?> getNoteList() async {
    return await get('/api/v1/notes');
  }

  Future<ResponseModel?> getNoteDetail(int noteId) async {
    return await get('/api/v1/notes/$noteId');
  }

  Future<ResponseModel?> updateNote(NoteModel note) async {
    return await put('/api/v1/notes', data: note.toJson());
  }

  Future<ResponseModel?> createNote(NoteModel note) async {
    return await post('/api/v1/notes', data: note.toJson());
  }

  Future<ResponseModel?> deleteNote(int noteId) async {
    return await delete('/api/v1/notes/$noteId');
  }
}
