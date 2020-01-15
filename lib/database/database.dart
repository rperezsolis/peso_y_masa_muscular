import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {

  AppDatabase._();

  static final AppDatabase appDatabase = AppDatabase._();
  Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'nutritional_indicators_database.db'),
      onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE indicators('
                + 'id INTEGER PRIMARY KEY, '
                + 'weight REAL, '
                + 'imc REAL, '
                + 'muscle REAL, '
                + 'fat REAL, '
                + 'date_time TEXT) '
          );
      },
      version: 1
    );

    return database;
  }
}