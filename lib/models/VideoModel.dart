// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VideoModel extends Equatable {
  final String id;
  final int sequence;
  final String title;
  final String url;
  final int publishedAt;

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

  @override
  List<Object> get props => [id];
}
