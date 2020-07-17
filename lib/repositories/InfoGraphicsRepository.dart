import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class InfoGraphicsRepository {
  final infoGraphicsCollection = Firestore.instance.collection(kInfographics);

  Stream<List<DocumentSnapshot>> getInfoGraphics({int limit}) {
    Query infoGraphicsQuery =
        infoGraphicsCollection.orderBy('published_date', descending: true);

    if (limit != null) {
      infoGraphicsQuery = infoGraphicsQuery.limit(limit);
    }

    return infoGraphicsQuery.snapshots().map((QuerySnapshot snapshot) =>
        snapshot.documents.map((doc) => doc).toList());
  }
}
