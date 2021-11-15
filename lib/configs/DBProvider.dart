import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static const _dbVersion = 3;

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
    return await openDatabase(path,
        version: _dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  static const String _createTablePopupInformation =
      "CREATE TABLE PopupInformation ("
      "id INTEGER PRIMARY KEY,"
      "last_shown TEXT"
      ")";

  static const String _createTableMessages = "CREATE TABLE Messages ("
      "id TEXT PRIMARY KEY,"
      "backlink TEXT,"
      "content TEXT,"
      "title TEXT,"
      "action_title TEXT,"
      "action_url TEXT,"
      "read_at INTEGER,"
      "published_at INTEGER"
      ")";

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createTablePopupInformation);
    await db.execute(_createTableMessages);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      try {
        await db.execute("DROP TABLE IF EXISTS Messages");
        await db.execute(_createTableMessages);
      } catch (e) {
        print("Update v3 error : ${e.toString()}");
      }
    }
  }
}
