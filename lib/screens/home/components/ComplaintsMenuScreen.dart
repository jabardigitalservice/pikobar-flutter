import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/RemoteConfigRepository.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class ComplaintsMenuScreen extends StatelessWidget {
  final String complaintsUrl;

  const ComplaintsMenuScreen({Key key, @required this.complaintsUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.animatedAppBar(
          showTitle: false,
          title: Dictionary.pikobarComplaints,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<RemoteConfig>(
          future: RemoteConfigRepository().setupRemoteConfig(),
          builder: (context, snapshot) {
            bool isReady = snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Text(
                    Dictionary.pikobarComplaints,
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    _buildButtonMenu(
                        context,
                        '${Environment.iconAssets}whatsapp.png',
                        isReady
                            ? RemoteConfigHelper.getString(
                                remoteConfig: snapshot.data,
                                firebaseConfig:
                                    FirebaseConfig.reportHotlineCaption,
                                defaultValue: Dictionary.crowdComplaints)
                            : Dictionary.crowdComplaints,
                        isReady &&
                                !snapshot.data.getBool(
                                    FirebaseConfig.reportHotlineEnabled)
                            ? null
                            : () async {
                                await launchExternal(kUrlPikobarHotline);
                                await AnalyticsHelper.setLogEvent(
                                    Analytics.crowdReport);
                              }),
                    _buildButtonMenu(
                        context,
                        '${Environment.iconAssets}menu_logistik.png',
                        isReady
                            ? RemoteConfigHelper.getString(
                                remoteConfig: snapshot.data,
                                firebaseConfig: FirebaseConfig.reportCaption,
                                defaultValue: Dictionary.bansosComplaints)
                            : Dictionary.bansosComplaints,
                        isReady &&
                                !snapshot.data
                                    .getBool(FirebaseConfig.reportEnabled)
                            ? null
                            : () async {
                                await openChromeSafariBrowser(
                                    url: complaintsUrl);
                                await AnalyticsHelper.setLogEvent(
                                    Analytics.tappedCaseReport);
                              })
                  ],
                )
              ],
            );
          },
        ));
  }

  /// Function for build widget button self report
  _buildButtonMenu(BuildContext context, String image, String title,
      GestureTapCallback onPressed) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        color: ColorBase.greyContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / 2),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 30, child: Image.asset(image)),
              Container(
                margin: EdgeInsets.only(top: 15, left: 5.0, right: 10.0),
                child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: ColorBase.grey800,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              )
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    ));
  }
}
