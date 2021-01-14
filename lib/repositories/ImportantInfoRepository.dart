import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

class ImportantInfoRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<NewsModel>> getInfoImportantList(
      {@required String improtantInfoCollection}) {
    return firestore
        .collection(improtantInfoCollection)
        .orderBy('published_at', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.docs
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList());
  }

  Future<ImportantInfoModel> getImportantInfoDetail(
      {@required String importantInfoid}) async {
    DocumentSnapshot doc = await firestore
        .collection(kImportantInfor)
        .doc(importantInfoid)
        .get();
    return ImportantInfoModel.fromFirestore(doc);
  }
}
