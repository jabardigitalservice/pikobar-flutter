import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/MetaResponseModel.dart';
import 'package:pikobar_flutter/models/UserModel.dart';

ImportantInfoCommentModel importantInfoCommentModelFromJson(String str) =>
    ImportantInfoCommentModel.fromJson(json.decode(str));

ItemImportantInfoComment itemImportantInfoCommentFromJson(String str) =>
    ItemImportantInfoComment.fromJson(json.decode(str));

class ImportantInfoCommentModel {
  List<ItemImportantInfoComment> items;
  MetaResponseModel meta;

  ImportantInfoCommentModel({
    this.items,
    this.meta,
  });

  factory ImportantInfoCommentModel.fromJson(Map<String, dynamic> json) =>
      ImportantInfoCommentModel(
        items: List<ItemImportantInfoComment>.from(
            json["items"].map((x) => ItemImportantInfoComment.fromJson(x))),
        meta: MetaResponseModel.fromJson(json["_meta"]),
      );
}

// ignore: must_be_immutable
class ItemImportantInfoComment extends Equatable {
  int id;
  int newsImportantId;
  String text;
  User user;
  int createdAt;
  int updatedAt;
  int createdBy;
  int updatedBy;

  ItemImportantInfoComment({
    this.id,
    this.newsImportantId,
    this.text,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory ItemImportantInfoComment.fromJson(Map<String, dynamic> json) =>
      ItemImportantInfoComment(
        id: json["id"],
        newsImportantId: json["news_important_id"],
        text: json["text"],
        user: User.fromJson(json["user"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  @override
  List<Object> get props => [id];
}
