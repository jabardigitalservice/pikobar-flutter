import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

class ImportantInfoRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<ImportantinfoModel>> getInfoImportantList({@required String improtantInfoCollection}) {
    return firestore.collection(improtantInfoCollection).orderBy('published_at', descending: true).snapshots().map(
            (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => ImportantinfoModel.fromFirestore(doc))
            .toList());
  }

  Future<ImportantinfoModel> getImportantInfoDetail({ @required String importantInfoid}) async {
    DocumentSnapshot doc = await firestore.collection(Collections.importantInfor).document(importantInfoid).get();
    return ImportantinfoModel.fromFirestore(doc);
  }
}