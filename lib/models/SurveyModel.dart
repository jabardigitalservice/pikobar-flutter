// To parse this JSON data, do
//
//     final surveyModel = surveyModelFromJson(jsonString);

import 'dart:convert';

import 'CategoryModel.dart';

List<SurveyModel> listSurveyFromJson(String str) => List<SurveyModel>.from(
    json.decode(str).map((x) => SurveyModel.fromJson(x)));

SurveyModel surveyFromJson(String str) => SurveyModel.fromJson(json.decode(str));


class SurveyModel {
  int id;
  int categoryId;
  Category category;
  String title;
  String externalUrl;
  DateTime startDate;
  DateTime endDate;
  dynamic meta;
  int status;
  String statusLabel;
  dynamic kabkotaId;
  dynamic kabkota;
  dynamic kecId;
  dynamic kecamatan;
  dynamic kelId;
  dynamic kelurahan;
  dynamic rw;
  int createdAt;
  int updatedAt;

  SurveyModel({
    this.id,
    this.categoryId,
    this.category,
    this.title,
    this.externalUrl,
    this.startDate,
    this.endDate,
    this.meta,
    this.status,
    this.statusLabel,
    this.kabkotaId,
    this.kabkota,
    this.kecId,
    this.kecamatan,
    this.kelId,
    this.kelurahan,
    this.rw,
    this.createdAt,
    this.updatedAt,
  });

  factory SurveyModel.fromJson(Map<String, dynamic> json) => SurveyModel(
        id: json["id"],
        categoryId: json["category_id"],
        category: Category.fromJson(json["category"]),
        title: json["title"],
        externalUrl: json["external_url"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        meta: json["meta"],
        status: json["status"],
        statusLabel: json["status_label"],
        kabkotaId: json["kabkota_id"],
        kabkota: json["kabkota"],
        kecId: json["kec_id"],
        kecamatan: json["kecamatan"],
        kelId: json["kel_id"],
        kelurahan: json["kelurahan"],
        rw: json["rw"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "category": category.toJson(),
        "title": title,
        "external_url": externalUrl,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "meta": meta,
        "status": status,
        "status_label": statusLabel,
        "kabkota_id": kabkotaId,
        "kabkota": kabkota,
        "kec_id": kecId,
        "kecamatan": kecamatan,
        "kel_id": kelId,
        "kelurahan": kelurahan,
        "rw": rw,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}