// To parse this JSON data, do
//
//     final helpModel = helpModelFromJson(jsonString);

import 'dart:convert';

List<HelpModel> helpModelFromJson(String str) =>
    List<HelpModel>.from(json.decode(str).map((x) => HelpModel.fromJson(x)));

String helpModelToJson(List<HelpModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HelpModel {
  int id;
  String title;
  String description;
  bool expanded;

  HelpModel({
    this.id,
    this.title,
    this.description,
    this.expanded,
  });

  factory HelpModel.fromJson(Map<String, dynamic> json) => HelpModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        expanded: json["expanded"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "expanded": expanded,
      };
}
