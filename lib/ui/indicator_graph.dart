import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'package:peso_y_masa_muscular/model/indicator.dart';

class IndicatorGraph extends StatefulWidget {
  final List<charts.Series> seriesList;

  IndicatorGraph({this.seriesList});

  @override
  State<StatefulWidget> createState() => _IndicatorGraphState(seriesList);

  static List<charts.Series<Indicator, DateTime>> createSeries(List<Indicator> indicators, int indicatorIndex) {
    final indicatorNames = ['Weight', 'IMC', 'Muscle', 'Fat'];
    return [
      new charts.Series(
        id: indicatorNames[indicatorIndex],
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: indicators,
        domainFn: (Indicator indicator, _) => DateTime.parse(indicator.dateTime),
        measureFn: (Indicator indicator, _) => IndicatorGraph._indicatorField(indicator, indicatorIndex),
      )
    ];
  }

  static double _indicatorField(Indicator indicator, int indicatorIndex) {
    double indicatorField;
    switch(indicatorIndex) {
      case 0 : {
        indicatorField = indicator.weight;
      }
      break;
      case 1 : {
        indicatorField = indicator.imc;
      }
      break;
      case 2 : {
        indicatorField = indicator.muscle;
      }
      break;
      case 3 : {
        indicatorField = indicator.fat;
      }
      break;
    }
    return indicatorField;
  }
}

class _IndicatorGraphState extends State<IndicatorGraph> {
  List<charts.Series> _seriesList;

  _IndicatorGraphState(List<charts.Series> seriesList) {
    _seriesList = seriesList;
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      _seriesList,
      animate: false,
    );
  }
}