import 'package:cloud_firestore/cloud_firestore.dart';

class CallCenterModel {
  String id;
  String nameCity;
  String codeCity;
  List<dynamic> hotline;
  List<dynamic> callCenter;


  CallCenterModel(
      {this.id, this.nameCity, this.codeCity, this.hotline, this.callCenter});

  factory CallCenterModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> json = document.data();
    return CallCenterModel(
      id: document.id,
      nameCity: json["nama_kotkab"] ?? '',
      codeCity: json["kode_kotkab"] ?? '',
      hotline: json["hotline"],
      callCenter: json["call_center"] ,
    );
  }
}
