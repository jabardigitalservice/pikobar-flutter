// To parse this JSON data, do
//
//     final dailyReport = dailyReportFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

DailyReportModel dailyReportFromJson(String str) => DailyReportModel.fromJson(json.decode(str));

String dailyReportToJson(DailyReportModel data) => json.encode(data.toJson());

class DailyReportModel {
  DailyReportModel({
    this.id,
    this.createdAt,
    this.contactDate,
    this.indications,
    this.bodyTemperature,
    this.location,
  });

  String id;
  DateTime createdAt;
  DateTime contactDate;
  String indications;
  String bodyTemperature;
  LatLng location;

  factory DailyReportModel.fromJson(Map<String, dynamic> json) => DailyReportModel(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    contactDate: DateTime.parse(json["contact_date"]),
    indications: json["indications"],
    bodyTemperature: json["body_temperature"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "contact_date": contactDate,
    "indications": indications,
    "body_temperature": bodyTemperature,
    "location": GeoPoint(location.latitude, location.longitude),
  };
}
