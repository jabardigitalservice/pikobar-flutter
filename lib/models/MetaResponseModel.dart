// To parse this JSON data, do
//
//     final metaResponseModel = metaResponseModelFromJson(jsonString);

import 'dart:convert';

MetaResponseModel metaResponseModelFromJson(String str) => MetaResponseModel.fromJson(json.decode(str));


class MetaResponseModel {
  int totalCount;
  int pageCount;
  int currentPage;
  int perPage;

  MetaResponseModel({
    this.totalCount,
    this.pageCount,
    this.currentPage,
    this.perPage,
  });

  factory MetaResponseModel.fromJson(Map<String, dynamic> json) => MetaResponseModel(
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
