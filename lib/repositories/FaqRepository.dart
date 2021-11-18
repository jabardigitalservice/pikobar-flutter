import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class FaqRepository {
  static final FaqRepository _instance = FaqRepository._internal();

  factory FaqRepository() {
    return _instance;
  }

  FaqRepository._internal() {
    firestore = FirebaseFirestore.instance;
  }

  FirebaseFirestore firestore;

  QuerySnapshot categories;

  Stream<List<DocumentSnapshot>> getFaq(
      {@required String faqCollection, String category}) {
    final subCategoryIds = categories.docs
        .where((element) => element.get('category') == category)
        .map((e) => e.id)
        .toList();

    final Query faqQuery = firestore
        .collection(faqCollection)
        .where("category_id", whereIn: subCategoryIds);

    return faqQuery.snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs.map((doc) => doc).toList());
  }

  Future<List<String>> getFaqCategories() async {
    categories = await firestore.collection(kFaqCategories).get();
    final uniqCategories =
        categories.docs.map((e) => e.get('category')).toSet().toList();
    await Future.delayed(Duration(milliseconds: 300));

    return List<String>.from(uniqCategories);
  }
}
