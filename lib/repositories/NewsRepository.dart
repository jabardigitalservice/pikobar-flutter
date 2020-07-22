import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:async/async.dart';

class NewsRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<NewsModel>> getNewsList({@required String newsCollection}) {
    return firestore
        .collection(newsCollection)
        .orderBy('published_at', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList());
  }

  Future<NewsModel> getNewsDetail(
      {@required String newsCollection, @required String newsId}) async {
    DocumentSnapshot doc =
        await firestore.collection(newsCollection).document(newsId).get();
    return NewsModel.fromFirestore(doc);
  }

  Stream<List<NewsModel>> getInfoImportantList(
      {@required String improtantInfoCollection}) {
    return firestore
        .collection(improtantInfoCollection)
        .orderBy('published_at', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList());
  }

  Future<NewsModel> getImportantInfoDetail(
      {@required String importantInfoid}) async {
    DocumentSnapshot doc = await firestore
        .collection(kImportantInfor)
        .document(importantInfoid)
        .get();
    return NewsModel.fromFirestore(doc);
  }

  Stream<List<Iterable<NewsModel>>> getAllNewsList(bool statImportantInfo) {
    var importantCollection = firestore
        .collection(kImportantInfor)
        .orderBy('published_at', descending: true)
        .snapshots();
    var newsJabarCollection = firestore
        .collection(kNewsJabar)
        .orderBy('published_at', descending: true)
        .snapshots();
    var newsNationalCollection = firestore
        .collection(kNewsNational)
        .orderBy('published_at', descending: true)
        .snapshots();
    var newsWorldCollection = firestore
        .collection(kNewsWorld)
        .orderBy('published_at', descending: true)
        .snapshots();

    var allData = StreamZip([
      if (statImportantInfo) importantCollection,
      newsJabarCollection,
      newsNationalCollection,
      newsWorldCollection
    ]).asBroadcastStream();

    return allData.map((snapshot) => snapshot
        .map((docList) =>
            docList.documents.map((doc) => NewsModel.fromFirestore(doc)))
        .toList());
  }
}
