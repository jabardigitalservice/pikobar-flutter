import 'dart:convert';

AdministrasiModel administrasiModelFromJson(String str) => AdministrasiModel.fromJson(json.decode(str));

String administrasiModelToJson(AdministrasiModel data) => json.encode(data.toJson());

class AdministrasiModel {
  int id;
  String title;
  String detail;
  String name;

  AdministrasiModel({
    this.id,
    this.title,
    this.detail,
    this.name,
  });

  factory AdministrasiModel.fromJson(Map<String, dynamic> json) => AdministrasiModel(
    id: json["id"],
    title: json["title"],
    detail: json["detail"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "detail": detail,
    "name": name,
  };
}
