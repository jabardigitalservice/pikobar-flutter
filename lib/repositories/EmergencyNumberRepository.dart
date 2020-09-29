import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

class EmergencyNumberRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<ReferralHospitalModel>> getReferralHospitalModelList() {
    return firestore
        .collection(kEmergencyNumbers)
        .orderBy('city')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => ReferralHospitalModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<CallCenterModel>> getCallCenterModelList() {
    return firestore
        .collection(kCallCenters)
        .orderBy('nama_kotkab')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => CallCenterModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<GugusTugasWebModel>> getGugusTugasWebList() {
    return firestore.collection(kTaskForces).orderBy('name').snapshots().map(
        (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => GugusTugasWebModel.fromFirestore(doc))
            .toList());
  }
}
