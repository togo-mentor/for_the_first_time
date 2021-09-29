import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:for_the_first_time/ui/components/post_item.dart';
import '../../models/post.dart';
import 'package:http/http.dart' as http;

class MemoHistoryPage extends StatefulWidget {
  @override
  _MemoHistoryPageState createState() => _MemoHistoryPageState();
}

class _MemoHistoryPageState extends State<MemoHistoryPage> {
  List<Post> _posts = [];
  final ScrollController _controller = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    return _posts.isNotEmpty
        ? ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            padding: EdgeInsets.all(8),
            children: _posts.map((post) => PostItem(post: post)).toList()
          )
      : Center(child: CircularProgressIndicator());
  }
}