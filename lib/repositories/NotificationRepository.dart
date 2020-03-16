import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pikobar_flutter/configs/DBProvider.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/EndPointPath.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/HttpHeaders.dart';
import 'package:pikobar_flutter/models/NotificationModel.dart';
import 'package:sqflite/sqflite.dart';

class NotificationRepository {
  //get list data notification
  Future<void> fetchRecords(int page) async {
    // String token = await AuthRepository().getToken();

    final response = await http
        .get('${EndPointPath.profile}', headers: await HttpHeaders.headers())
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['items'];

      final list = listNotificationFromJson(jsonEncode(data));

      list.forEach((record) {
        insertToDatabase(record);
      });
    } else if (response.statusCode == 401) {
      throw Exception(ErrorException.unauthorizedException);
    } else if (response.statusCode == 408) {
      throw Exception(ErrorException.timeoutException);
    } else {
      throw Exception(Dictionary.somethingWrong);
    }
  }

  //get data list notficiation from database
  Future<List<NotificationModel>> getRecords(
      {bool forceRefresh = false, int page = 1}) async {
    bool hasLocal = await hasLocalData();

    if (hasLocal == false || forceRefresh == true) {
      await fetchRecords(page);
    }

    List<NotificationModel> localRecords = await getLocalData();

    return localRecords;
  }

  //insert data list notification into database
  Future<void> insertToDatabase(NotificationModel record) async {
    Database db = await DBProvider.db.database;
    try {
      await db.insert(
        'Notifications',
        record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> hasLocalData() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Notifications'));

    return count > 0;
  }

  // get data by database by desc
  Future<List<NotificationModel>> getLocalData() async {
    Database db = await DBProvider.db.database;

    var res = await db.query('Notifications', orderBy: 'id DESC');

    List<NotificationModel> list = res.isNotEmpty
        ? res.map((c) => NotificationModel.fromDatabaseJson(c)).toList()
        : [];

    return list;
  }

  Future<bool> hasUnreadData() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM Notifications WHERE read_at IS NULL'));

    return count > 0;
  }

  //for get data unread count list notfication
  Future<int> unreadCount() async {
    Database db = await DBProvider.db.database;

    int count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM Notifications WHERE read_at IS NULL'));

    return count;
  }

  // update read data list notification from database
  Future<int> updateReadData(int id) async {
    Database db = await DBProvider.db.database;
    int readAt =
        (DateTime.now().toLocal().millisecondsSinceEpoch / 1000).round();
    return await db.update('Notifications', {'read_at': readAt},
        where: 'id = ?', whereArgs: [id]);
  }

  //delete data from database
  Future<void> clearLocalData() async {
    Database db = await DBProvider.db.database;

    await db.rawDelete('Delete from Notifications');
  }
}
