import 'package:flutter/material.dart';
import '../../models/post.dart';
import 'package:for_the_first_time/models/genre.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

// 投稿一覧の一つ一つの投稿を表示するためのコンポーネント
class PostItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Post post;

  PostItem({required this.post});

  // genre_idをジャンルの名前に変換する
  String renderGenreName(genreId) {
    final genre = genreList.firstWhere((genre) => genre.id == genreId);
    return genre.name;
  }

  // created_atの整形
  String formateTimeStamp(createdAtString) {
    initializeDateFormatting("ja_JP");
    DateTime createdAtDatetime = DateTime.parse(createdAtString); 
    var formatter = DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
    return formatter.format(createdAtDatetime.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(renderGenreName(post.genreId)),
                  Text(formateTimeStamp(post.createdAt)),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
