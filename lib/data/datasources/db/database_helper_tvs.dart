import 'dart:async';

import 'package:ditonton/data/models/tv/tv_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTvs {
  static DatabaseHelperTvs? _databaseHelpertv;
  DatabaseHelperTvs._instance() {
    _databaseHelpertv = this;
  }

  factory DatabaseHelperTvs() => _databaseHelpertv ?? DatabaseHelperTvs._instance();

  static Database? _databasetvs;

  Future<Database?> get databasetvs async {
    if (_databasetvs == null) {
      _databasetvs = await _initDb();
    }
    return _databasetvs;
  }

  static const String _tblWatchlisttvs = 'watchlisttv';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditontontvs.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlisttvs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistTv(TvTable tv) async {
    final db = await databasetvs;
    return await db!.insert(_tblWatchlisttvs, tv.toJson());
  }

  Future<int> removeWatchlistTv(TvTable tv) async {
    final db = await databasetvs;
    return await db!.delete(
      _tblWatchlisttvs,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await databasetvs;
    final results = await db!.query(
      _tblWatchlisttvs,
      where: 'id = ?',
      whereArgs: [id],
    );
  if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
  
  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await databasetvs;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlisttvs);

    return results;
  }
}
