import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/NPSModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NPSRepository {

  NPSRepository._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveNPS(
      {@required NPSModel npsData}) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      final userId = await AuthRepository().getToken();
      final data = npsData.copyWith(id: userId, createdAt: DateTime.now());
      await _firestore
          .collection(kScores)
          .doc(data.id).set(data.toJson());

      await NPSRepository.setNPS();
      await NPSRepository.setNPSTimeLater(0);
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<int> getNPSTimeLater() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('nps_time_later');
  }

  static Future<void> setNPSTimeLater(int timeMilliseconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nps_time_later', timeMilliseconds);
  }

  static Future<bool> hasNPS() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('net_promote_score') ?? false;
  }

  static Future<void> setNPS() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('net_promote_score', true);
  }

  static Future<bool> hasSkipped() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('nps_skipped') ?? false;
  }

}