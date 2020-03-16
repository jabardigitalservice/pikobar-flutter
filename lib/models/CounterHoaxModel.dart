// To parse this JSON data, do
//
//     final counterHoaxModel = counterHoaxModelFromJson(jsonString);

import 'dart:convert';

import 'package:pikobar_flutter/models/CategoryModel.dart';

List<CounterHoaxModel> listCounterHoaxFromJson(String str) =>
    List<CounterHoaxModel>.from(
        json.decode(str).map((x) => CounterHoaxModel.fromJson(x)));

CounterHoaxModel counterHoaxFromJson(String str) =>
    CounterHoaxModel.fromJson(json.decode(str));

class CounterHoaxModel {
  int id;
  String title;
  String content;
  String coverPath;
  String coverPathUrl;
  DateTime sourceDate;
  String sourceUrl;
  int categoryId;
  Category category;
  dynamic meta;
  dynamic seq;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;

  CounterHoaxModel({
    this.id,
    this.title,
    this.content,
    this.coverPath,
    this.coverPathUrl,
    this.sourceDate,
    this.sourceUrl,
    this.categoryId,
    this.category,
    this.meta,
    this.seq,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory CounterHoaxModel.fromJson(Map<String, dynamic> json) =>
      CounterHoaxModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        coverPath: json["cover_path"],
        coverPathUrl: json["cover_path_url"],
        sourceDate: DateTime.parse(json["source_date"]),
        sourceUrl: json["source_url"],
        categoryId: json["category_id"],
        category: Category.fromJson(json["category"]),
        meta: json["meta"],
        seq: json["seq"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "cover_path": coverPath,
        "cover_path_url": coverPathUrl,
        "source_date":
            "${sourceDate.year.toString().padLeft(4, '0')}-${sourceDate.month.toString().padLeft(2, '0')}-${sourceDate.day.toString().padLeft(2, '0')}",
        "source_url": sourceUrl,
        "category_id": categoryId,
        "category": category.toJson(),
        "meta": meta,
        "seq": seq,
        "status": status,
        "status_label": statusLabel,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
