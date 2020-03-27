import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageSharedPreference {

  /// Method get
  static Future<List<String>> getMessageData() async {
    final prefs = await SharedPreferences.getInstance();
    print('cekk isinya ada ngga? '+prefs.getStringList('message').length.toString());

    return prefs.getStringList('message');
  }

  /// Method set
  static Future<void> setMessageData(List<DocumentSnapshot> documentSnapshot) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listReadDataMessage = [];
    Future.delayed(Duration(milliseconds: 0), () async {
      listReadDataMessage = await  getMessageData();
    });
    for(int i=0;i<documentSnapshot.length;i++){
      if(!listReadDataMessage.contains(documentSnapshot[i]['title'])){
        listReadDataMessage.add(documentSnapshot[i]['title']+'##false');
      }
    }

    print('cekkk bos '+listReadDataMessage.length.toString());
    return prefs.setStringList('message', listReadDataMessage);
  }

  /// Method update list
  static Future<void> updateReadMessageData(String title) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> listReadDataMessage = [];
    Future.delayed(Duration(milliseconds: 0), () async {
      listReadDataMessage = await getMessageData();
    });
    for(int i=0;i<listReadDataMessage.length;i++){
      if(listReadDataMessage.contains(title)){
        listReadDataMessage[i] = title+'##true';
      }
    }

    print('cekkk bos '+listReadDataMessage.length.toString());
    return prefs.setStringList('message', listReadDataMessage);
  }
}
