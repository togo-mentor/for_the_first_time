import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/post.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

class MonthlyLineChart extends StatefulWidget {
  final List<Post> posts;
  MonthlyLineChart({Key? key, required this.posts}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MonthlyLineChartState();
}

class _MonthlyLineChartState extends State<MonthlyLineChart> {
  List<dynamic> postsParDate = [];

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    for (var i = 0; i < 4; i++) {
      var date = DateTime(now.year, now.month - i, now.day);
      var dailyData = {
        'date': 3 - i,
        'count': countPostsParDate(date)
      };
      postsParDate.add(dailyData);
    }
  }

  // created_atの整形
  String formateTimeStamp(createdAtString) {
    initializeDateFormatting("ja_JP");
    DateTime createdAtDatetime = DateTime.parse(createdAtString); 
    var formatter = DateFormat('yyyy/MM', "ja_JP");
    return formatter.format(createdAtDatetime.toLocal());
  }

  // フォーマッターを年月のみ指定にすることで、特定の月に投稿されたデータを取得
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
        reservedSize: 10,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 9,
        ),
        getTitles: (value) {
          var now = DateTime.now();
          var formatter = DateFormat('yyyy-MM');
          switch (value.toInt()) {
            case 3:
              String thisMonth = formatter.format(now);
              return thisMonth;
            case 2:
              var date = DateTime(now.year, now.month - 1, now.day);
              String formattedMonth = formatter.format(date);
              return formattedMonth;
            case 1:
              var date = DateTime(now.year, now.month - 2, now.day);
              String formattedMonth = formatter.format(date);
              return formattedMonth;
            case 0:
              var date = DateTime(now.year, now.month - 3, now.day);
              String formattedMonth = formatter.format(date);
              return formattedMonth;
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