import 'dart:convert';

import 'package:pikobar_flutter/models/CategoryModel.dart';

List<VideoModel> listVideoFromJson(String str) =>
    List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String listVideoToJson(List<VideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

VideoModel videoFromJson(String str) => VideoModel.fromJson(json.decode(str));

class VideoModel {
  int id;
  String title;
  int categoryId;
  Category category;
  String source;
  String videoUrl;
  dynamic kabkotaId;
  dynamic kabkota;
  int totalLikes;
  int seq;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;
  int createdBy;

  VideoModel({
    this.id,
    this.title,
    this.categoryId,
    this.category,
    this.source,
    this.videoUrl,
    this.kabkotaId,
    this.kabkota,
    this.totalLikes,
    this.seq,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"],
        title: json["title"],
        categoryId: json["category_id"],
        category: Category.fromJson(json["category"]),
        source: json["source"],
        videoUrl: json["video_url"],
        kabkotaId: json["kabkota_id"],
        kabkota: json["kabkota"],
        totalLikes: json["total_likes"],
        seq: json["seq"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category_id": categoryId,
        "category": category.toJson(),
        "source": source,
        "video_url": videoUrl,
        "kabkota_id": kabkotaId,
        "kabkota": kabkota,
        "total_likes": totalLikes,
        "seq": seq,
        "status": status,
        "status_label": statusLabel,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "created_by": createdBy,
      };
}
