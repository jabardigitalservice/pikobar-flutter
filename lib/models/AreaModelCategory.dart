import 'dart:convert';

AreaModelCategory areaModelCategoryFromJson(String str) => AreaModelCategory.fromJson(json.decode(str));

String areaModelCategoryToJson(AreaModelCategory data) => json.encode(data.toJson());

class AreaModelCategory {
  bool success;
  int status;
  Data data;

  AreaModelCategory({
    this.success,
    this.status,
    this.data,
  });

  factory AreaModelCategory.fromJson(Map<String, dynamic> json) => AreaModelCategory(
    success: json["success"],
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<Item> items;

  Data({
    this.items,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  int id;
  int parentId;
  int depth;
  String name;
  String codeBps;
  String codeKemendagri;
  String latitude;
  String longitude;
  dynamic meta;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;

  Item({
    this.id,
    this.parentId,
    this.depth,
    this.name,
    this.codeBps,
    this.codeKemendagri,
    this.latitude,
    this.longitude,
    this.meta,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    parentId: json["parent_id"],
    depth: json["depth"],
    name: json["name"],
    codeBps: json["code_bps"],
    codeKemendagri: json["code_kemendagri"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    meta: json["meta"],
    status: json["status"],
    statusLabel: json["status_label"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId,
    "depth": depth,
    "name": name,
    "code_bps": codeBps,
    "code_kemendagri": codeKemendagri,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "meta": meta,
    "status": status,
    "status_label": statusLabel,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
