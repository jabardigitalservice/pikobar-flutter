// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String id;
  int sequence;
  String title;
  String url;

  VideoModel({
    this.id,
    this.sequence,
    this.title,
    this.url,
  });

  factory VideoModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return VideoModel(
      id: doc.documentID,
      title: data['title'] ?? '',
      url: data['url'] ?? '',
    );
  }
}
