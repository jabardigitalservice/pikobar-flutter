import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pikobar_flutter/configs/DBProvider.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/LocationModel.dart';
import 'package:sqflite/sqflite.dart';

class LocationsRepository {
  Future<void> sendLocationToServer(LocationModel data) async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();

    if (_user != null) {
      final userDocument = Firestore.instance
          .collection(Collections.users)
          .document(_user.uid);

      final locationsDocument =  userDocument.collection(Collections.userLocations)
            .document(data.id);

      locationsDocument.get().then((snapshot) {
          if (!snapshot.exists) {
            locationsDocument.setData(
                {
                  'id': data.id,
                  'location': GeoPoint(data.latitude, data.longitude),
                  'timestamp': DateTime.fromMillisecondsSinceEpoch(data.timestamp),
                });
          }
        });

    }
  }
}