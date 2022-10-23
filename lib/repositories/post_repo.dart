import 'package:nps_social/models/post_model.dart';
import 'package:nps_social/repositories/crud_repo.dart';

final postRepository = _PostRepository();

class _PostRepository extends CrudRepository {
  Future<List<PostModel>?> getPosts() async {
    List<PostModel>? posts;

    var result = await get('/api/post/getPosts');
    if (result?.data['posts'] != null) {
      posts = List<PostModel>.from(
          result?.data['posts'].map((e) => PostModel.fromJson(e)));
      return posts;
    }
    return null;
  }
}
