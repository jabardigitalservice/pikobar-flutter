import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class StatisticsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> getStatistics() {
    return firestore
        .collection(kStatistics)
        .doc('jabar-dan-nasional')
        .snapshots();
  }

  Stream<DocumentSnapshot> getRapidTest() {
    return firestore.collection(kStatistics).doc('rdt').snapshots();
  }

  Stream<DocumentSnapshot> getPCRTest() {
    return firestore.collection(kStatistics).doc('pcr').snapshots();
  }

  Stream<DocumentSnapshot> getRapidTestAntigen() {
    return firestore.collection(kStatistics).doc('rdt-antigen').snapshots();
  }

  Stream<DocumentSnapshot> getPcrTestIndividu() {
    return firestore
        .collection(kStatistics)
        .doc('pcr-orang-kasus-baru')
        .snapshots();
  }
}
