// To parse this JSON data, do
//
//     final broadcastModel = broadcastModelFromJson(jsonString);

import 'dart:convert';

import 'package:pikobar_flutter/models/AuthorModel.dart';
import 'package:pikobar_flutter/models/CategoryModel.dart';

List<BroadcastModel> listBroadcastFromJson(String str) =>
    List<BroadcastModel>.from(
        json.decode(str).map((x) => BroadcastModel.fromJson(x)));

BroadcastModel broadcastFromJson(String str) =>
    BroadcastModel.fromJson(json.decode(str));

class BroadcastModel {
  int id;
  int authorId;
  Author author;
  int categoryId;
  Category category;
  String title;
  String description;
  dynamic kabkotaId;
  dynamic kabkota;
  dynamic kecId;
  dynamic kecamatan;
  dynamic kelId;
  dynamic kelurahan;
  dynamic rw;
  String type;
  String linkUrl;
  dynamic internalObjectType;
  dynamic internalObjectId;
  dynamic internalObjectName;
  dynamic meta;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;

  BroadcastModel({
    this.id,
    this.authorId,
    this.author,
    this.categoryId,
    this.category,
    this.title,
    this.description,
    this.kabkotaId,
    this.kabkota,
    this.kecId,
    this.kecamatan,
    this.kelId,
    this.kelurahan,
    this.rw,
    this.type,
    this.linkUrl,
    this.internalObjectType,
    this.internalObjectId,
    this.internalObjectName,
    this.meta,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory BroadcastModel.fromJson(Map<String, dynamic> json) => BroadcastModel(
        id: json["id"],
        authorId: json["author_id"],
        author: Author.fromJson(json["author"]),
        categoryId: json["category_id"],
        category: Category.fromJson(json["category"]),
        title: json["title"],
        description: json["description"],
        kabkotaId: json["kabkota_id"],
        kabkota: json["kabkota"],
        kecId: json["kec_id"],
        kecamatan: json["kecamatan"],
        kelId: json["kel_id"],
        kelurahan: json["kelurahan"],
        rw: json["rw"],
        type: json["type"],
        linkUrl: json["link_url"],
        internalObjectType: json["internal_object_type"],
        internalObjectId: json["internal_object_id"],
        internalObjectName: json["internal_object_name"],
        meta: json["meta"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author_id": authorId,
        "author": author.toJson(),
        "category_id": categoryId,
        "category": category.toJson(),
        "title": title,
        "description": description,
        "kabkota_id": kabkotaId,
        "kabkota": kabkota,
        "kec_id": kecId,
        "kecamatan": kecamatan,
        "kel_id": kelId,
        "kelurahan": kelurahan,
        "rw": rw,
        "type": type,
        "link_url": linkUrl,
        "internal_object_type": internalObjectType,
        "internal_object_id": internalObjectId,
        "internal_object_name": internalObjectName,
        "meta": meta,
        "status": status,
        "status_label": statusLabel,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
