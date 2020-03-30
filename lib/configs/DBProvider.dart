import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikobar_flutter/configs/FlavorConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final _dbName = Environment.databaseNameProd;
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE PopupInformation ("
          "id INTEGER PRIMARY KEY,"
          "last_shown TEXT"
          ")");
      await db.execute("CREATE TABLE Messages ("
          "id INTEGER PRIMARY KEY,"
          "backlink TEXT,"
          "content TEXT,"
          "title TEXT,"
          "read_at INTEGER,"
          "published_at INTEGER"
          ")");
    });
  }
}
