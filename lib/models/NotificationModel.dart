// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> listNotificationFromJson(String str) =>
    List<NotificationModel>.from(
        json.decode(str).map((x) => NotificationModel.fromJson(x)));

class NotificationModel {
  int id;
  String title;
  String target;
  int readAt;

  NotificationModel({
    this.id,
    this.title,
    this.target,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        target: json["target"],
        readAt: json["read_at"] == null ? null : json["read_at"],
      );

  factory NotificationModel.fromDatabaseJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        title: json["title"],
        target: json["target"],
        readAt: json["read_at"] == null ? null : json["read_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "target": target,
        "read_at": readAt == null ? null : readAt,
      };
}
