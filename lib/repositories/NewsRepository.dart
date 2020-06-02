import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

class NewsRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<NewsModel>> getNewsList({@required String newsCollection}) {
    return firestore.collection(newsCollection).orderBy('published_at', descending: true).snapshots().map(
            (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList());
  }

  Future<NewsModel> getNewsDetail({@required String newsCollection, @required String newsId}) async {
    DocumentSnapshot doc = await firestore.collection(newsCollection).document(newsId).get();
    return NewsModel.fromFirestore(doc);
  }

  Stream<List<NewsModel>> getInfoImportantList({@required String improtantInfoCollection}) {
    return firestore.collection(improtantInfoCollection).orderBy('published_at', descending: true).snapshots().map(
            (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => NewsModel.fromFirestore(doc))
            .toList());
  }

  Future<NewsModel> getImportantInfoDetail({ @required String importantInfoid}) async {
    DocumentSnapshot doc = await firestore.collection(Collections.importantInfor).document(importantInfoid).get();
    return NewsModel.fromFirestore(doc);
  }
}