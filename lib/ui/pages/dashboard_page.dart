import 'dart:async';
import 'package:flutter/material.dart';
import 'package:for_the_first_time/service/post_service.dart';
import '../../models/post.dart';

/// Simple pie chart example.
// EXCLUDE_FROM_GALLERY_DOCS_START
import 'dart:math';
// EXCLUDE_FROM_GALLERY_DOCS_END
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<Post> _posts = [];
  final ScrollController _controller = ScrollController();
  final bool animate = false;
  final List<charts.Series<dynamic, num>> seriesList = [];

  @override
  void initState() {
    super.initState();
    _initializeApp();
    _createRandomData();
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

  /// Create random data.
  static List<charts.Series<LinearSales, int>> _createRandomData() {
    final random = Random();

    final data = [
      LinearSales(0, random.nextInt(100)),
      LinearSales(1, random.nextInt(100)),
      LinearSales(2, random.nextInt(100)),
      LinearSales(3, random.nextInt(100)),
    ];

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return !_posts.isNotEmpty
        ? charts.PieChart(seriesList, animate: animate)
      : Center(child: CircularProgressIndicator());
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}