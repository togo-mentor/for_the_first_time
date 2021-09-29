class Post {
  final String content;
  final int genreId;
  final String userToken;
  final String? createdAt;

  Post({required this.content, required this.genreId, required this.userToken, this.createdAt});
  Map<String, dynamic> toJson() => {
    'content': content,
    'genre_id': genreId,
    'user_token': userToken,
  };

  static Post fromJson(Map<String, dynamic> json) {
    return (
      Post(
        content: json['content'],
        genreId: json['genre_id'],
        userToken: json['user_token'],
        createdAt: json['created_at']
      )
    );
  }
}
