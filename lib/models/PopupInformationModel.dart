// To parse this JSON data, do
//
//     final popupInformationModel = popupInformationModelFromJson(jsonString);

import 'dart:convert';

List<PopupInformationModel> listPopupInformationFromJson(String str) => List<PopupInformationModel>.from(json.decode(str).map((x) => PopupInformationModel.fromJson(x)));

PopupInformationModel popupInformationFromJson(String str) => PopupInformationModel.fromJson(json.decode(str));


class PopupInformationModel {
  int id;
  String title;
  String description;
  String imagePath;
  String imagePathUrl;
  String type;
  String linkUrl;
  String internalObjectType;
  int internalObjectId;
  String internalObjectName;
  int status;
  String statusLabel;
  DateTime startDate;
  DateTime endDate;
  int createdAt;
  int updatedAt;
  int createdBy;

  PopupInformationModel({
    this.id,
    this.title,
    this.description,
    this.imagePath,
    this.imagePathUrl,
    this.type,
    this.linkUrl,
    this.internalObjectType,
    this.internalObjectId,
    this.internalObjectName,
    this.status,
    this.statusLabel,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory PopupInformationModel.fromJson(Map<String, dynamic> json) => PopupInformationModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    imagePath: json["image_path"],
    imagePathUrl: json["image_path_url"],
    type: json["type"],
    linkUrl: json["link_url"],
    internalObjectType: json["internal_object_type"],
    internalObjectId: json["internal_object_id"],
    internalObjectName: json["internal_object_name"],
    status: json["status"],
    statusLabel: json["status_label"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image_path": imagePath,
    "image_path_url": imagePathUrl,
    "type": type,
    "link_url": linkUrl,
    "internal_object_type": internalObjectType,
    "internal_object_id": internalObjectId,
    "internal_object_name": internalObjectName,
    "status": status,
    "status_label": statusLabel,
    "start_date": startDate.toIso8601String(),
    "end_date": endDate.toIso8601String(),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "created_by": createdBy,
  };
}
