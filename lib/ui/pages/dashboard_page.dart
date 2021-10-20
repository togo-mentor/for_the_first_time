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
                  centerSpaceRadius: 10,
                  sections: showingSections(),
              ),
            ),
          )
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: indicators()
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
      return Indicator(
        color: colorList[genre.id - 1],
        text: genre.name,
        isSquare: false,
        size: touchedIndex == 0 ? 18 : 16,
        textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
      );
    }).toList();
  }

  List<PieChartSectionData> showingSections() {
    Color darken(Color color, [double amount = .1]) {
      assert(amount >= 0 && amount <= 1);

      final hsl = HSLColor.fromColor(color);
      final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

      return hslDark.toColor();
    }

    PieChartSectionData pieChartData(genreId) {
        final isTouched = genreId == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);
        const color2 = Color(0xff845bef);
        const color3 = Color(0xff13d38e);

        switch (genreId) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(color0, 40), width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(color1, 40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? BorderSide(color: darken(color2, 40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(color3, 40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          default:
            return PieChartSectionData(
              color: color3.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: darken(color3, 40), width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
        }
    }

    return genreList.map((genre) {
      return pieChartData(genre.id);
    }).toList();
  }
}