import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class MenuList extends StatefulWidget {
  final RemoteConfig remoteConfig;

  MenuList(this.remoteConfig);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  RemoteConfig get _remoteConfig => widget.remoteConfig;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(Dimens.padding, 10.0, Dimens.padding, 20.0),
      decoration: BoxDecoration(color: ColorBase.grey, boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          //            blurRadius: 5,
          offset: Offset(0.0, 0.05),
        ),
      ]),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              Dictionary.menus,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.productSans,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(height: Dimens.padding),
          _remoteConfig == null ? _defaultRowMenusOne() : _remoteRowMenusOne(),
          //_defaultRowMenusOne(),
          SizedBox(height: 5.0),
          _remoteConfig == null ? _defaultRowMenusTwo() : _remoteRowMenusTwo(),
          //_defaultRowMenusTwo(),
          SizedBox(height: 5.0),
          _remoteConfig == null
              ? _defaultRowMenusThree()
              : _remoteRowMenusThree()
          //_defaultRowMenusThree()
        ],
      ),
    );
  }

  _defaultRowMenusOne() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}emergency_numbers.png',
              Dictionary.phoneBookEmergency, NavigationConstrants.Phonebook),
          _buildButtonColumn('${Environment.iconAssets}pikobar.png',
              Dictionary.pikobar, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlCoronaInfo),
          _buildButtonColumn('${Environment.iconAssets}garuda_pancasila.png',
              Dictionary.nationalInfo, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlCoronaEscort),
          _buildButtonColumn('${Environment.iconAssets}world.png',
              Dictionary.worldInfo, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlWorldCoronaInfo),
        ],
      ),
    );
  }

  _defaultRowMenusTwo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}help.png',
              Dictionary.donation, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlDonation),
          _buildButtonColumn('${Environment.iconAssets}completed.png',
              Dictionary.survey, NavigationConstrants.Survey),
          _buildButtonColumn('${Environment.iconAssets}self_diagnose.png',
              Dictionary.selfDiagnose, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlSelfDiagnose),
          _buildButtonColumn('${Environment.iconAssets}logistics.png',
              Dictionary.logistic, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlLogisticsInfo),
        ],
      ),
    );
  }

  _defaultRowMenusThree() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}saber_hoax.png',
              Dictionary.saberHoax, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlIGSaberHoax),
          _buildButtonDisable(
              '${Environment.iconAssets}relawan.png', Dictionary.volunteer),
          _buildButtonDisable('${Environment.iconAssets}report_case.png',
              Dictionary.caseReport),
          _buildButtonDisable(
              '${Environment.iconAssets}conversation.png', Dictionary.qna),
        ],
      ),
    );
  }

  _remoteRowMenusOne() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Menu Button Emergency Numbers
          _buildButtonColumn('${Environment.iconAssets}emergency_numbers.png',
              Dictionary.phoneBookEmergency, NavigationConstrants.Phonebook,
              remoteMenuLoginKey: FirebaseConfig.emergencyNumberMenu),

          /// Menu Button Data Jabar
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}pikobar.png',
              _remoteConfig.getString(FirebaseConfig.pikobarCaption) != null
                  ? _remoteConfig.getString(FirebaseConfig.pikobarCaption)
                  : Dictionary.pikobar,
              NavigationConstrants.Browser,
              arguments:
                  _remoteConfig.getString(FirebaseConfig.pikobarUrl) != null
                      ? _remoteConfig.getString(FirebaseConfig.pikobarUrl)
                      : UrlThirdParty.urlCoronaInfo,
              remoteMenuLoginKey: FirebaseConfig.pikobarInfoMenu),

          /// Menu Button Data National
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}garuda_pancasila.png',
              _remoteConfig.getString(FirebaseConfig.nationalInfoCaption) !=
                      null
                  ? _remoteConfig.getString(FirebaseConfig.nationalInfoCaption)
                  : Dictionary.nationalInfo,
              NavigationConstrants.Browser,
              arguments:
                  _remoteConfig.getString(FirebaseConfig.nationalInfoUrl) !=
                          null
                      ? _remoteConfig.getString(FirebaseConfig.nationalInfoUrl)
                      : UrlThirdParty.urlCoronaEscort,
              remoteMenuLoginKey: FirebaseConfig.nationalInfoMenu),

          /// Menu Button Data World
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}world.png',
              _remoteConfig.getString(FirebaseConfig.worldInfoCaption) != null
                  ? _remoteConfig.getString(FirebaseConfig.worldInfoCaption)
                  : Dictionary.worldInfo,
              NavigationConstrants.Browser,
              arguments:
                  _remoteConfig.getString(FirebaseConfig.worldInfoUrl) != null
                      ? _remoteConfig.getString(FirebaseConfig.worldInfoUrl)
                      : UrlThirdParty.urlWorldCoronaInfo,
              remoteMenuLoginKey: FirebaseConfig.worldInfoMenu),
        ],
      ),
    );
  }

  _remoteRowMenusTwo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Menu Button Donation
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}help.png',
              _remoteConfig.getString(FirebaseConfig.donationCaption) != null
                  ? _remoteConfig.getString(FirebaseConfig.donationCaption)
                  : Dictionary.donation,
              NavigationConstrants.Browser,
              arguments:
                  _remoteConfig.getString(FirebaseConfig.donationUrl) != null
                      ? _remoteConfig.getString(FirebaseConfig.donationUrl)
                      : UrlThirdParty.urlDonation,
              remoteMenuLoginKey: FirebaseConfig.donationMenu),

          /// Menu Button Survei
          _buildButtonColumn('${Environment.iconAssets}completed.png',
              Dictionary.survey, NavigationConstrants.Survey,
              remoteMenuLoginKey: FirebaseConfig.surveyMenu),

          /// Menu Button Self Diagnose
          /// Remote Config : enabled, caption & url
          _remoteConfig.getBool(FirebaseConfig.selfDiagnoseEnabled)
              ? _buildButtonColumn(
                  '${Environment.iconAssets}self_diagnose.png',
                  _remoteConfig.getString(FirebaseConfig.selfDiagnoseCaption) != null
                      ? _remoteConfig
                          .getString(FirebaseConfig.selfDiagnoseCaption)
                      : Dictionary.selfDiagnose,
                  NavigationConstrants.Browser,
                  arguments: _remoteConfig
                              .getString(FirebaseConfig.selfDiagnoseUrl) !=
                          null
                      ? _remoteConfig.getString(FirebaseConfig.selfDiagnoseUrl)
                      : UrlThirdParty.urlSelfDiagnose,
                  remoteMenuLoginKey: FirebaseConfig.selfDiagnoseMenu)
              : _buildButtonDisable(
                  '${Environment.iconAssets}magnifying_glass.png',
                  _remoteConfig.getString(FirebaseConfig.selfDiagnoseCaption) !=
                          null
                      ? _remoteConfig
                          .getString(FirebaseConfig.selfDiagnoseCaption)
                      : _remoteConfig.getString(
                                  FirebaseConfig.selfDiagnoseCaption) !=
                              null
                          ? _remoteConfig
                              .getString(FirebaseConfig.selfDiagnoseCaption)
                          : Dictionary.selfDiagnose),

          /// Menu Button Logistic
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}logistics.png',
              _remoteConfig != null &&
                      _remoteConfig.getString(FirebaseConfig.logisticCaption) !=
                          null
                  ? _remoteConfig.getString(FirebaseConfig.logisticCaption)
                  : Dictionary.logistic,
              NavigationConstrants.Browser,
              arguments: _remoteConfig != null &&
                      _remoteConfig.getString(FirebaseConfig.logisticUrl) !=
                          null
                  ? _remoteConfig.getString(FirebaseConfig.logisticUrl)
                  : UrlThirdParty.urlLogisticsInfo,
              remoteMenuLoginKey: FirebaseConfig.logisticMenu),
        ],
      ),
    );
  }

  _remoteRowMenusThree() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Menu Button Saber Hoax
          /// Remote Config : caption & url
          _buildButtonColumn(
              '${Environment.iconAssets}saber_hoax.png',
              _remoteConfig != null &&
                      _remoteConfig.getString(FirebaseConfig.jshCaption) != null
                  ? _remoteConfig.getString(FirebaseConfig.jshCaption)
                  : Dictionary.saberHoax,
              NavigationConstrants.Browser,
              arguments: _remoteConfig != null &&
                      _remoteConfig.getString(FirebaseConfig.jshUrl) != null
                  ? _remoteConfig.getString(FirebaseConfig.jshUrl)
                  : UrlThirdParty.urlIGSaberHoax,
              remoteMenuLoginKey: FirebaseConfig.jshMenu),

          /// Menu Button Volunteer
          /// Remote Config : enabled, caption & url
          _remoteConfig != null &&
                  _remoteConfig.getBool(FirebaseConfig.volunteerEnabled)
              ? _buildButtonColumn(
                  '${Environment.iconAssets}relawan_active.png',
                  _remoteConfig != null &&
                          _remoteConfig
                                  .getString(FirebaseConfig.volunteerCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.volunteerCaption)
                      : Dictionary.volunteer,
                  NavigationConstrants.Browser,
                  arguments: _remoteConfig != null &&
                          _remoteConfig
                                  .getString(FirebaseConfig.volunteerUrl) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.volunteerUrl)
                      : UrlThirdParty.urlVolunteer,
                  remoteMenuLoginKey: FirebaseConfig.volunteerMenu)
              : _buildButtonDisable(
                  '${Environment.iconAssets}relawan.png',
                  _remoteConfig != null &&
                          _remoteConfig
                                  .getString(FirebaseConfig.volunteerCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.volunteerCaption)
                      : Dictionary.volunteer),

          /// Menu Button Report
          /// Remote Config : enabled, caption & url
          _remoteConfig != null &&
                  _remoteConfig.getBool(FirebaseConfig.reportEnabled)
              ? _buildButtonColumn(
                  '${Environment.iconAssets}report_case_active.png',
                  _remoteConfig != null &&
                          _remoteConfig
                                  .getString(FirebaseConfig.reportCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.reportCaption)
                      : Dictionary.caseReport,
                  NavigationConstrants.Browser,
                  arguments: _remoteConfig != null &&
                          _remoteConfig.getString(FirebaseConfig.reportUrl) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.reportUrl)
                      : UrlThirdParty.urlCaseReport,
                  remoteMenuLoginKey: FirebaseConfig.reportMenu)
              : _buildButtonDisable(
                  '${Environment.iconAssets}report_case.png',
                  _remoteConfig != null &&
                          _remoteConfig
                                  .getString(FirebaseConfig.reportCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.reportCaption)
                      : Dictionary.caseReport),

          /// Menu Button QnA / Forum
          /// Remote Config : enabled, caption & url
          _remoteConfig != null &&
                  _remoteConfig.getBool(FirebaseConfig.qnaEnabled)
              ? _buildButtonColumn(
                  '${Environment.iconAssets}conversation_active.png',
                  _remoteConfig != null &&
                          _remoteConfig.getString(FirebaseConfig.qnaCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.qnaCaption)
                      : Dictionary.qna,
                  NavigationConstrants.Browser,
                  arguments: _remoteConfig != null &&
                          _remoteConfig.getString(FirebaseConfig.qnaUrl) != null
                      ? _remoteConfig.getString(FirebaseConfig.qnaUrl)
                      : UrlThirdParty.urlQNA,
                  remoteMenuLoginKey: FirebaseConfig.qnaMenu)
              : _buildButtonDisable(
                  '${Environment.iconAssets}conversation.png',
                  _remoteConfig != null &&
                          _remoteConfig.getString(FirebaseConfig.qnaCaption) !=
                              null
                      ? _remoteConfig.getString(FirebaseConfig.qnaCaption)
                      : Dictionary.qna)
        ],
      ),
    );
  }

  _buildButtonColumn(String iconPath, String label, String route,
      {Object arguments, bool openBrowser = false, String remoteMenuLoginKey}) {
    return Expanded(
      child: GestureDetector(
        child: Column(
          children: [
            Container(
              width: 70.0,
              height: 70.0,
              padding: EdgeInsets.all(18.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 6.0,
                  color: Colors.black.withOpacity(.2),
                  offset: Offset(2.0, 4.0),
                ),
              ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
              child: Image.asset(
                  iconPath,
                ),
            ),
            SizedBox(height: 12.0),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11.0,
                    color: Theme.of(context).textTheme.body1.color,
                    fontFamily: FontsFamily.productSans))
          ],
        ),
        onTap: () async {
          if (route != null) {
            if (_remoteConfig != null &&
                _remoteConfig.getString(FirebaseConfig.loginRequired) !=
                    null) {
              Map<String, dynamic> _loginRequiredMenu = json.decode(
                  _remoteConfig.getString(FirebaseConfig.loginRequired));

              if (_loginRequiredMenu[remoteMenuLoginKey]) {
                bool hasToken = await AuthRepository().hasToken();

                if (!hasToken) {
                  bool isLoggedIn = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(title: label)));

                  if (isLoggedIn != null && isLoggedIn) {
                    arguments = await userDataUrlAppend(arguments);

                    if (route == NavigationConstrants.Browser) {
                      openChromeSafariBrowser(url: arguments);
                    } else {
                      Navigator.pushNamed(context, route,
                          arguments: arguments);
                    }
                  }
                } else {
                  arguments = await userDataUrlAppend(arguments);

                  if (route == NavigationConstrants.Browser) {
                    openChromeSafariBrowser(url: arguments);
                  } else {
                    Navigator.pushNamed(context, route,
                        arguments: arguments);
                  }
                }
              } else {
                arguments = await userDataUrlAppend(arguments);

                if (route == NavigationConstrants.Browser) {
                  openChromeSafariBrowser(url: arguments);
                } else {
                  Navigator.pushNamed(context, route,
                      arguments: arguments);
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
              AnalyticsHelper.setLogEvent(
                  Analytics.tappedphoneBookEmergency);
            } else if (label == Dictionary.saberHoax) {
              AnalyticsHelper.setLogEvent(Analytics.tappedJabarSaberHoax);
            } else if (iconPath ==
                '${Environment.iconAssets}pikobar.png') {
              AnalyticsHelper.setLogEvent(Analytics.tappedInfoCorona);
            } else if (iconPath ==
                '${Environment.iconAssets}garuda_pancasila.png') {
              AnalyticsHelper.setLogEvent(Analytics.tappedKawalCovid19);
            } else if (iconPath == '${Environment.iconAssets}world.png') {
              AnalyticsHelper.setLogEvent(Analytics.tappedWorldInfo);
            } else if (label == Dictionary.survey) {
              AnalyticsHelper.setLogEvent(Analytics.tappedSurvey);
            } else if (iconPath ==
                '${Environment.iconAssets}self_diagnose.png') {
              AnalyticsHelper.setLogEvent(Analytics.tappedSelfDiagnose);
            } else if (iconPath ==
                '${Environment.iconAssets}logistics.png') {
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
      ),
    );
  }

  _buildButtonDisable(String iconPath, String label, {bool visible = true}) {
    return Expanded(
      child: Visibility(
        visible: visible,
        maintainState: visible ? false : true,
        maintainAnimation: visible ? false : true,
        maintainSize: visible ? false : true,
        child: GestureDetector(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  width: 70.0,
                  height: 70.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(.2),
                          offset: Offset(2.0, 4.0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white),
                  child: IconButton(
                    color: Theme.of(context).textTheme.body1.color,
                    iconSize: 32.0,
                    icon: Image.asset(
                      iconPath,
                    ),
                    onPressed: null,
                  ),
                ),
                Positioned(
                    right: 2.0,
                    child: Image.asset(
                      '${Environment.iconAssets}bookmark_1.png',
                      width: 18.0,
                      height: 18.0,
                    ))
              ]),
              SizedBox(height: 12.0),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11.0,
                      color: Theme.of(context).textTheme.body1.color,
                      fontFamily: FontsFamily.productSans))
            ],
          ),
          onTap: () {
            Fluttertoast.showToast(
                msg: Dictionary.onDevelopment,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1);
          },
        ),
      ),
    );
  }

