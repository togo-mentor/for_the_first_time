import 'package:charts_flutter/flutter.dart' as charts;

class PostSeries {
  final int genreId;
  final int count;
  final charts.Color barColor;

  PostSeries(
    {
      required this.genreId,
      required this.count,
      required this.barColor
    }
  );
}