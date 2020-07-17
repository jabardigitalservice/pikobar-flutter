import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class StatisticsRepository {
  final Firestore firestore = Firestore.instance;

  Stream<DocumentSnapshot> getStatistics() {
    return firestore
        .collection(kStatistics)
        .document('jabar-dan-nasional')
        .snapshots();
  }

  Stream<DocumentSnapshot> getRapidTest() {
    return firestore.collection(kStatistics).document('rdt').snapshots();
  }

  Stream<DocumentSnapshot> getPCRTest() {
    return firestore.collection(kStatistics).document('pcr').snapshots();
  }
}
