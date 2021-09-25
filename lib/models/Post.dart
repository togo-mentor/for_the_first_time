class Post {
  final String content;
  final int genre_id;

  Post({required this.content, required this.genre_id});
  Map<String, dynamic> toJson() => {
    'content': content,
    'genre_id': genre_id,
  };
}