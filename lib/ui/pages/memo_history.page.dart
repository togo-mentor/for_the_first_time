import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import '../../models/Post.dart';
import 'package:for_the_first_time/models/Genre.dart';
import 'package:http/http.dart' as http;

class MemoHistoryPage extends StatefulWidget {
  @override
  _MemoHistoryPageState createState() => _MemoHistoryPageState();
}

class _MemoHistoryPageState extends State<MemoHistoryPage> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      String url = 'http://127.0.0.1:3000/posts';
      final response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json"}
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // update the ui state to reflect fetched todos
        setState(() {
          _posts = List<Post>.from(responseData['data'].map(
            (post) => Post.fromJson(post))
          );
        });
      }
    } catch (e) {
      print('An error occurred while querying Posts: $e');
    }
  }

  Widget build(BuildContext context) {
    return _posts.length >= 1
        ? ListView(
            padding: EdgeInsets.all(8),
            children: _posts.map((post) => PostItem(post: post)).toList())
        : Center(child: Text('Tap button below to add a todo!'));
  }
}

class PostItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Post post;

  PostItem({required this.post});

  String renderGenreName(genreId) {
    final genre = genreList.firstWhere((genre) => genre.id == genreId);
    return genre.name;
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
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