// TODO: unsed widget
// _buildButtonColumnLayananLain(String iconPath, String label) {
//   return Expanded(
//       child: Column(
//     children: [
//       Container(
//         padding: EdgeInsets.all(2.0),
//         decoration: BoxDecoration(boxShadow: [
//           BoxShadow(
//             blurRadius: 10.0,
//             color: Colors.black.withOpacity(.2),
//             offset: Offset(2.0, 2.0),
//           ),
//         ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
//         child: IconButton(
//           color: Theme.of(context).textTheme.body1.color,
//           icon: Image.asset(iconPath),
//           onPressed: () {
//             _mainHomeBottomSheet(context);

//             AnalyticsHelper.setLogEvent(Analytics.tappedOthers);
//           },
//         ),
//       ),
//       SizedBox(height: 12.0),
//       Text(label,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 12,
//             color: Theme.of(context).textTheme.body1.color,
//           ))
//     ],
//   ));
// }

// void _mainHomeBottomSheet(context) {
//   showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.0),
//           topRight: Radius.circular(10.0),
//         ),
//       ),
//       elevation: 60.0,
//       builder: (BuildContext context) {
//         return Container(
//           margin: EdgeInsets.only(bottom: 20.0),
//           child: Wrap(
//             alignment: WrapAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(top: 14.0),
//                 color: Colors.black,
//                 height: 1.5,
//                 width: 40.0,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(left: Dimens.padding, top: 10.0),
//                 child: Text(
//                   Dictionary.otherMenus,
//                   style:
//                       TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
//                 ),
//               ),
//               Container(
//                 alignment: Alignment.topCenter,
//                 padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                 decoration: BoxDecoration(boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.05),
//                     offset: Offset(0.0, 0.05),
//                   ),
//                 ]),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildButtonColumn(
//                               '${Environment.iconAssets}saber_hoax.png',
//                               _remoteConfig != null &&
//                                       _remoteConfig.getString(
//                                               FirebaseConfig.jshCaption) !=
//                                           null
//                                   ? _remoteConfig
//                                       .getString(FirebaseConfig.jshCaption)
//                                   : Dictionary.saberHoax,
//                               _remoteConfig != null &&
//                                       _remoteConfig.getString(
//                                               FirebaseConfig.jshUrl) !=
//                                           null
//                                   ? _remoteConfig
//                                       .getString(FirebaseConfig.jshUrl)
//                                   : UrlThirdParty.urlIGSaberHoax,
//                               openBrowser: true),
//                           _buildButtonColumn(
//                               '${Environment.iconAssets}package.png',
//                               _remoteConfig != null &&
//                                       _remoteConfig.getString(FirebaseConfig
//                                               .logisticCaption) !=
//                                           null
//                                   ? _remoteConfig.getString(
//                                       FirebaseConfig.logisticCaption)
//                                   : Dictionary.logistic,
//                               NavigationConstrants.Browser,
//                               arguments: _remoteConfig != null &&
//                                       _remoteConfig.getString(
//                                               FirebaseConfig.logisticUrl) !=
//                                           null
//                                   ? _remoteConfig
//                                       .getString(FirebaseConfig.logisticUrl)
//                                   : UrlThirdParty.urlLogisticsInfo),
//                           _remoteConfig != null &&
//                                   _remoteConfig
//                                       .getBool(FirebaseConfig.qnaEnabled)
//                               ? _buildButtonColumn(
//                                   '${Environment.iconAssets}conversation.png',
//                                   _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.qnaCaption) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.qnaCaption)
//                                       : Dictionary.qna,
//                                   NavigationConstrants.Browser,
//                                   arguments: _remoteConfig != null &&
//                                           _remoteConfig.getString(
//                                                   FirebaseConfig.qnaUrl) !=
//                                               null
//                                       ? _remoteConfig
//                                           .getString(FirebaseConfig.qnaUrl)
//                                       : UrlThirdParty.urlQNA)
//                               : _buildButtonDisable(
//                                   '${Environment.iconAssets}conversation.png',
//                                   Dictionary.qna),
//                           _remoteConfig != null &&
//                                   _remoteConfig.getBool(
//                                       FirebaseConfig.volunteerEnabled)
//                               ? _buildButtonColumn(
//                                   '${Environment.iconAssets}relawan.png',
//                                   _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.volunteerCaption) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.volunteerCaption)
//                                       : Dictionary.volunteer,
//                                   NavigationConstrants.Browser,
//                                   arguments: _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.volunteerUrl) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.volunteerUrl)
//                                       : UrlThirdParty.urlVolunteer)
//                               : _buildButtonDisable(
//                                   '${Environment.iconAssets}relawan.png',
//                                   Dictionary.volunteer),
//                         ],
//                       ),
//                     ),

