import 'package:flutter/widgets.dart';

class Indicator {
  int id;
  final double weight;
  final double imc;
  final double muscle;
  final double fat;
  String dateTime;

  Indicator({this.id, @required this.weight, @required this.imc, @required this.muscle, @required this.fat, @required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'weight' : weight,
      'imc' : imc,
      'muscle' : muscle,
      'fat' : fat,
      'date_time' : dateTime
    };
  }
}