// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

List<BannerModel> listBannerFromJson(String str) => List<BannerModel>.from(
    json.decode(str).map((x) => BannerModel.fromJson(x)));

BannerModel bannerFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

class BannerModel {
  int id;
  String title;
  String imagePath;
  String imagePathUrl;
  String type;
  String linkUrl;
  String internalCategory;
  int internalEntityId;
  String internalEntityName;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;
  int createdBy;

  BannerModel({
    this.id,
    this.title,
    this.imagePath,
    this.imagePathUrl,
    this.type,
    this.linkUrl,
    this.internalCategory,
    this.internalEntityId,
    this.internalEntityName,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        title: json["title"],
        imagePath: json["image_path"],
        imagePathUrl: json["image_path_url"],
        type: json["type"],
        linkUrl: json["link_url"],
        internalCategory: json["internal_category"] == null
            ? null
            : json["internal_category"],
        internalEntityId: json["internal_entity_id"] == null
            ? null
            : json["internal_entity_id"],
        internalEntityName: json["internal_entity_name"],
        status: json["status"],
        statusLabel: json["status_label"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image_path": imagePath,
        "image_path_url": imagePathUrl,
        "type": type,
        "link_url": linkUrl,
        "internal_category": internalCategory == null ? null : internalCategory,
        "internal_entity_id":
            internalEntityId == null ? null : internalEntityId,
        "internal_entity_name": internalEntityName,
        "status": status,
        "status_label": statusLabel,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "created_by": createdBy,
      };
}
