import 'package:cloud_firestore/cloud_firestore.dart';

class EducationModel {
  String id;
  String content;
  String image;
  String sourceChannel;
  int publishedAt;

  EducationModel(
      {this.id,
      this.content,
      this.image,
      this.publishedAt,
      this.sourceChannel});

  factory EducationModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data;

    return EducationModel(
      id: document.documentID,
      content: json["content"] ?? '',
      image: json["image"] ?? '',
      sourceChannel: json["source_channel"] ?? '',
      publishedAt:
          json["published_at"] != null ? json["published_at"].seconds : null,
    );
  }
}
