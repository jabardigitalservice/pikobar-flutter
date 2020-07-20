import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:async/async.dart';

class EducationRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<EducationModel>> getEducationList(
      {@required String educationCollection}) {
    return firestore
        .collection(educationCollection)
        .orderBy('published_at', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => EducationModel.fromFirestore(doc))
            .toList());
  }

  Future<EducationModel> getEducationDetail(
      {@required String educationCollection,
      @required String educationId}) async {
    DocumentSnapshot doc = await firestore
        .collection(educationCollection)
        .document(educationId)
        .get();
    return EducationModel.fromFirestore(doc);
  }
}
