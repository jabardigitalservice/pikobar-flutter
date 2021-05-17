import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class PermissionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45),
                      child: Image.asset(
                          '${Environment.imageAssets}share_location.png'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      Dictionary.permissionLocationTitleIOS,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontsFamily.roboto,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          height: 1.5),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    _buildListTile(
                        icon: '${Environment.iconAssets}maps_search.png',
                        title: Dictionary.zonationCheck),
                    _buildListTile(
                        icon: '${Environment.iconAssets}virus_warning.png',
                        title: Dictionary.checkDistribution),
                    _buildListTile(
                        icon: '${Environment.iconAssets}maps_edit.png',
                        title: Dictionary.chooseLocationEditProfile),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Dictionary.permissionLocationInfoIOS,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontsFamily.roboto,
                            fontSize: 12,
                            height: 1.5),
                      ),
                      const SizedBox(
                        height: Dimens.buttonTopMargin,
                      ),
                      RoundedButton(
                          title: Dictionary.nextStep,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          color: ColorBase.green,
                          elevation: 0.0,
                          onPressed: () async {
                            await _requestPermissions(context);
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({@required String icon, @required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: Dimens.iconImageSize,
            height: Dimens.iconImageSize,
          ),
          const SizedBox(
            width: Dimens.padding,
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: FontsFamily.roboto,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions(BuildContext context) async {
    if (!await Permission.locationAlways.status.isUndetermined &&
        !await Permission.locationWhenInUse.status.isUndetermined) {
      Platform.isAndroid
          ? await AppSettings.openAppSettings()
          : await AppSettings.openLocationSettings();
    }

    final status = await [
      Permission.locationAlways,
      Permission.locationWhenInUse
    ].request();

    Navigator.of(context).pop(status);
  }
}
