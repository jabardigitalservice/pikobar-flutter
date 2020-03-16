
import 'dart:convert';
NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

Channel channelFromJson(String str) => Channel.fromJson(json.decode(str));

Meta metaFromJson(String str) => Meta.fromJson(json.decode(str));

class NewsModel {
  int id;
  String title;
  String content;
  int featured;
  String coverPath;
  String coverPathUrl;
  DateTime sourceDate;
  String sourceUrl;
  int channelId;
  Channel channel;
  dynamic kabkotaId;
  dynamic kabkota;
  int totalViewers;
  int likesCount;
  bool isLiked;
  Meta meta;
  int seq;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;

  NewsModel({
    this.id,
    this.title,
    this.content,
    this.featured,
    this.coverPath,
    this.coverPathUrl,
    this.sourceDate,
    this.sourceUrl,
    this.channelId,
    this.channel,
    this.kabkotaId,
    this.kabkota,
    this.totalViewers,
    this.likesCount,
    this.isLiked,
    this.meta,
    this.seq,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        featured: json["featured"],
        coverPath: json["cover_path"],
        coverPathUrl: json["cover_path_url"],
        sourceDate: DateTime.parse(json["source_date"]),
        sourceUrl: json["source_url"],
        channelId: json["channel_id"],
        channel: Channel.fromJson(json["channel"]),
        kabkotaId: json["kabkota_id"],
        kabkota: json["kabkota"],
        totalViewers: json["total_viewers"],
        likesCount: json["likes_count"],
        isLiked: json["is_liked"],
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        seq: json["seq"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class Channel {
  int id;
  String name;
  String website;
  String iconUrl;
  dynamic meta;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;

  Channel({
    this.id,
    this.name,
    this.website,
    this.iconUrl,
    this.meta,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory Channel.fromJson(Map<String, dynamic> json) => Channel(
        id: json["id"],
        name: json["name"],
        website: json["website"],
        iconUrl: json["icon_url"],
        meta: json["meta"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class Meta {
  int readCount;

  Meta({
    this.readCount,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        readCount: json["read_count"],
      );
}
