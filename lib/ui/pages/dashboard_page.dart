import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/genre.dart';
import 'package:for_the_first_time/service/post_service.dart';
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
        graphType == 'genre' ? GenrePieChart(posts: posts) : 
        SizedBox(
          height: 40
        )
      ]
    );
  }
  

  Widget genrePieChart() {
    return Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                  pieTouchData:
                      PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      print(pieTouchResponse.touchedSection!.touchedSectionIndex);
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 15,
                  sections: showingSections(),
              ),
            ),
          )
        );
  }

  @override
  Widget build(BuildContext context) {
    return posts.isNotEmpty
        ? showChart()
      : Center(child: CircularProgressIndicator());
  }

  List<Widget> indicators() {
    return genreList.map((genre) {
      return SizedBox(
        width: 100,
        child: Indicator(
        color: colorList[genre.id - 1],
        text: genre.name,
        isSquare: false,
        size: touchedIndex == 0 ? 18 : 16,
        textColor: touchedIndex == genre.id - 1 ? Colors.black : Colors.grey,
        )
      );
    }).toList();
  }

  List<PieChartSectionData> showingSections() {
    Color darken(Color color, [double amount = 1]) {

      final hsl = HSLColor.fromColor(color);
      final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

      return hslDark.toColor();
    }

    List<Post> speciticGenrePosts(genreId) {
      return posts.where((post) => post.genreId == genreId).toList();
    }

    PieChartSectionData pieChartData(genreId) {
        final isTouched = genreId - 1 == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        return PieChartSectionData(
          color: colorList[genreId -1].withOpacity(opacity),
          value: (speciticGenrePosts(genreId).length / posts.length) * 100,
          title: speciticGenrePosts(genreId).length.toString(),
          radius: 100,
          titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xF1000000)
          ),
          titlePositionPercentageOffset: 0.55,
          borderSide: isTouched
              ? BorderSide(color: darken(colorList[genreId -1], 40), width: 3)
              : BorderSide(color: colorList[genreId - 1].withOpacity(0)),
        );        
    }

    return genreList.map((genre) {
      return pieChartData(genre.id);
    }).toList();
  }
}