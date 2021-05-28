import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class AreaRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<dynamic>> getCityList() {
    return firestore.collection(kAreas).orderBy('name').snapshots().map(
        (QuerySnapshot snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<dynamic>> getSubCityList() {
    return firestore.collection(kSubAreas).orderBy('name').snapshots().map(
        (QuerySnapshot snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

}
