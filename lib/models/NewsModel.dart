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
  String actionUrl;
  String actionTitle;
  String attachmentUrl;
  String attachmentName;
  bool published;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.backlink,
    this.newsChannel,
    this.newsChannelIcon,
    this.publishedAt,
    this.actionUrl,
    this.actionTitle,
    this.attachmentUrl,
    this.attachmentName,
    this.published,
  });

  factory NewsModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();

    return NewsModel(
      id: document.id,
      title: json["title"] ?? '',
      content: json["content"] ?? '',
      image: json["image"] ?? '',
      backlink: json["backlink"] ?? '',
      newsChannel: json["news_channel"] ?? '',
      newsChannelIcon: json["news_channel_icon"] ?? '',
      publishedAt:
          json["published_at"] != null ? json["published_at"].seconds : null,
      actionUrl: json["action_url"] ?? null,
      actionTitle: json["action_title"] ?? null,
      attachmentUrl: json["attachment_url"] ?? '',
      attachmentName: json["attachment_name"] ?? '',
      published: json["published"] ?? false,
    );
  }
}
