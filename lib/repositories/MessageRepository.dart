import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/configs/DBProvider.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  //insert data from server to database
  Future<void> insertToDatabase(
      List<DocumentSnapshot> record, String tableName) async {
    Database db = await DBProvider.db.database;

    for (int i = 0; i < record.length; i++) {
      MessageModel messageModel = MessageModel(
          id: record[i].id,
          backLink: getField(record[i], 'backlink'),
          content: getField(record[i], 'content'),
          title: getField(record[i], 'title'),
          actionTitle: getField(record[i], 'action_title'),
          actionUrl: getField(record[i], 'action_url'),
          publishedAt: record[i].get('published_at').seconds,
          readAt: 0);

      if (!hasNullField(messageModel)) {
        try {
          await db.insert(
            tableName,
            messageModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  //get detail message from firestore
  Future<DocumentSnapshot> getDetail(String id, collection) {
    return FirebaseFirestore.instance.collection(collection).doc(id).get();
  }

  //get data list message from local db
  Future<List<MessageModel>> getRecords(String tableName) async {
    List<MessageModel> localRecords = await getLocalData(tableName);

    return localRecords;
  }

  Future<bool> hasLocalData(String tableName) async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));

    return count > 0;
  }

  static bool hasNullField(MessageModel data) {
    return data.id == null ||
        data.title == null ||
        data.content == null ||
        data.publishedAt == null;
  }

  Future<bool> checkData(String id, String tableName) async {
    Database db = await DBProvider.db.database;

    var res = await db.query(tableName,
        columns: ["id"], where: 'id = ?', whereArgs: [id]);

    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<MessageModel>> getLocalData(String tableName) async {
    Database db = await DBProvider.db.database;

    var res = await db
        .rawQuery('SELECT * FROM $tableName ORDER BY published_at DESC');

    List<MessageModel> list =
        res.isNotEmpty ? res.map((c) => MessageModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> hasUnreadData() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Messages WHERE read_at IS 0'));

    int personalCount = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM PersonalMessages WHERE read_at IS 0'));

    return count + personalCount;
  }

  //Update read message
  Future<int> updateData(MessageModel data, String tableName) async {
    Database db = await DBProvider.db.database;
    int readAt =
        (DateTime.now().toLocal().millisecondsSinceEpoch / 1000).round();
    return await db.update(
        tableName,
        {
          'backlink': data.backLink,
          'content': data.content,
          'title': data.title,
          'action_title': data.actionTitle,
          'action_url': data.actionUrl,
          'read_at': readAt,
          'published_at': data.publishedAt
        },
        where: 'id = ?',
        whereArgs: [data.id]);
  }

  //Update all read message
  Future<int> updateAllReadData(String tableName) async {
    Database db = await DBProvider.db.database;
    int readAt =
        (DateTime.now().toLocal().millisecondsSinceEpoch / 1000).round();
    return await db.update(tableName, {'read_at': readAt});
  }

  //Clear all data from db
  Future<void> clearLocalData(String tableName) async {
    Database db = await DBProvider.db.database;

    await db.rawDelete('Delete from $tableName');
  }
}
