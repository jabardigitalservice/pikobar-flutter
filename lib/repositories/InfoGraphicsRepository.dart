import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:meta/meta.dart';
import 'package:async/async.dart';

class InfoGraphicsRepository {
  final firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> getInfoGraphics(
      {required String infoGraphicsCollection, int? limit}) {
    Query infoGraphicsQuery = firestore
        .collection(infoGraphicsCollection)
        .orderBy('published_date', descending: true);

    if (limit != null) {
      infoGraphicsQuery = infoGraphicsQuery.limit(limit);
    }

    return infoGraphicsQuery.snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs.map((doc) => doc).toList());
  }

  Future<DocumentSnapshot> getInfoGraphicDetail(
      {required String infoGraphicCollection,
      required String infoGraphicId}) async {
    final DocumentSnapshot doc = await firestore
        .collection(infoGraphicCollection)
        .doc(infoGraphicId)
        .get();
    return doc;
  }

  Stream<List<Iterable<DocumentSnapshot>>> getAllInfographicList() {
    final infographicCollection = firestore
        .collection(kInfographics)
        .orderBy('published_date', descending: true)
        .snapshots();
    final infographicCenterCollection = firestore
        .collection(kInfographicsCenter)
        .orderBy('published_date', descending: true)
        .snapshots();
    final infographicWhoCollection = firestore
        .collection(kInfographicsWho)
        .orderBy('published_date', descending: true)
        .snapshots();

    final allData = StreamZip([
      infographicCollection,
      infographicCenterCollection,
      infographicWhoCollection
    ]).asBroadcastStream();

    return allData.map((snapshot) =>
        snapshot.map((docList) => docList.docs.map((doc) => doc)).toList());
  }
}
