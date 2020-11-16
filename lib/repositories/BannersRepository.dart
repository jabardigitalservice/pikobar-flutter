import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/BannerModel.dart';

class BannersRepository {
  final _bannersCollection = FirebaseFirestore.instance.collection(kBanners);

  Stream<List<BannerModel>> getBanners() {
    return _bannersCollection.orderBy('sequence').snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs
            .map((doc) => BannerModel.fromJson(doc.data()))
            .toList());
  }
}
