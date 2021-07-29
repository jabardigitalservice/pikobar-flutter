import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

import 'TermsConditions.dart';

class OnBoardingLoginScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final double positionBottom;
  final bool showTitle;

  OnBoardingLoginScreen(
      {Key key,
      this.authenticationBloc,
      this.positionBottom,
      this.showTitle = false})
      : super(key: key);

  @override
  _OnBoardingLoginScreenState createState() => _OnBoardingLoginScreenState();
}

class _OnBoardingLoginScreenState extends State<OnBoardingLoginScreen> {
  RemoteConfigBloc _remoteConfigBloc;

  bool isAgree = false;
  String _versionText = Dictionary.version;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionText = packageInfo.version != null
            ? packageInfo.version
            : Dictionary.version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider<RemoteConfigBloc>(
      create: (BuildContext context) =>
          _remoteConfigBloc = RemoteConfigBloc()..add(RemoteConfigLoad()),
      child: Column(
        children: <Widget>[
          widget.showTitle
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    Dictionary.profile,
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          Expanded(
              child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('${Environment.logoAssets}pikobar_logo_flat.png',
                      width: 80, height: 80),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        Dictionary.appName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.intro,
                        ),
                      ))
                ],
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(Dimens.padding, 20, Dimens.padding, 0),
                child: Text(
                  Dictionary.titleOnBoardingLogin,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorBase.netralGrey,
                      fontFamily: FontsFamily.roboto,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                builder: (context, state) {
                  return state is RemoteConfigLoaded
                      ? _buildTermsConditions(state.remoteConfig)
                      : Container();
                },
              ),
              Container(
                width: size.width,
                height: 40,
                margin: EdgeInsets.fromLTRB(Dimens.padding, Dimens.padding,
                    Dimens.padding, Dimens.padding),
                child: RaisedButton(
                    splashColor: Colors.lightGreenAccent,
                    padding: EdgeInsets.all(0),
                    color: isAgree ? ColorBase.green : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.borderRadius),
                    ),
                    child: Text(
                      Dictionary.acceptLogin,
                      style: TextStyle(
                          fontFamily: FontsFamily.roboto,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      if (isAgree) {
                        Platform.isAndroid
                            ? widget.authenticationBloc.add(LoggedIn())
                            : _loginBottomSheet(context);
                      } else {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(Dictionary.aggrementIsFalse),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                    }),
              ),
              Container(
                margin:
                    EdgeInsets.fromLTRB(Dimens.padding, 0, Dimens.padding, 50),
                child: Text(
                  '${Dictionary.versionText} ' + _versionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorBase.darkGrey,
                      fontFamily: FontsFamily.lato,
                      fontSize: 12),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  _buildTermsConditions(RemoteConfig remoteConfig) {
    dynamic termsConditions;
    dynamic dataPrivacy;
    if (remoteConfig.getString(FirebaseConfig.dataPrivacy).isNotEmpty ||
        remoteConfig.getString(FirebaseConfig.termsConditions).isNotEmpty) {
      termsConditions =
          json.decode(remoteConfig.getString(FirebaseConfig.termsConditions));
      dataPrivacy =
          json.decode(remoteConfig.getString(FirebaseConfig.dataPrivacy));
      return Container(
        margin: EdgeInsets.fromLTRB(10, 0, Dimens.padding, 10),
        child: Row(
          children: <Widget>[
            Checkbox(
              value: isAgree,
              activeColor: ColorBase.lightLimeGreen,
              checkColor: ColorBase.limeGreen,
              onChanged: (bool value) {
                setState(() {
                  isAgree = value;
                });
              },
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.81,
                child: Html(
                    data: dataPrivacy['agreement'],
                    style: {
                      'p': Style(
                          color: ColorBase.netralGrey,
                          fontSize: FontSize(11),
                          lineHeight: 1.7,
                          fontFamily: FontsFamily.roboto),
                    },
                    onLinkTap: (url) {
                      if (url == 'termsAndCondition') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsConditionsPage(
                                    title: Dictionary.termsConditions,
                                    termsAndPrivacyConfig: termsConditions,
                                  )),
                        );
                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedTermsAndConditions);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsConditionsPage(
                                    title: Dictionary.dataPrivacy,
                                    termsAndPrivacyConfig: dataPrivacy,
                                  )),
                        );
                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedDataPrivacy);
                      }
                    })),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _loginBottomSheet(context) async {
    /// Determine if Sign In with Apple is supported on the current device
    bool isAvailable = await AppleSignIn.isAvailable();

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        elevation: 60,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 14),
                  color: Colors.black,
                  height: 1.5,
                  width: 40,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(05),
                      offset: Offset(0, 05),
                    ),
                  ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
                      isAvailable
                          ? Column(children: <Widget>[
                              _signInButton(isApple: true),
                              SizedBox(
                                height: 16,
                              )
                            ])
                          : Container(),
                      _signInButton(isApple: false)
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _signInButton({bool isApple = false}) {
    return CustomButton.icon(
      color: isApple ? Colors.black : Colors.transparent,
      borderColor: isApple ? Colors.black : Colors.grey,
      onPressed: () {
        Navigator.pop(context);
        widget.authenticationBloc.add(LoggedIn(isApple: isApple));
      },
      icon: Image(
          image: AssetImage(
              '${Environment.iconAssets}${isApple ? 'apple_white.png' : 'google.png'}'),
          height: 24),
      label: Text(
        isApple ? Dictionary.signInWithApple : Dictionary.signInWithGoogle,
        style: TextStyle(
          fontSize: 15,
          color: isApple ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remoteConfigBloc.close();
    super.dispose();
  }
}
