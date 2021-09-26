import 'package:flutter/material.dart';
import '../../models/Post.dart';
import 'package:for_the_first_time/models/Genre.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';


class PostItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Post post;

  PostItem({required this.post});

  String renderGenreName(genreId) {
    final genre = genreList.firstWhere((genre) => genre.id == genreId);
    return genre.name;
  }

  String formateTimeStamp(createdAtString) {
    initializeDateFormatting("ja_JP");
    DateTime createdAtDatetime = DateTime.parse(createdAtString); 
    var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP");
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
