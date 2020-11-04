import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';

class BottomSheetMenu {
  const BottomSheetMenu._();

  static void showBottomSheetMenu({@required BuildContext context}) {
    return showWidgetBottomSheet(
        context: context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pusat Layanan & Informasi (8)',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            SizedBox(
              height: 24.0,
            ),
            GridView.builder(
              itemCount: 8,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 4,
                crossAxisSpacing: Dimens.padding,
                mainAxisSpacing: Dimens.padding,
                height: 120.0,
              ),
              itemBuilder: (context, int) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[50]),
                        child: Image.asset('${Environment.iconAssets}stayhome.png'),
                      ),
                      Text(
                        'Data Jabar',
                        style: TextStyle(fontFamily: FontsFamily.roboto),
                      )
                    ],
                  ),
                );
              },
            ),

            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu Lainnya (7)',
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                showBottomSheetMenuFull(context: context);
              },
            ),
            SizedBox(
              height: 24.0,
            ),
          ],
        ));
  }

  static void showBottomSheetMenuFull({@required BuildContext context}) {
    return showWidgetBottomSheet(
        context: context,
        isScrollControlled: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pusat Layanan & Informasi (8)',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            SizedBox(
              height: 24.0,
            ),
            GridView.builder(
              itemCount: 8,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 4,
                crossAxisSpacing: Dimens.padding,
                mainAxisSpacing: Dimens.padding,
                height: 120.0,
              ),
              itemBuilder: (context, int) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[50]),
                        child: Image.asset('${Environment.iconAssets}stayhome.png'),
                      ),
                      Text(
                        'Data Jabar',
                        style: TextStyle(fontFamily: FontsFamily.roboto),
                      )
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu Lainnya (7)',
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  Icon(Icons.keyboard_arrow_up)
                ],
              ),
              onTap: () {
                Navigator.of(context).pop();
                showBottomSheetMenu(context: context);
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            GridView.builder(
              itemCount: 8,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 4,
                crossAxisSpacing: Dimens.padding,
                mainAxisSpacing: Dimens.padding,
                height: 120.0,
              ),
              itemBuilder: (context, int) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[50]),
                        child: Image.asset('${Environment.iconAssets}stayhome.png'),
                      ),
                      Text(
                        'Data Jabar',
                        style: TextStyle(fontFamily: FontsFamily.roboto),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ));
  }
}