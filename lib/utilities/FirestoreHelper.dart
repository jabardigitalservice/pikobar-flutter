import 'package:cloud_firestore/cloud_firestore.dart';

// Gets a nested field by String
// return null if field does not exist
String getField(DocumentSnapshot snapshot, String fieldName) {
  return snapshot.data().containsKey(fieldName) ? snapshot.get(fieldName):null;
}