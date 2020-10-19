import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/ErrorException.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/AddOtherSelfReportModel.dart';
import 'package:pikobar_flutter/models/ContactHistoryModel.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';
import 'package:pikobar_flutter/utilities/Connection.dart';

class SelfReportRepository {
  final Firestore _firestore = Firestore.instance;

  /// Reads the daily report document in the self reports collection referenced by the [DocumentReference].
  Future<DocumentSnapshot> getSelfReportDetail(
      {@required String userId,
      @required String dailyReportId,
      String otherUID}) async {
    DocumentSnapshot doc;
    if (otherUID == null) {
      doc = await _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kDailyReport)
          .document(dailyReportId)
          .get();
    } else {
      doc = await _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kOtherSelfReports)
          .document(otherUID)
          .collection(kDailyReport)
          .document(dailyReportId)
          .get();
    }

    return doc;
  }

  Future<void> saveDailyReport(
      {@required String userId,
      @required DailyReportModel dailyReport,
      String otherUID}) async {
    try {
      var doc;
      if (otherUID == null) {
        doc = _firestore
            .collection(kSelfReports)
            .document(userId)
            .collection(kDailyReport)
            .document(dailyReport.id);
      } else {
        doc = _firestore
            .collection(kSelfReports)
            .document(userId)
            .collection(kOtherSelfReports)
            .document(otherUID)
            .collection(kDailyReport)
            .document(dailyReport.id);
      }

      await doc.get().then((snapshot) async {
        if (!snapshot.exists) {
          await doc.setData(dailyReport.toJson());
        } else {
          await doc.updateData(dailyReport.toJson());
        }
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  Future<void> saveOtherUser(
      {@required String userId,
      @required AddOtherSelfReportModel dailyReport}) async {
    try {
      var doc = _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kOtherSelfReports)
          .document(dailyReport.userId);

      await doc.get().then((snapshot) async {
        await doc.setData(dailyReport.toJson());
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /// Reads the self report document referenced by the [CollectionReference].
  Stream<QuerySnapshot> getSelfReportList(
      {@required String userId, String otherUID}) {
    final selfReport = _firestore.collection(kSelfReports).document(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.setData({'remind_me': false, 'user_id': userId});
      }
    });

    return otherUID == null
        ? _firestore
            .collection(kSelfReports)
            .document(userId)
            .collection(kDailyReport)
            .snapshots()
        : _firestore
            .collection(kSelfReports)
            .document(userId)
            .collection(kOtherSelfReports)
            .document(otherUID)
            .collection(kDailyReport)
            .snapshots();
  }

  Stream<QuerySnapshot> getContactHistoryList({@required String userId}) {
    final selfReport = _firestore.collection(kSelfReports).document(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.setData({'remind_me': false, 'user_id': userId});
      }
    });

    return _firestore
        .collection(kSelfReports)
        .document(userId)
        .collection(kContactHistory)
        .snapshots();
  }

  Stream<QuerySnapshot> getOtherSelfReport({@required String userId}) {
    final selfReport = _firestore.collection(kSelfReports).document(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.setData({'remind_me': false, 'user_id': userId});
      }
    });

    return _firestore
        .collection(kSelfReports)
        .document(userId)
        .collection(kOtherSelfReports)
        .snapshots();
  }

  Future<DocumentSnapshot> getContactHistoryDetail(
      {@required String userId, @required String contactHistoryId}) async {
    DocumentSnapshot doc = await _firestore
        .collection(kSelfReports)
        .document(userId)
        .collection(kContactHistory)
        .document(contactHistoryId)
        .get();
    return doc;
  }

  Stream<DocumentSnapshot> getIsReminder({@required String userId}) {
    return _firestore.collection(kSelfReports).document(userId).snapshots();
  }

  Future updateToCollection({@required String userId, bool isReminder}) async {
    return await _firestore
        .collection(kSelfReports)
        .document(userId)
        .updateData({
      'remind_me': isReminder,
    });
  }

  /// Save the contact history to firestore with provided [data]
  /// to the [kContactHistory] collection
  /// in documents in the [kSelfReports] collection referenced by the [userId]
  Future<void> saveContactHistory(
      {@required String userId, @required ContactHistoryModel data}) async {
    if (await Connection().checkConnection(kUrlGoogle)) {
      CollectionReference ref = _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kContactHistory);

      await ref.add(data.toJson()).then((doc) async {
        await doc.updateData({'id': doc.documentID});
      });
    } else {
      throw SocketException(ErrorException.socketException);
    }
  }
}
