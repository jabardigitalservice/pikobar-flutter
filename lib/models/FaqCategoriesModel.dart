import 'package:cloud_firestore/cloud_firestore.dart';

class FaqCategoriesModel {
  final String id;
  final String title;
  final String analytics;
  final bool published;

  FaqCategoriesModel({
    this.id,
    this.title,
    this.analytics,
    this.published,
  });

  factory FaqCategoriesModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();

    return FaqCategoriesModel(
      id: document.id,
      title: json["title"] ?? '',
      analytics: json["analytics"] ?? '',
      published: json["published"] ?? false,
    );
  }
}
