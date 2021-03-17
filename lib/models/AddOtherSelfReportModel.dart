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
      this.relation,
      this.healthStatusCheck,
      this.healthStatus,
      this.healthStatusText,
      this.recurrenceReport});

  String userId;
  DateTime createdAt;
  DateTime birthday;
  String name;
  String gender;
  String nik;
  String relation;
  DateTime healthStatusCheck;
  String healthStatus;
  String healthStatusText;
  String recurrenceReport;

  factory AddOtherSelfReportModel.fromJson(Map<String, dynamic> json) =>
      AddOtherSelfReportModel(
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        birthday: DateTime.parse(json["birthday"]),
        name: json["name"],
        gender: json["gender"],
        nik: json["nik"],
        relation: json["relation"],
        healthStatusCheck: DateTime.parse(json["healh_status_check"]),
        healthStatus: json["health_status"],
        healthStatusText: json["health_status_text"],
        recurrenceReport: json["recurrence_report"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "created_at": createdAt,
        "birthday": birthday,
        "name": name,
        "gender": gender,
        "nik": nik,
        "relation": relation,
        "healh_status_check": healthStatusCheck,
        "health_status": healthStatus,
        "health_status_text": healthStatusText,
        "recurrence_report": recurrenceReport
      };
}
