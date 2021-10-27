import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/genre.dart';
import 'package:for_the_first_time/service/post_service.dart';
import 'package:for_the_first_time/ui/components/daily_line_chart.dart';
import 'package:for_the_first_time/ui/components/genre_pie_chart.dart';
import 'package:for_the_first_time/ui/components/indicator.dart';
import '../../models/post.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<Post> posts = [];
  final bool animate = false;
  int touchedIndex = -1;
  String graphType = 'genre';

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
        posts = response;
      });
    } catch (e) {
      print(e);
    }
  }

  List<Color> colorList = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color(0xfff8bbd0),
    Color(0xff80cbc4),
    Color(0xff5c6bc0),
  ];

  List<DropdownMenuItem<String>> graphDropDownList() {
    return [
      DropdownMenuItem(
        child: Text (
          '日別',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        value: 'date',
      ),
      DropdownMenuItem(
        child: Text (
          'ジャンル別',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        value: 'genre',
      ),
    ];
  }

  // 取得したpostデータからグラフデータを生成する
  Widget showChart() {
    return  Column(
      children: <Widget>[
        SizedBox(
          height: 40,
        ),
        DropdownButton(
          items: graphDropDownList(),
          value: graphType,
          onChanged: (value) => {
            setState(() {
              graphType = value as String;
            }),
          },
        ),
        graphType == 'genre' ? GenrePieChart(posts: posts) : DailyLineChart(posts: posts),
        SizedBox(
          height: 40
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return posts.isNotEmpty
        ? showChart()
      : Center(child: CircularProgressIndicator());
  }

}