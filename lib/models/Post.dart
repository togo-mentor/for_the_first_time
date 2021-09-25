class Post {
  final String content;
  final int genreId;
  final String userToken;

  Post({required this.content, required this.genreId, required this.userToken});
  Map<String, dynamic> toJson() => {
    'content': content,
    'genre_id': genreId,
    'user_token': userToken,
  };

  static Post fromJson(Map<String, dynamic> json) {
    print(json);
    return (
      Post(
        content: json['content'],
        genreId: json['genre_id'],
        userToken: json['user_token']
      )
    );
  }
}
