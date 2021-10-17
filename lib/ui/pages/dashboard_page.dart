import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/post_service.dart';
import '../../models/post.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
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
      final response = await PostService().fetchPosts();
      setState(() {
        _posts = response;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_posts.isNotEmpty
        ? Text('hoge')
      : Center(child: CircularProgressIndicator());
  }
}