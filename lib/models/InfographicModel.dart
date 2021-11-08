import 'package:cloud_firestore/cloud_firestore.dart';

class InfographicModel {
  String id;
  int publishedDate;
  String title;
  // List<dynamic> images;

  InfographicModel({
    this.id,
    this.title,
    this.publishedDate,
    /*this.images*/
  });

  factory InfographicModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();

    return InfographicModel(
      id: document.id,
      title: json["title"] ?? '',
      publishedDate: json["published_date"]?.seconds,
      // images: json["images"],
    );
  }
}
