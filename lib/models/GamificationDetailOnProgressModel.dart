import 'dart:convert';

GamificationDetailOnProgressModel gamificationDetailFromJson(String str) =>
    GamificationDetailOnProgressModel.fromJson(json.decode(str));

class GamificationDetailOnProgressModel {
  List<ItemGamificationDetailModel> items;
  Links links;
  Meta meta;

  GamificationDetailOnProgressModel({
    this.items,
    this.links,
    this.meta,
  });

  factory GamificationDetailOnProgressModel.fromJson(
          Map<String, dynamic> json) =>
      GamificationDetailOnProgressModel(
        items: List<ItemGamificationDetailModel>.from(
            json["items"].map((x) => ItemGamificationDetailModel.fromJson(x))),
        links: Links.fromJson(json["_links"]),
        meta: Meta.fromJson(json["_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "_links": links.toJson(),
        "_meta": meta.toJson(),
      };
}

class ItemGamificationDetailModel {
  int id;
  int gamificationId;
  int objectId;
  int userId;
  int createdAt;
  int updatedAt;
  int totalHit;
  String objectEvent;

  ItemGamificationDetailModel({
    this.id,
    this.gamificationId,
    this.objectId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.totalHit,
    this.objectEvent,
  });

  factory ItemGamificationDetailModel.fromJson(Map<String, dynamic> json) =>
      ItemGamificationDetailModel(
        id: json["id"],
        gamificationId: json["gamification_id"],
        objectId: json["object_id"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        totalHit: json["total_hit"],
        objectEvent: json["object_event"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gamification_id": gamificationId,
        "object_id": objectId,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "total_hit": totalHit,
        "object_event": objectEvent,
      };
}

class Links {
  Self self;

  Links({
    this.self,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: Self.fromJson(json["self"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
      };
}

class Self {
  String href;

  Self({
    this.href,
  });

  factory Self.fromJson(Map<String, dynamic> json) => Self(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class Meta {
  int totalCount;
  int pageCount;
  int currentPage;
  int perPage;

  Meta({
    this.totalCount,
    this.pageCount,
    this.currentPage,
    this.perPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        totalCount: json["totalCount"],
        pageCount: json["pageCount"],
        currentPage: json["currentPage"],
        perPage: json["perPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "pageCount": pageCount,
        "currentPage": currentPage,
        "perPage": perPage,
      };
}
