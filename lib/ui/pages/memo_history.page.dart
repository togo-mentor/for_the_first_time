import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/post_service.dart';
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