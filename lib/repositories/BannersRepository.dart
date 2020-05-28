import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

class BannersRepository {
  final _bannersCollection = Firestore.instance.collection(Collections.banners);

  Stream<List<BannerModel>> getBanners() {
    return _bannersCollection.orderBy('sequence')
        .snapshots().map(
            (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => BannerModel.fromJson(doc.data))
            .toList());
  }
}