import '../models/response_model.dart';
import 'dio_repo.dart';

final noteRepo = _NoteRepo();

class _NoteRepo extends DioRepo {
  Future<ResponseModel?> getNoteList() async {
    return await get('/api/v1/notes');
  }
}
