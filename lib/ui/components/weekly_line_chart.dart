import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/post.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class WeeklyLineChart extends StatefulWidget {
  final List<Post> posts;
  WeeklyLineChart({Key? key, required this.posts}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WeeklyLineChartState();
}

class _WeeklyLineChartState extends State<WeeklyLineChart> {
  List<dynamic> postsParDate = [];

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    for (var i = 0; i < 4; i++) {
      int count = 0;
      for (var j = 8 * i; j < 8 * i + 8; j++) {
        var date = now.add(Duration(days: j) * -1);
        count += countPostsParDate(date);
      }
      var dailyData = {
        'date': 3 - i,
        'count': count
      };
      postsParDate.add(dailyData);
    }
  }

  // created_atの整形
  String formateTimeStamp(createdAtString) {
    initializeDateFormatting("ja_JP");
    DateTime createdAtDatetime = DateTime.parse(createdAtString); 
    var formatter = DateFormat('yyyy/MM/dd', "ja_JP");
    return formatter.format(createdAtDatetime.toLocal());
  }

  int countPostsParDate(createdAt) {
    return widget.posts.where((post) => 
      formateTimeStamp(post.createdAt) == formateTimeStamp(createdAt.toString())
    ).length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        sampleData1,
        swapAnimationDuration: const Duration(milliseconds: 250),
      )
    );
  }

  LineChartData get sampleData1 => LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: 4,
      maxY: 24,
      minY: 0,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            return (value.toInt()).toString() + "件";
          },
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
    LineChartBarData(
      isCurved: false,
      colors: [const Color(0xff4af699)],
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: true),
      spots: postsParDate.map((data) => 
        FlSpot(double.parse(data['date'].toString()), data['count'].toDouble())
      ).toList())      

  ];
  

  SideTitles leftTitles({required GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 3,
        reservedSize: 40,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
        getTitles: (value) {
          var now = DateTime.now();
          var formatter = DateFormat('MM-dd');
          switch (value.toInt()) {
            case 3:
              String formattedTo = formatter.format(now);
              var from = now.add(Duration(days: 7) * - 1);
              String formattedFrom = formatter.format(from);
              return '$formattedFrom - $formattedTo';
            case 2:
              var to = now.add(Duration(days: 7) * - 1);
              String formattedTo = formatter.format(to);
              var from = now.add(Duration(days: 14) * - 1);
              String formattedFrom = formatter.format(from);
              return '$formattedFrom - $formattedTo';
            case 1:
            var to = now.add(Duration(days: 14) * - 1);
              String formattedTo = formatter.format(to);
              var from = now.add(Duration(days: 21) * - 1);
              String formattedFrom = formatter.format(from);
              return '$formattedFrom - $formattedTo';
            case 0:
              var to = now.add(Duration(days: 21) * - 1);
              String formattedTo = formatter.format(to);
              var from = now.add(Duration(days: 28) * - 1);
              String formattedFrom = formatter.format(from);
              return '$formattedFrom - $formattedTo';
          }
          return '';
        },
  );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff4e4965), width: 4),
          left: BorderSide(color: Color(0xff4e4965), width: 4),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );
}