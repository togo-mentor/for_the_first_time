import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:for_the_first_time/models/ModelProvider.dart';
import '../../models/Post.dart';
import 'package:for_the_first_time/models/Genre.dart';

class MemoHistoryPage extends StatefulWidget {
  @override
  _MemoHistoryPageState createState() => _MemoHistoryPageState();
}

class _MemoHistoryPageState extends State<MemoHistoryPage> {
  List<Post> _posts = [];
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    _subscription = Amplify.DataStore.observe(Post.classType).listen((event) {
      _fetchPosts();
    });
    await _fetchPosts();
  }

  void dispose() {
    // cancel the subscription when the state is removed from the tree
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    try {
    
      // query for all post entries by passing the Todo classType to
      // Amplify.DataStore.query()
      List<Post> updatedPosts = await Amplify.DataStore.query(Post.classType);
      
      // update the ui state to reflect fetched todos
      setState(() {
        _posts = updatedPosts;
      });
    } catch (e) {
      print('An error occurred while querying Todos: $e');
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
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
