import 'dart:convert';

List<MessageModel> listMessageFromJson(String str) => List<MessageModel>.from(
    json.decode(str).map((x) => MessageModel.fromJson(x)));

MessageModel messageFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

class MessageModel {
  String id;
  String backLink;
  String content;
  String title;
  String actionTitle;
  String actionUrl;
  int publishedAt;
  int readAt;

  MessageModel(
      {this.id,
      this.backLink,
      this.content,
      this.title,
      this.actionTitle,
      this.actionUrl,
      this.publishedAt,
      this.readAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        backLink: json["backlink"],
        content: json["content"],
        title: json["title"],
        actionTitle: json["action_title"],
        actionUrl: json["action_url"],
        publishedAt: json["published_at"],
        readAt: json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "backlink": backLink,
        "content": content,
        "title": title,
        "action_title": actionTitle,
        "action_url": actionUrl,
        "published_at": publishedAt,
        "read_at": readAt,
      };
}
