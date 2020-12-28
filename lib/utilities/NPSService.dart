import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/NPSRepository.dart';

class NPSService {
  static Future<void> loadNetPromoterScore(BuildContext context) async {
    String userId = await AuthRepository().getToken();
    int oldTime = await NPSRepository.getNPSTimeLater();
    bool hasRated = await NPSRepository.hasNPS();

    if (oldTime == null) {
      oldTime = DateTime.now().millisecondsSinceEpoch;
      await NPSRepository.setNPSTimeLater(oldTime);
    }

    if (userId != null) {
      int rangeDays = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(oldTime))
          .inDays;

      if (!hasRated) {
        if (rangeDays >= 2) {
          showDialogNPS(context);
        }
      }
    }
  }
}
