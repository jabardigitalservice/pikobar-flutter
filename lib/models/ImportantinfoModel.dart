import 'package:cloud_firestore/cloud_firestore.dart';

class ImportantInfoModel {
  String id;
  String title;
  String content;
  String image;
  String actionUrl;
  String actionTitle;
  String attachmentUrl;
  String attachmentName;
  bool published;
  int publishedAt;

  ImportantInfoModel({
    this.id,
    this.title,
    this.content,
    this.image,
    this.actionUrl,
    this.actionTitle,
    this.attachmentUrl,
    this.attachmentName,
    this.published,
    this.publishedAt,
  });

  factory ImportantInfoModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data;

    return ImportantInfoModel(
      id: document.documentID,
      title: json["title"] ?? '',
      content: json["content"] ?? '',
      image: json["image"] ?? '',
      actionUrl: json["action_url"] ?? null,
      actionTitle: json["action_title"] ?? null,
      attachmentUrl: json["attachment_url"] ?? '',
      attachmentName: json["attachment_name"] ?? '',
      published: json["published"] ?? false,
      publishedAt:
          json["published_at"] != null ? json["published_at"].seconds : null,
    );
  }
}
