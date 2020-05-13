import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  String id;
  String title;
  String content;
  String image;
  String backlink;
  String newsChannel;
  String newsChannelIcon;
  int publishedAt;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.backlink,
    this.newsChannel,
    this.newsChannelIcon,
    this.publishedAt,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data;

    return NewsModel(
      id: document.documentID,
      title: json["title"] ?? '',
      content: json["content"] ?? '',
      image: json["image"] ?? '',
      backlink: json["backlink"] ?? '',
      newsChannel: json["news_channel"] ?? '',
      newsChannelIcon: json["news_channel_icon"] ?? '',
      publishedAt: json["published_at"] != null
          ? json["published_at"].seconds
          : null,
    );
  }
}
