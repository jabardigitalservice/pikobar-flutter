import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/ContactHistoryModel.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';

class SelfReportRepository {
  final Firestore _firestore = Firestore.instance;

  /// Reads the daily report document in the self reports collection referenced by the [DocumentReference].
  Future<DocumentSnapshot> getSelfReportDetail(
      {@required String userId, @required String dailyReportId}) async {
    DocumentSnapshot doc = await _firestore
        .collection(kSelfReports)
        .document(userId)
        .collection(kDailyReport)
        .document(dailyReportId)
        .get();
    return doc;
  }

  Future<void> saveDailyReport(
      {@required String userId, @required DailyReportModel dailyReport}) async {
    try {
      DocumentReference doc = _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kDailyReport)
          .document(dailyReport.id);

      await doc.get().then((snapshot) async {
        if (!snapshot.exists) {
          await doc.setData(dailyReport.toJson());
        }
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /// Reads the self report document referenced by the [CollectionReference].
  Stream<QuerySnapshot> getSelfReportList({@required String userId}) {
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
    try {
      CollectionReference ref = _firestore
          .collection(kSelfReports)
          .document(userId)
          .collection(kContactHistory);

      await ref.add(data.toJson()).then((doc) async {
        await doc.updateData({'id': doc.documentID});
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
