// To parse this JSON data, do
//
//     final broadcastModel = broadcastModelFromJson(jsonString);

import 'dart:convert';

List<MessageModel> listMessageFromJson(String str) =>
    List<MessageModel>.from(
        json.decode(str).map((x) => MessageModel.fromJson(x)));

MessageModel messageFromJson(String str) =>
    MessageModel.fromJson(json.decode(str));

class MessageModel {
  String id;
  String type;
  int messageId;
  int senderId;
  String senderName;
  int recipientId;
  String categoryName;
  String title;
  dynamic excerpt;
  String content;
  int status;
  dynamic meta;
  dynamic readAt;
  int createdAt;
  int updatedAt;

  MessageModel({
    this.id,
    this.type,
    this.messageId,
    this.senderId,
    this.senderName,
    this.recipientId,
    this.categoryName,
    this.title,
    this.excerpt,
    this.content,
    this.status,
    this.meta,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        type: json["type"],
        messageId: json["message_id"],
        senderId: json["sender_id"],
        senderName: json["sender_name"],
        recipientId: json["recipient_id"],
        categoryName: json["category_name"],
        title: json["title"],
        excerpt: json["excerpt"],
        content: json["content"],
        status: json["status"],
        meta: json["meta"],
        readAt: json["read_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "message_id": messageId,
        "sender_id": senderId,
        "sender_name": senderName,
        "recipient_id": recipientId,
        "category_name": categoryName,
        "title": title,
        "excerpt": excerpt,
        "content": content,
        "status": status,
        "meta": meta,
        "read_at": readAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
