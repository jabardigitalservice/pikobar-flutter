// To parse this JSON data, do
//
//     final contactHistoryModel = contactHistoryModelFromJson(jsonString);

import 'dart:convert';

ContactHistoryModel contactHistoryModelFromJson(String str) => ContactHistoryModel.fromJson(json.decode(str));

String contactHistoryModelToJson(ContactHistoryModel data) => json.encode(data.toJson());

class ContactHistoryModel {
  ContactHistoryModel({
    this.id,
    this.createdAt,
    this.lastContactDate,
    this.name,
    this.phoneNumber,
    this.gender,
    this.relation,
  });

  String id;
  DateTime createdAt;
  DateTime lastContactDate;
  String name;
  String phoneNumber;
  String gender;
  String relation;

  factory ContactHistoryModel.fromJson(Map<String, dynamic> json) => ContactHistoryModel(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    lastContactDate: DateTime.parse(json["last_contact_date"]),
    name: json["name"],
    phoneNumber: json["phone_number"],
    gender: json["gender"],
    relation: json["relation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "last_contact_date": lastContactDate,
    "name": name,
    "phone_number": phoneNumber,
    "gender": gender,
    "relation": relation,
  };
}
