class Post {
  final String content;
  final int genreId;
  final String? createdAt;

  Post({required this.content, required this.genreId, this.createdAt});

  // API通信時にパラメータをjson形式に変換する
  Map<String, dynamic> toJson() => {
    'content': content,
    'genre_id': genreId,
  };

  // APIからのレスポンスをdartで扱える形式に変換する
  static Post fromJson(Map<String, dynamic> json) {
    return (
      Post(
        content: json['content'],
        genreId: json['genre_id'],
        createdAt: json['created_at']
      )
    );
  }
}
