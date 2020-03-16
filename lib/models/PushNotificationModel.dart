import 'dart:convert';

import 'package:pikobar_flutter/models/MetaNotificationModel.dart';

List<PushNotificationModel> listPushNotificationFromJson(String str) =>
    List<PushNotificationModel>.from(
        json.decode(str).map((x) => PushNotificationModel.fromJson(x)));

PushNotificationModel pushNotificationFromJson(String str) =>
    PushNotificationModel.fromJson(json.decode(str));

class PushNotificationModel {
  bool pushNotification;
  String title;
  String target;
  Meta meta;

  PushNotificationModel({
    this.pushNotification,
    this.title,
    this.target,
    this.meta,
  });

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationModel(
        pushNotification: json["push_notification"],
        title: json["title"],
        target: json["target"],
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "push_notification": pushNotification,
        "title": title,
        "target": target,
        "meta": meta.toJson(),
      };
}
