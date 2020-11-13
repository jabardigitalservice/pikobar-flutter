
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/MenuListOther.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';

class BottomSheetMenu {
  const BottomSheetMenu._();

  static Future<void> showBottomSheetMenu(
      {@required BuildContext context}) async {



    return showWidgetBottomSheet(
        context: context,
        isScrollControlled: true,
        child: MenuList());
  }




}
