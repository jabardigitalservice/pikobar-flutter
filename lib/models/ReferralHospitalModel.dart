import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralHospitalModel {
  String id;
  String address;
  String city;
  String web;
  String name;
  List<dynamic> phones;

  ReferralHospitalModel(
      {this.id, this.address, this.city, this.web, this.name, this.phones});

  factory ReferralHospitalModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data;
    return ReferralHospitalModel(
      id: document.documentID,
      address: json["address"] ?? '',
      city: json["city"] ?? '',
      web: json["web"] ?? '',
      name: json["name"] ?? '',
      phones: json["phones"],
    );
  }
}
