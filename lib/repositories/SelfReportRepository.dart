import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';

class SelfReportRepository {
  final Firestore _firestore = Firestore.instance;

  /// Reads the daily report document in the self reports collection referenced by the [DocumentReference].
  Future<DocumentSnapshot> getSelfReportDetail(
      {@required String userId, @required String dailyReportId}) async {
    DocumentSnapshot doc = await _firestore
        .collection(Collections.selfReports)
        .document(userId)
        .collection(Collections.dailyReport)
        .document(dailyReportId)
        .get();
    return doc;
  }

  ///
  Future<void> saveDailyReport(
      {@required String userId, @required DailyReportModel dailyReport}) async {
    try {
      DocumentReference doc = _firestore
          .collection(Collections.selfReports)
          .document(userId)
          .collection(Collections.dailyReport)
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
}
