import 'package:cloud_firestore/cloud_firestore.dart';

class EducationModel {
  String id;
  String content;
  String image;
  String title;
  String sourceChannel;
  int publishedAt;

  EducationModel(
      {this.id,
      this.content,
      this.title,
      this.image,
      this.publishedAt,
      this.sourceChannel});

  factory EducationModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();

    return EducationModel(
      id: document.id,
      content: json["content"] ?? '',
      image: json["image"] ?? '',
      sourceChannel: json["source_channel"] ?? '',
      title: json["title"] ?? '',
      publishedAt: json["published_at"]?.seconds,
    );
  }
}
