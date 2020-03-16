
import 'dart:convert';

Meta metaNotificationFromJson(String str) => Meta.fromJson(json.decode(str));

class Meta {
  String target;
  int id;
  String url;

  Meta({
    this.target,
    this.id,
    this.url,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    target: json["target"],
    id: json["id"] == null ? null : json["id"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "target": target,
    "id": id == null ? null : id,
    "url": url == null ? null : url,
  };
}