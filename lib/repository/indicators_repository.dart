import 'package:peso_y_masa_muscular/database/indicators_dao.dart';
import 'package:peso_y_masa_muscular/model/indicator.dart';

class IndicatorsRepository {
  final _indicatorsDao = IndicatorsDao();

  Future<List<Indicator>> getIndicators() => _indicatorsDao.getIndicatorList();

  saveIndicator(Indicator indicator) => _indicatorsDao.insertOrUpdateIndicator(indicator);
}