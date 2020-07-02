import 'package:cloud_firestore/cloud_firestore.dart';

class GugusTugasWebModel {
  String id;
  String code;
  String name;
  String website;



  GugusTugasWebModel(
      {this.id, this.code, this.name, this.website});

  factory GugusTugasWebModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data;
    return GugusTugasWebModel(
      id: document.documentID,
      code: json["code"] ?? '',
      name: json["name"] ?? '',
      website: json["website"]?? '',
    );
  }
}
