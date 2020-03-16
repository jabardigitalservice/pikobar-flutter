import 'dart:convert';

import 'CategoryModel.dart';

List<UsulanModel> usulanModelFromJson(String str) => List<UsulanModel>.from(json.decode(str).map((x) => UsulanModel.fromJson(x)));

UsulanModel usulanDetailModelFromJson(String str) => UsulanModel.fromJson(json.decode(str));

Attachment attachmentFromJson(String str) => Attachment.fromJson(json.decode(str));

class UsulanModel {
  int id;
  int authorId;
  Author author;
  int categoryId;
  Category category;
  String title;
  String description;
  int kabkotaId;
  Category kabkota;
  int kecId;
  Category kecamatan;
  int kelId;
  Category kelurahan;
  int likesCount;
  List<Category> likesUsers;
  dynamic rw;
  dynamic meta;
  int status;
  String statusLabel;
  String approvalNote;
  List<Attachment> attachments;
  int createdAt;
  int updatedAt;
  int approvedAt;
  int submittedAt;
  dynamic lastRevisedAt;

  UsulanModel({
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
    this.likesCount,
    this.likesUsers,
    this.rw,
    this.meta,
    this.status,
    this.statusLabel,
    this.approvalNote,
    this.attachments,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.submittedAt,
    this.lastRevisedAt,
  });

  factory UsulanModel.fromJson(Map<String, dynamic> json) => UsulanModel(
    id: json["id"],
    authorId: json["author_id"],
    author: Author.fromJson(json["author"]),
    categoryId: json["category_id"],
    category: Category.fromJson(json["category"]),
    title: json["title"],
    description: json["description"],
    kabkotaId: json["kabkota_id"],
    kabkota: Category.fromJson(json["kabkota"]),
    kecId: json["kec_id"],
    kecamatan: Category.fromJson(json["kecamatan"]),
    kelId: json["kel_id"],
    kelurahan: Category.fromJson(json["kelurahan"]),
    likesCount: json["likes_count"],
    likesUsers: List<Category>.from(json["likes_users"].map((x) => Category.fromJson(x))),
    rw: json["rw"],
    meta: json["meta"],
    status: json["status"],
    statusLabel: json["status_label"],
    approvalNote: json["approval_note"] == null ? null : json["approval_note"],
    attachments: json["attachments"] == null ? null : List<Attachment>.from(json["attachments"].map((x) => Attachment.fromJson(x))),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    approvedAt: json["approved_at"] == null ? null : json["approved_at"],
    submittedAt: json["submitted_at"] == null ? null : json["submitted_at"],
    lastRevisedAt: json["last_revised_at"],
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
    "kabkota": kabkota.toJson(),
    "kec_id": kecId,
    "kecamatan": kecamatan.toJson(),
    "kel_id": kelId,
    "kelurahan": kelurahan.toJson(),
    "likes_count": likesCount,
    "likes_users": List<dynamic>.from(likesUsers.map((x) => x.toJson())),
    "rw": rw,
    "meta": meta,
    "status": status,
    "status_label": statusLabelValues.reverse[statusLabel],
    "approval_note": approvalNote == null ? null : approvalNote,
    "attachments": attachments == null ? null : List<dynamic>.from(attachments.map((x) => x.toJson())),
    "created_at": createdAt,
    "updated_at": updatedAt,
    "approved_at": approvedAt == null ? null : approvedAt,
    "submitted_at": submittedAt == null ? null : submittedAt,
    "last_revised_at": lastRevisedAt,
  };
}

class Attachment {
  String type;
  String path;
  String url;

  Attachment({
    this.type,
    this.path,
    this.url,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    type: json["type"],
    path: json["path"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "path": path,
    "url": url,
  };
}

class Author {
  int id;
  String name;
  String photoUrl;
  String photoUrlFull;
  RoleLabel roleLabel;
  String email;
  String phone;
  String address;

  Author({
    this.id,
    this.name,
    this.photoUrl,
    this.photoUrlFull,
    this.roleLabel,
    this.email,
    this.phone,
    this.address,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["id"],
    name: json["name"],
    photoUrl: json["photo_url"] == null ? null : json["photo_url"],
    photoUrlFull: json["photo_url_full"] == null ? null : json["photo_url_full"],
    roleLabel: roleLabelValues.map[json["role_label"]],
    email: json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    address: json["address"] == null ? null : json["address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo_url": photoUrl == null ? null : photoUrl,
    "photo_url_full": photoUrlFull == null ? null : photoUrlFull,
    "role_label": roleLabelValues.reverse[roleLabel],
    "email": email,
    "phone": phone == null ? null : phone,
    "address": address == null ? null : address,
  };
}

enum RoleLabel { RW, PENGGUNA }

final roleLabelValues = EnumValues({
  "Pengguna": RoleLabel.PENGGUNA,
  "RW": RoleLabel.RW
});

enum StatusLabel { DIPUBLIKASIKAN }

final statusLabelValues = EnumValues({
  "Dipublikasikan": StatusLabel.DIPUBLIKASIKAN
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) =>  MapEntry(v, k));
    }
    return reverseMap;
  }
}
