import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class StatisticsRepository {
  final Firestore firestore = Firestore.instance;

  Stream<DocumentSnapshot> getStatistics() {
    return firestore.collection(Collections.statistics)
        .document('jabar-dan-nasional').snapshots();
  }

  Stream<DocumentSnapshot> getRapidTest() {
    return firestore.collection(Collections.statistics)
        .document('rdt').snapshots();
  }

  Stream<DocumentSnapshot> getPCRTest() {
    return firestore.collection(Collections.statistics)
        .document('pcr').snapshots();
  }
}
