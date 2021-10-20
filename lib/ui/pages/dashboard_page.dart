import 'dart:async';
import 'package:flutter/material.dart';
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
          children: <Widget>[
            Indicator(
              color: const Color(0xff0293ee),
              text: 'One',
              isSquare: false,
              size: touchedIndex == 0 ? 18 : 16,
              textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xfff8b250),
              text: 'Two',
              isSquare: false,
              size: touchedIndex == 1 ? 18 : 16,
              textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xff845bef),
              text: 'Three',
              isSquare: false,
              size: touchedIndex == 2 ? 18 : 16,
              textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xff13d38e),
              text: 'Four',
              isSquare: false,
              size: touchedIndex == 3 ? 18 : 16,
              textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
            ),
          ],
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

  List<PieChartSectionData> showingSections() {
    Color darken(Color color, [double amount = .1]) {
      assert(amount >= 0 && amount <= 1);

      final hsl = HSLColor.fromColor(color);
      final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

      return hslDark.toColor();
    }


    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        const color0 = Color(0xff0293ee);
        const color1 = Color(0xfff8b250);
        const color2 = Color(0xff845bef);
        const color3 = Color(0xff13d38e);

        switch (i) {
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
            throw Error();
        }
      },
    );
  }
}