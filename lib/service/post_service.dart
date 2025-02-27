import 'dart:convert';
import 'package:for_the_first_time/models/post.dart';
import 'api_base_helper.dart';

// Api::PostsControllerと通信する
class PostService {
  final ApiBaseHelper _helper = ApiBaseHelper();

  // #index
  Future<List<Post>> fetchPosts() async {
    final response = await _helper.get("/posts");
    return List<Post>.from(response['data'].map(
        (post) => Post.fromJson(post))
      );
  }

  // #create
  Future<Map<String, dynamic>> createPost(Post newPost) async {
    final params = json.encode(newPost.toJson());
    return await _helper.post("/posts", params);
  }
}