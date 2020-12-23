import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/NPSRepository.dart';

class NPSService {

  //TODO: Implementasi remote config untuk pengaturan waktu kemunculan NPS
  static Future<void> loadNetPromoterScore(BuildContext context) async {

    String userId = await AuthRepository().getToken();

    if (userId != null) {

      int oldTime = await NPSRepository.getNPSTimeLater();
      bool hasRated = await NPSRepository.hasNPS();

      if (oldTime == null) {
        oldTime = DateTime.now().millisecondsSinceEpoch;
        await NPSRepository.setNPSTimeLater(oldTime);
      }

      int rangeDays = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(oldTime)).inMinutes;

      if (!hasRated) {
        if (rangeDays >= 3) {
          showDialogNPS(context);
        }
      }
    }
  }
}