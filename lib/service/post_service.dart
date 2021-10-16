import 'package:firebase_auth/firebase_auth.dart';
import 'package:for_the_first_time/models/post.dart';

import 'api_base_helper.dart';

class PostService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Post>> fetchPosts() async {
    final response = await _helper.get("/posts");
    return List<Post>.from(response['data'].map(
        (post) => Post.fromJson(post))
      );
  }
}