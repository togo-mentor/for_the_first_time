import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/genre.dart';
import 'package:for_the_first_time/service/post_service.dart';
import 'package:for_the_first_time/ui/components/indicator.dart';
import '../../models/post.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<Post> _posts = [];
  final bool animate = false;
  int touchedIndex = -1;

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

  List<Color> colorList = [
    Color(0xff0293ee),
    Color(0xfff8b250),
    Color(0xff845bef),
    Color(0xff13d38e),
    Color(0xfff8bbd0),
    Color(0xff80cbc4),
    Color(0xff5c6bc0),
  ];

  // 取得したpostデータからグラフデータを生成する
  Widget createChartData() {
    return  Column(
      children: <Widget>[
        Expanded(
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
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: Wrap(
            children: indicators()
          ),
        ),
        SizedBox(
          height: 40
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return _posts.isNotEmpty
        ? createChartData()
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
        textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
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

    double calculatePercentage(genreId) {
      List<Post> speciticGenrePosts = _posts.where((post) => post.genreId == genreId).toList();
      return (speciticGenrePosts.length / _posts.length) * 100;
    }

    PieChartSectionData pieChartData(genreId) {
        final isTouched = genreId == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;
  

        switch (genreId) {
          case 1:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId].withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
          case 4:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff13d38e)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
          case 5:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xfff8bbd0)
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
          case 6:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff80cbc4)
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
          case 7:
            return PieChartSectionData(
              color: colorList[genreId -1].withOpacity(opacity),
              value: calculatePercentage(genreId),
              title: '',
              radius: 100,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5c6bc0)
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(colorList[genreId -1], 40), width: 6)
                  : BorderSide(color: colorList[genreId -1].withOpacity(0)),
            );
            default:
              throw Error();
        }
    }

    return genreList.map((genre) {
      return pieChartData(genre.id);
    }).toList();
  }
}