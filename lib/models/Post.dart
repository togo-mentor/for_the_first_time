class Post {
  final String content;
  final int genre_id;
  final String user_token;

  Post({required this.content, required this.genre_id, required this.user_token});
  Map<String, dynamic> toJson() => {
    'content': content,
    'genre_id': genre_id,
    'user_token': user_token,
  };
}