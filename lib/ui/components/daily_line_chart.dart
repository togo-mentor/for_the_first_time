import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/models/post.dart';
import 'package:for_the_first_time/ui/components/weekly_line_chart.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

import 'monthly_line_chart.dart';

class DailyLineChart extends StatefulWidget {
  final List<Post> posts;
  DailyLineChart({Key? key, required this.posts}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _DailyLineChartState();
}

class _DailyLineChartState extends State<DailyLineChart> {
  List<dynamic> postsParDate = []; // グラフの表示データ
  String graphType = 'daily'; // グラフタイプ(日別・週別・月別)

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var todaysData = {
      'date': 7, // 今日の日付を7とする
      'count': countPostsParDate(now)
    };
    postsParDate.add(todaysData);
    for (var i = 1; i < 8; i++) {
      // 7から順に1ずつdateを減らす。これは日付ではなくグラフのメモリ
      var date = now.add(Duration(days: i) * -1);
      var dailyData = {
        'date': 7 - i,
        'count': countPostsParDate(date)
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

  // 指定された日付に投稿されたデータの数を取得
  int countPostsParDate(createdAt) {
    return widget.posts.where((post) => 
      formateTimeStamp(post.createdAt) == formateTimeStamp(createdAt.toString())
    ).length;
  }

  // 日別・週別・月別の切り替え
  List<DropdownMenuItem<String>> graphDropDownList() {
    return [
      DropdownMenuItem(
        child: Text (
          '日別',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        value: 'daily',
      ),
      DropdownMenuItem(
        child: Text (
          '週別',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        value: 'weekly',
      ),
      DropdownMenuItem(
        child: Text (
          '月別',
          style: TextStyle(
            fontSize: 18.0
          ),
        ),
        value: 'monthly',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              DropdownButton(
                items: graphDropDownList(),
                value: graphType,
                onChanged: (value) => {
                  setState(() {
                    graphType = value as String;
                  }),
                },
              ),
              SizedBox(
                width: 40
              )
            ]
          )
        ),
        SizedBox(
          height: 10
        ),
        SizedBox(
          height: 300,
          child: switchGraphType()
        ),
      ]
    );
  }

  // グラフの表示切り替え
  Widget switchGraphType() {
    switch(graphType) {
      case 'daily':
        return LineChart(
            sampleData1,
            swapAnimationDuration: const Duration(milliseconds: 250),
          );
      case 'weekly':
        return WeeklyLineChart(posts: widget.posts);
      case 'monthly':
        return MonthlyLineChart(posts: widget.posts);
    }
    return Container();
  }

  LineChartData get sampleData1 => LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: lineBarsData1,
      minX: 0,
      maxX: 10,
      maxY: 15,
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
        interval: 7,
        getTextStyles: (context, value) => const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        getTitles: (value) {
          var now = DateTime.now();
          var formatter = DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);
          switch (value.toInt()) {
            case 7:
              return formattedDate;
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