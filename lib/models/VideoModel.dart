// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String id;
  int sequence;
  String title;
  String url;
  int publishedAt;

  VideoModel({this.id, this.sequence, this.title, this.url, this.publishedAt});

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return VideoModel(
      id: doc.id,
      title: data['title'] ?? '',
      url: data['url'] ?? '',
      publishedAt:
          data["published_at"] != null ? data["published_at"].seconds : null,
    );
  }
}
