import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';

class EmergencyNumberRepository {
  final Firestore firestore = Firestore.instance;

  Stream<List<ReferralHospitalModel>> getReferralHospitalModelList() {
    return firestore
        .collection(Collections.emergencyNumbers)
        .orderBy('name')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => ReferralHospitalModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<CallCenterModel>> getCallCenterModelList() {
    return firestore
        .collection(Collections.callCenters)
        .orderBy('nama_kotkab')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => CallCenterModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<GugusTugasWebModel>> getGugusTugasWebList() {
    return firestore
        .collection(Collections.taskForces)
        .orderBy('name')
        .snapshots()
        .map((QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => GugusTugasWebModel.fromFirestore(doc))
            .toList());
  }
}
