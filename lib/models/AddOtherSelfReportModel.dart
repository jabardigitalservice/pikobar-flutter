// To parse this JSON data, do
//
//     final dailyReport = dailyReportFromJson(jsonString);

import 'dart:convert';


AddOtherSelfReportModel dailyReportFromJson(String str) =>
    AddOtherSelfReportModel.fromJson(json.decode(str));

String dailyReportToJson(AddOtherSelfReportModel data) =>
    json.encode(data.toJson());

class AddOtherSelfReportModel {
  AddOtherSelfReportModel(
      {this.userId,
      this.createdAt,
      this.birthday,
      this.name,
      this.gender,
      this.nik,
      this.relation});

  String userId;
  DateTime createdAt;
  DateTime birthday;
  String name;
  String gender;
  String nik;
  String relation;

  factory AddOtherSelfReportModel.fromJson(Map<String, dynamic> json) =>
      AddOtherSelfReportModel(
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        birthday: DateTime.parse(json["birthday"]),
        name: json["name"],
        gender: json["gender"],
        nik: json["nik"],
        relation: json["relation"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "created_at": createdAt,
        "birthday": birthday,
        "name": name,
        "gender": gender,
        "nik": nik,
        "relation": relation,
      };
}
