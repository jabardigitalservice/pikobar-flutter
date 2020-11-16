import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


class InfoGraphicsRepository {
  final firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> getInfoGraphics(
      {@required String infoGraphicsCollection, int limit}) {
    Query infoGraphicsQuery = firestore
        .collection(infoGraphicsCollection)
        .orderBy('published_date', descending: true);

    if (limit != null) {
      infoGraphicsQuery = infoGraphicsQuery.limit(limit);
    }

    return infoGraphicsQuery.snapshots().map((QuerySnapshot snapshot) =>
        snapshot.docs.map((doc) => doc).toList());
  }
}
