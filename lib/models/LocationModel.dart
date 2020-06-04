// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.id,
    this.latitude,
    this.longitude,
    this.timestamp,
  });

  String id;
  double latitude;
  double longitude;
  int timestamp;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "latitude": latitude,
    "longitude": longitude,
    "timestamp": timestamp,
  };
}
