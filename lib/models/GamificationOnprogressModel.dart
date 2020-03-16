import 'dart:convert';

GamificationOnprogressModel gamificationOnProgressFromJson(String str) => GamificationOnprogressModel.fromJson(json.decode(str));

class GamificationOnprogressModel {
  List<ItemOnProgressModel> items;
  Links links;
  Meta meta;

  GamificationOnprogressModel({
    this.items,
    this.links,
    this.meta,
  });

  factory GamificationOnprogressModel.fromJson(Map<String, dynamic> json) => GamificationOnprogressModel(
    items: List<ItemOnProgressModel>.from(json["items"].map((x) => ItemOnProgressModel.fromJson(x))),
    links: Links.fromJson(json["_links"]),
    meta: Meta.fromJson(json["_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "_links": links.toJson(),
    "_meta": meta.toJson(),
  };
}

class ItemOnProgressModel {
  int id;
  int gamificationId;
  int userId;
  int totalUserHit;
  int createdAt;
  int updatedAt;
  bool completed;
  Gamification gamification;

  ItemOnProgressModel({
    this.id,
    this.gamificationId,
    this.userId,
    this.totalUserHit,
    this.createdAt,
    this.updatedAt,
    this.completed,
    this.gamification,
  });

  factory ItemOnProgressModel.fromJson(Map<String, dynamic> json) => ItemOnProgressModel(
    id: json["id"],
    gamificationId: json["gamification_id"],
    userId: json["user_id"],
    totalUserHit: json["total_user_hit"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    completed: json["completed"],
    gamification: Gamification.fromJson(json["gamification"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gamification_id": gamificationId,
    "user_id": userId,
    "total_user_hit": totalUserHit,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "completed": completed,
    "gamification": gamification.toJson(),
  };
}

class Gamification {
  int id;
  String title;
  String titleBadge;
  String description;
  String objectType;
  String objectEvent;
  int totalHit;
  String imageBadgePathUrl;
  DateTime startDate;
  DateTime endDate;
  int status;
  String statusLabel;
  int createdAt;
  int updatedAt;
  int createdBy;

  Gamification({
    this.id,
    this.title,
    this.titleBadge,
    this.description,
    this.objectType,
    this.objectEvent,
    this.totalHit,
    this.imageBadgePathUrl,
    this.startDate,
    this.endDate,
    this.status,
    this.statusLabel,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
  });

  factory Gamification.fromJson(Map<String, dynamic> json) => Gamification(
    id: json["id"],
    title: json["title"],
    titleBadge: json["title_badge"],
    description: json["description"],
    objectType: json["object_type"],
    objectEvent: json["object_event"],
    totalHit: json["total_hit"],
    imageBadgePathUrl: json["image_badge_path_url"],
    startDate: DateTime.parse(json["start_date"]),
    endDate: DateTime.parse(json["end_date"]),
    status: json["status"],
    statusLabel: json["status_label"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "title_badge": titleBadge,
    "description": description,
    "object_type": objectType,
    "object_event": objectEvent,
    "total_hit": totalHit,
    "image_badge_path_url": imageBadgePathUrl,
    "start_date": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "status": status,
    "status_label": statusLabel,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "created_by": createdBy,
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
