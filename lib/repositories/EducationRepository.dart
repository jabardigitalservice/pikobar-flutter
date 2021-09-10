import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';

class EducationRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<EducationModel>> getEducationList(
      {@required String educationCollection, int limit = 100}) {
    return firestore
        .collection(educationCollection)
        .limit(limit)
        .orderBy('published_at', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((doc) => EducationModel.fromFirestore(doc))
            .toList());
  }

  Future<EducationModel> getEducationDetail(
      {@required String educationCollection,
      @required String educationId}) async {
    DocumentSnapshot doc =
        await firestore.collection(educationCollection).doc(educationId).get();
    return EducationModel.fromFirestore(doc);
  }
}
