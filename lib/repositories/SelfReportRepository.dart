import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class SelfReportRepository {
  final Firestore _firestore = Firestore.instance;

  /// Reads the self report document referenced by the [DocumentReference].
  Future<DocumentSnapshot> getSelfReportDetail(
      {@required String userId, @required String selfReportId}) async {
    DocumentSnapshot doc = await _firestore
        .collection(Collections.users)
        .document(userId)
        .collection(Collections.selfReports)
        .document(selfReportId)
        .get();
    return doc;
  }
}
