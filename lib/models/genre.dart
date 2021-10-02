class Genre {
  final int id;
  final String name;

  Genre(this.id, this.name);
}

// プルダウンに表示するジャンルのリスト。ジャンルを増やしたい場合はここに追加
List<Genre> genreList = <Genre>[
  Genre(1, '食'),
  Genre(2, '運動'),
  Genre(3, '自然'),
  Genre(4, '勉強'),
  Genre(5, '読書'),
  Genre(6, '旅'),
  Genre(7, '人間関係'),
];