//                     SizedBox(
//                       height: 8.0,
//                     ),

//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 8),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _remoteConfig != null &&
//                                   _remoteConfig
//                                       .getBool(FirebaseConfig.reportEnabled)
//                               ? _buildButtonColumn(
//                                   '${Environment.iconAssets}report_case.png',
//                                   _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.reportCaption) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.reportCaption)
//                                       : Dictionary.caseReport,
//                                   NavigationConstrants.Browser,
//                                   arguments: _remoteConfig != null &&
//                                           _remoteConfig.getString(
//                                                   FirebaseConfig.reportUrl) !=
//                                               null
//                                       ? _remoteConfig
//                                           .getString(FirebaseConfig.reportUrl)
//                                       : UrlThirdParty.urlCaseReport)
//                               : _buildButtonDisable(
//                                   '${Environment.iconAssets}report_case.png',
//                                   Dictionary.caseReport),
//                           _remoteConfig != null &&
//                                   _remoteConfig.getBool(
//                                       FirebaseConfig.selfTracingEnabled)
//                               ? _buildButtonColumn(
//                                   '${Environment.iconAssets}network.png',
//                                   _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.selfTracingCaption) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.selfTracingCaption)
//                                       : Dictionary.selfTracing,
//                                   NavigationConstrants.Browser,
//                                   arguments: _remoteConfig != null &&
//                                           _remoteConfig.getString(FirebaseConfig.selfTracingUrl) !=
//                                               null
//                                       ? _remoteConfig.getString(
//                                           FirebaseConfig.selfTracingUrl)
//                                       : UrlThirdParty.urlSelfTracing)
//                               : _buildButtonDisable(
//                                   '${Environment.iconAssets}network.png',
//                                   Dictionary.selfTracing),
//                           _buildButtonDisable(
//                               '${Environment.iconAssets}report_case.png',
//                               Dictionary.volunteer,
//                               visible: false),
//                           _buildButtonDisable(
//                               '${Environment.iconAssets}report_case.png',
//                               Dictionary.volunteer,
//                               visible: false)
//                         ],
//                       ),
//                     ),
//                     // secondRowShortcuts
//                   ],
//                 ),
//               )
//             ],
//           ),
//         );
//       });
// }
}
