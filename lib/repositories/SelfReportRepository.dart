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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Reads the daily report document in the self reports collection referenced by the [DocumentReference].
  Future<DocumentSnapshot> getSelfReportDetail(
      {@required String userId,
      @required String dailyReportId,
      String otherUID}) async {
    DocumentSnapshot doc;
    if (otherUID == null) {
      doc = await _firestore
          .collection(kSelfReports)
          .doc(userId)
          .collection(kDailyReport)
          .doc(dailyReportId)
          .get();
    } else {
      doc = await _firestore
          .collection(kSelfReports)
          .doc(userId)
          .collection(kOtherSelfReports)
          .doc(otherUID)
          .collection(kDailyReport)
          .doc(dailyReportId)
          .get();
    }

    return doc;
  }

  Future<void> saveDailyReport(
      {@required String userId,
      @required DailyReportModel dailyReport,
      String otherUID}) async {
    try {
      dynamic doc;
      if (otherUID == null) {
        doc = _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kDailyReport)
            .doc(dailyReport.id);
      } else {
        doc = _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kOtherSelfReports)
            .doc(otherUID)
            .collection(kDailyReport)
            .doc(dailyReport.id);
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
      final DocumentReference doc = _firestore
          .collection(kSelfReports)
          .doc(userId)
          .collection(kOtherSelfReports)
          .doc(dailyReport.userId);

      await doc.get().then((snapshot) async {
        await doc.set(dailyReport.toJson());
      });
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

  /// Reads the self report document referenced by the [CollectionReference].
  Stream<QuerySnapshot> getSelfReportList(
      {@required String userId, String otherUID, String recurrenceReport}) {
    final DocumentReference selfReport =
        _firestore.collection(kSelfReports).doc(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.set({'remind_me': false, 'user_id': userId});
      }
    });
    return otherUID == null
        ? _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kDailyReport)
            .where('recurrence_report', isEqualTo: recurrenceReport)
            .orderBy('created_at')
            .snapshots()
        : _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kOtherSelfReports)
            .doc(otherUID)
            .collection(kDailyReport)
            .where('recurrence_report', isEqualTo: recurrenceReport)
            .orderBy('created_at')
            .snapshots();
  }

  Stream<QuerySnapshot> getContactHistoryList({@required String userId}) {
    final DocumentReference selfReport =
        _firestore.collection(kSelfReports).doc(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.set({'remind_me': false, 'user_id': userId});
      }
    });

    return _firestore
        .collection(kSelfReports)
        .doc(userId)
        .collection(kContactHistory)
        .snapshots();
  }

  Stream<QuerySnapshot> getOtherSelfReport({@required String userId}) {
    final DocumentReference selfReport =
        _firestore.collection(kSelfReports).doc(userId);
    selfReport.get().then((snapshot) {
      if (snapshot.exists) {
      } else {
        selfReport.set({'remind_me': false, 'user_id': userId});
      }
    });

    return _firestore
        .collection(kSelfReports)
        .doc(userId)
        .collection(kOtherSelfReports)
        .snapshots();
  }

  Future<DocumentSnapshot> getContactHistoryDetail(
      {@required String userId, @required String contactHistoryId}) async {
    final DocumentSnapshot doc = await _firestore
        .collection(kSelfReports)
        .doc(userId)
        .collection(kContactHistory)
        .doc(contactHistoryId)
        .get();
    return doc;
  }

  Stream<DocumentSnapshot> getIsReminder({@required String userId}) async* {
    final DocumentReference selfReport =
        _firestore.collection(kSelfReports).doc(userId);
    await selfReport.get().then((snapshot) async {
      if (!snapshot.exists) {
        await selfReport.set({'remind_me': false, 'user_id': userId});
      }
    });

    yield* selfReport.snapshots();
  }

  Future updateToCollection({@required String userId, bool isReminder}) async {
    return await _firestore.collection(kSelfReports).doc(userId).update({
      'remind_me': isReminder,
    });
  }

  Future updateRecurrenceReport(
      {@required String userId,
      String recurrenceReport,
      String otherUID}) async {
    return otherUID == null
        ? await _firestore.collection(kSelfReports).doc(userId).update({
            'recurrence_report':
                (int.parse(recurrenceReport ?? '0') + 1).toString(),
          })
        : await _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kOtherSelfReports)
            .doc(otherUID)
            .update({
            'recurrence_report':
                (int.parse(recurrenceReport ?? '0') + 1).toString(),
          });
  }

  Future updateHealthStatus({@required String userId, String otherUID}) async {
    return otherUID == null
        ? await _firestore
            .collection(kUsers)
            .doc(userId)
            .update({'health_status_changed': false})
        : _firestore
            .collection(kSelfReports)
            .doc(userId)
            .collection(kOtherSelfReports)
            .doc(otherUID)
            .update({
            'health_status_changed': false,
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
          .doc(userId)
          .collection(kContactHistory);

      await ref.add(data.toJson()).then((doc) async {
        await doc.update({'id': doc.id});
      });
    } else {
      throw SocketException(ErrorException.socketException);
    }
  }

  Future<bool> checkNIK({@required String nik}) async {
    bool result = false;

    try {
      DocumentSnapshot doc = await _firestore
          .collection(kUsersQuarantined)
          .doc(nik)
          .get();
      result = doc.exists;
    } on FirebaseException catch (e) {
      print(e);
    }

    return result;
  }
}
