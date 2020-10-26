import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class HealthCheck {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  /// Function for check user health status
  bool isUserHealty(String healthStat) {
    //condition for check data is null or not
    if (healthStat != null) {
      if (healthStat == Dictionary.healthy) {
        _firebaseMessaging.unsubscribeFromTopic('aktivasi_lapor_mandiri');
        return true;
      } else {
        _firebaseMessaging.subscribeToTopic('aktivasi_lapor_mandiri');
        return false;
      }
    } else {
      //if health status is null that give indication that user is healthy
      _firebaseMessaging.unsubscribeFromTopic('aktivasi_lapor_mandiri');
      return true;
    }
  }
}
