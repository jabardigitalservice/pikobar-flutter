import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final _dbName = Environment.databaseNameProd;

  static final _dbVersion = 2;

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
    return await openDatabase(path, version: _dbVersion,
        onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE PopupInformation ("
        "id INTEGER PRIMARY KEY,"
        "last_shown TEXT"
        ")");
    await db.execute("CREATE TABLE Messages ("
        "id INTEGER PRIMARY KEY,"
        "backlink TEXT,"
        "content TEXT,"
        "title TEXT,"
        "action_title TEXT,"
        "action_url TEXT,"
        "read_at INTEGER,"
        "published_at INTEGER"
        ")");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print(oldVersion);
    if (oldVersion < 2) {
      try {
        await db.execute("ALTER TABLE Messages ADD COLUMN action_title TEXT");
        await db.execute("ALTER TABLE Messages ADD COLUMN action_url TEXT");
      } catch (e){
        print("Altering error : ${e.toString()}");
      }
    }
  }
}
