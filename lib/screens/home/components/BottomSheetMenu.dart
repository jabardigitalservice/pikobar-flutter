import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/RemoteConfigRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';

class BottomSheetMenu {
  const BottomSheetMenu._();

  static Future<void> showBottomSheetMenu(
      {@required BuildContext context}) async {
    RemoteConfig remoteConfig =
        await RemoteConfigRepository().setupRemoteConfig();

    List<Widget> menus = <Widget>[
      _buildButtonColumn(context, remoteConfig, '${Environment.iconAssets}report_case_active.png',
          Dictionary.caseReport, NavigationConstrants.Browser,
          arguments: kUrlCaseReport),
      _buildButtonColumn(context, remoteConfig,
          '${Environment.iconAssets}spread_check.png',
          Dictionary.checkDistribution,
          NavigationConstrants.CheckDistribution),
      _buildButtonColumn(context, remoteConfig, '${Environment.iconAssets}bansos.png',
          Dictionary.bansos, NavigationConstrants.Browser,
          arguments: kUrlBansos),
    ];

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
              itemCount: menus.length,
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 4,
                crossAxisSpacing: Dimens.padding,
                mainAxisSpacing: Dimens.padding,
                height: 120.0,
              ),
              itemBuilder: (context, index) {
                return menus[index];
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

  static Future<void> showBottomSheetMenuFull(
      {@required BuildContext context}) async {
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
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
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
                        child: Image.asset(
                            '${Environment.iconAssets}stayhome.png'),
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
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
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
                        child: Image.asset(
                            '${Environment.iconAssets}stayhome.png'),
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

  static Widget _buildButtonColumn(BuildContext context, RemoteConfig remoteConfig, String iconPath, String label, String route,
      {Object arguments,
        String remoteMenuLoginKey}) {

    return GestureDetector(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50]),
            child: Image.asset(iconPath),
          ),
          Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: FontsFamily.roboto),
          )
        ],
      ),
      onTap: () async {
        if (route != null) {
          if (remoteConfig != null &&
              remoteConfig.getString(FirebaseConfig.loginRequired) != null) {
            Map<String, dynamic> _loginRequiredMenu = json.decode(
                remoteConfig.getString(FirebaseConfig.loginRequired));

            if (_loginRequiredMenu[remoteMenuLoginKey] != null &&
                _loginRequiredMenu[remoteMenuLoginKey]) {
              bool hasToken = await AuthRepository().hasToken();

              if (!hasToken) {
                bool isLoggedIn = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(title: label)));

                if (isLoggedIn != null && isLoggedIn) {
                  arguments = await userDataUrlAppend(arguments);

                  if (route == NavigationConstrants.Browser) {
                    openChromeSafariBrowser(url: arguments);
                  } else {
                    Navigator.pushNamed(context, route, arguments: arguments);
                  }
                }
              } else {
                arguments = await userDataUrlAppend(arguments);

                if (route == NavigationConstrants.Browser) {
                  openChromeSafariBrowser(url: arguments);
                } else {
                  Navigator.pushNamed(context, route, arguments: arguments);
                }
              }
            } else {
              arguments = await userDataUrlAppend(arguments);

              if (route == NavigationConstrants.Browser) {
                openChromeSafariBrowser(url: arguments);
              } else {
                Navigator.pushNamed(context, route, arguments: arguments);
              }
            }
          } else {
            arguments = await userDataUrlAppend(arguments);

            if (route == NavigationConstrants.Browser) {
              openChromeSafariBrowser(url: arguments);
            } else {
              Navigator.pushNamed(context, route, arguments: arguments);
            }
          }

          // record event to analytics
          if (label == Dictionary.phoneBookEmergency) {
            AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergency);
          } else if (label == Dictionary.saberHoax) {
            AnalyticsHelper.setLogEvent(Analytics.tappedJabarSaberHoax);
          } else if (label == Dictionary.titleSelfReport) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSelfReports);
          } else if (iconPath == '${Environment.iconAssets}pikobar.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedInfoCorona);
          } else if (iconPath == '${Environment.iconAssets}indo_flag.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedKawalCovid19);
          } else if (iconPath == '${Environment.iconAssets}world.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedWorldInfo);
          } else if (label == Dictionary.survey) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSurvey);
          } else if (iconPath ==
              '${Environment.iconAssets}self_diagnose.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedSelfDiagnose);
          } else if (iconPath == '${Environment.iconAssets}logistics.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedLogistic);
          } else if (iconPath ==
              '${Environment.iconAssets}relawan_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedVolunteer);
          } else if (iconPath ==
              '${Environment.iconAssets}report_case_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedCaseReport);
          } else if (iconPath == '${Environment.iconAssets}help.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedDonasi);
          } else if (iconPath ==
              '${Environment.iconAssets}conversation_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedQna);
          }
        }
      },
    );
  }
}
