import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/configs/DBProvider.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  //insert data from server to database
  Future<void> insertToDatabase(List<DocumentSnapshot> record) async {
    Database db = await DBProvider.db.database;

    for (int i = 0; i < record.length; i++) {
      MessageModel messageModel = MessageModel(
          backLink: record[i]['backlink'].toString(),
          content: record[i]['content'].toString(),
          title: record[i]['title'].toString(),
          actionTitle: record[i]['action_title'],
          actionUrl: record[i]['action_url'],
          publishedAt: record[i]['published_at'].seconds,
          readAt: 0);
      try {
        bool dataCheck = await checkData(messageModel.title);
        if (!dataCheck) {
          await db.insert(
            'Messages',
            messageModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
      } catch (e) {
        var listMessage = await MessageRepository().getRecords();
        if (!listMessage.contains(messageModel)) {
          await db.insert(
            'Messages',
            messageModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        }
        print(e.toString());
      }
    }
  }

  //get data list message from local db
  Future<List<MessageModel>> getRecords() async {
    List<MessageModel> localRecords = await getLocalData();

    return localRecords;
  }

  Future<bool> hasLocalData() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Messages'));

    return count > 0;
  }

  Future<bool> checkData(String title) async {
    Database db = await DBProvider.db.database;

    var res = await db.query("Messages",
        columns: ["title"], where: 'title = ?', whereArgs: [title]);

    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MessageModel>> getLocalData() async {
    Database db = await DBProvider.db.database;

    var res =
    await db.rawQuery('SELECT * FROM Messages ORDER BY published_at DESC');

    List<MessageModel> list =
    res.isNotEmpty ? res.map((c) => MessageModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> hasUnreadData() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Messages WHERE read_at IS 0'));

    return count;
  }

  //Update read message
  Future<int> updateReadData(String title) async {
    Database db = await DBProvider.db.database;
    int readAt =
    (DateTime.now().toLocal().millisecondsSinceEpoch / 1000).round();
    return await db.update('Messages', {'read_at': readAt},
        where: 'title = ?', whereArgs: [title]);
  }

  //Update all read message
  Future<int> updateAllReadData() async {
    Database db = await DBProvider.db.database;
    int readAt =
    (DateTime.now().toLocal().millisecondsSinceEpoch / 1000).round();
    return await db.update('Messages', {'read_at': readAt});
  }

  //Clear all data from db
  Future<void> clearLocalData() async {
    Database db = await DBProvider.db.database;

    await db.rawDelete('Delete from Messages');
  }
}
