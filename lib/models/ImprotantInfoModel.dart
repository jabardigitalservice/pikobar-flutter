import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'CategoryModel.dart';

List<ImportantInfoModel> listImportantInfoModelFromJson(String str) => List<ImportantInfoModel>.from(json.decode(str).map((x) => ImportantInfoModel.fromJson(x)));

ImportantInfoModel importantInfoModelFromJson(String str) => ImportantInfoModel.fromJson(json.decode(str));

// ignore: must_be_immutable
class ImportantInfoModel extends Equatable {
  int id;
  String title;
  int categoryId;
  Category category;
  String content;
  String imagePath;
  String imagePathUrl;
  String sourceUrl;
  String publicSourceUrl;
  int totalViewers;
  int likesCount;
  bool isLiked;
  int status;
  List<Attachment> attachments;
  String statusLabel;
  int createdAt;
  int updatedAt;
  int createdBy;

  ImportantInfoModel({
    this.id,
    this.title,
    this.categoryId,
    this.category,
    this.content,
    this.imagePath,
    this.imagePathUrl,
    this.sourceUrl,
    this.publicSourceUrl,
    this.totalViewers,
    this.likesCount,
    this.isLiked,
    this.status,
    this.attachments,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory ImportantInfoModel.fromJson(Map<String, dynamic> json) => ImportantInfoModel(
    id: json["id"],
    title: json["title"],
    categoryId: json["category_id"],
    category: Category.fromJson(json["category"]),
    content: json["content"],
    imagePath: json["image_path"],
    imagePathUrl: json["image_path_url"],
    sourceUrl: json["source_url"],
    publicSourceUrl: json["public_source_url"],
    totalViewers: json["total_viewers"],
    likesCount: json["likes_count"],
    isLiked: json["is_liked"],
    status: json["status"],
    attachments: json["attachments"] == null ? null : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
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
    "content": content,
    "image_path": imagePath,
    "image_path_url": imagePathUrl,
    "source_url": sourceUrl,
    "public_source_url": publicSourceUrl,
    "total_viewers": totalViewers,
    "likes_count": likesCount,
    "is_liked": isLiked,
    "status": status,
    "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
    "status_label": statusLabel,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "created_by": createdBy,
  };

  @override
  List<Object> get props => [id];
}

class Attachment {
  int id;
  String name;
  String filePath;
  String fileUrl;

  Attachment({
    this.id,
    this.name,
    this.filePath,
    this.fileUrl,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json["id"],
    name: json["name"],
    filePath: json["file_path"],
    fileUrl: json["file_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "file_path": filePath,
    "file_url": fileUrl,
  };
}
