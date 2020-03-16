import 'dart:convert';

List<MasterCategoryModel> listMasterCategoryFromJson(String str) => List<MasterCategoryModel>.from(json.decode(str).map((x) => MasterCategoryModel.fromJson(x)));

MasterCategoryModel masterCategoryFromJson(String str) =>
    MasterCategoryModel.fromJson(json.decode(str));


class MasterCategoryModel {
  int id;
  Type type;
  String name;
  dynamic meta;
  int status;
  StatusLabel statusLabel;
  int createdAt;
  int updatedAt;

  MasterCategoryModel({
    this.id,
    this.type,
    this.name,
    this.meta,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory MasterCategoryModel.fromJson(Map<String, dynamic> json) => MasterCategoryModel(
    id: json["id"],
    type: typeValues.map[json["type"]],
    name: json["name"],
    meta: json["meta"],
    status: json["status"],
    statusLabel: statusLabelValues.map[json["status_label"]],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": typeValues.reverse[type],
    "name": name,
    "meta": meta,
    "status": status,
    "status_label": statusLabelValues.reverse[statusLabel],
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

enum StatusLabel { AKTIF }

final statusLabelValues = EnumValues({
  "Aktif": StatusLabel.AKTIF
});

enum Type { ASPIRASI }

final typeValues = EnumValues({
  "aspirasi": Type.ASPIRASI
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
