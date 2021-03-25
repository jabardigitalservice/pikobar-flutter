import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/screens/home/components/MenuList.dart';

class BottomSheetMenu {
  const BottomSheetMenu._();

  static Future<void> showBottomSheetMenu(
          {@required BuildContext context}) async =>
      showWidgetBottomSheet(
        context: context,
        isScrollControlled: true,
        child: MenuList(),
      );
}
