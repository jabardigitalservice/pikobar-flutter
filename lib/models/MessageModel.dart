

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<MessageModel> listMessageFromJson(String str) =>
    List<MessageModel>.from(
        json.decode(str).map((x) => MessageModel.fromJson(x)));

MessageModel messageFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

class MessageModel {
  String backlink;
  String content;
  String title;
  int pubilshedAt;
  int readAt;

  MessageModel({
   this.backlink,
    this.content,
    this.title,
    this.pubilshedAt,
    this.readAt
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    backlink: json["backlink"],
    content: json["content"],
    title: json["title"],
    pubilshedAt: json["published_at"],
    readAt: json["read_at"],

      );

  Map<String, dynamic> toJson() => {
        "backlink": backlink,
        "content": content,
        "title": title,
        "published_at": pubilshedAt,
        "read_at": readAt,
      };
}
