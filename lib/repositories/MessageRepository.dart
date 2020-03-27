import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/configs/DBProvider.dart';
import 'package:sqflite/sqflite.dart';

class MessageRepository {
  //insert data from server to database
  Future<void> insertToDatabase(List<DocumentSnapshot> record) async {
    Database db = await DBProvider.db.database;

    Map<String, dynamic> toJson() => {
      "id": id,
      "backlink": record[''],
      "content": messageId,
      "title": senderId,
      "pubilshedAt": senderName,

    };

    try {
      await db.insert(
        'Messages',
        record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      print(e.toString());
    }
  }
}