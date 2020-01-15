import 'package:peso_y_masa_muscular/database/database.dart';
import 'package:peso_y_masa_muscular/model/indicator.dart';
import 'package:sqflite/sqflite.dart';

class IndicatorsDao {

  Future<List<Indicator>> getIndicatorList() async {
    final Database db = await AppDatabase.appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query('indicators');
    return List.generate(maps.length, (item) {
      return Indicator(
        id: maps[item]['id'],
        weight: maps[item]['weight'],
        imc: maps[item]['imc'],
        muscle: maps[item]['muscle'],
        fat: maps[item]['fat'],
        dateTime: maps[item]['date_time'],
      );
    });
  }

  Future<void> insertOrUpdateIndicator(Indicator indicator) async {
    final Database db = await AppDatabase.appDatabase.database;
    DateTime date = DateTime.parse(indicator.dateTime);
    indicator.dateTime = DateTime(date.year, date.month, date.day).toIso8601String();
    List<Map<String, dynamic>> maps = await db.query('indicators', where: 'date_time = ?', whereArgs: [indicator.dateTime]);
    if(maps.length>0) {
      int id = maps[0]['id'];
      indicator.id = id;
      await db.update('indicators', indicator.toMap(), where: 'date_time = ?', whereArgs: [indicator.dateTime]);
    } else {
      await db.insert('indicators', indicator.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> updateIndicator(Indicator indicator) async {
    final Database db = await AppDatabase.appDatabase.database;
    await db.update('indicators', indicator.toMap(), where: 'id = ?', whereArgs: [indicator.id]);
  }

  Future<void> deleteIndicator(int id) async {
    final Database db = await AppDatabase.appDatabase.database;
    await db.delete('indicators', where: 'id = ?', whereArgs: [id]);
  }
}