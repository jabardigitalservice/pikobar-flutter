import 'package:cloud_firestore/cloud_firestore.dart';

class IsolationCenterModel {
  String id;
  String address;
  String city;
  String web;
  String name;
  List<dynamic> phones;

  IsolationCenterModel(
      {this.id, this.address, this.city, this.web, this.name, this.phones});

  factory IsolationCenterModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();
    return IsolationCenterModel(
      id: document.id,
      address: json["address"] ?? '',
      city: json["city"] ?? '',
      web: json["web"] ?? '',
      name: json["name"] ?? '',
      phones: json["phones"],
    );
  }
}
