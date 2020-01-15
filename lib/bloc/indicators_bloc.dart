import 'package:peso_y_masa_muscular/model/indicator.dart';
import 'package:peso_y_masa_muscular/repository/indicators_repository.dart';
import 'package:rxdart/rxdart.dart';

class IndicatorsBloc {
  final _repository  = IndicatorsRepository();
  final _indicatorsFetcher = PublishSubject<List<Indicator>>();

  Observable<List<Indicator>> get allIndicators => _indicatorsFetcher.stream;

  getIndicators() async {
    List<Indicator> indicators = await _repository.getIndicators();
    _indicatorsFetcher.sink.add(indicators);
  }

  saveIndicator(Indicator indicator) async {
    await _repository.saveIndicator(indicator);
    getIndicators();
  }

  dispose() {
    _indicatorsFetcher.close();
  }
}

final bloc = IndicatorsBloc();