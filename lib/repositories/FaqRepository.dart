import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/FaqCategoriesModel.dart';

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
    final Query faqQuery = firestore
        .collection(faqCollection)
        .where("category", isEqualTo: category);

    return faqQuery.snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs.map((doc) => doc).toList());
  }

  Future<List<FaqCategoriesModel>> getFaqCategories() async {
    categories = await firestore.collection(kFaqCategories).get();
    final covid = await firestore
        .collection(kFaqCategories)
        .where('id', whereIn: ['covid', 'vaksin']).get();

    // covid.docs.forEach((doc) async {
    //   print("Parent Document ID: " + doc.id);
    //   final subCollectionDocs = await firestore
    //       .collection(kFaqCategories)
    //       .doc(doc.id)
    //       .collection('faq_sub_category')
    //       .get();
    //   subCollectionDocs.docs.forEach((subCollectionDoc) {
    //     print("Sub Document ID: " + subCollectionDoc.id);
    //   });
    // });

    return covid.docs
        .map((doc) => FaqCategoriesModel.fromFirestore(doc))
        .toList();
  }
}
