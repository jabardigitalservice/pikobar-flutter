import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

import 'TermsConditions.dart';

class OnBoardingLoginScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final double positionBottom;

  OnBoardingLoginScreen({this.authenticationBloc, this.positionBottom});

  @override
  _OnBoardingLoginScreenState createState() => _OnBoardingLoginScreenState();
}

class _OnBoardingLoginScreenState extends State<OnBoardingLoginScreen> {
  RemoteConfigBloc _remoteConfigBloc;

  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteConfigBloc>(
      create: (BuildContext context) =>
          _remoteConfigBloc = RemoteConfigBloc()..add(RemoteConfigLoad()),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 0.0,
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    '${Environment.imageAssets}onboarding_login.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('${Environment.logoAssets}logo.png',
                          width: 50.0, height: 50.0),
                      Container(
                          padding: const EdgeInsets.all(10.0),
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
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      Dimens.padding, 20.0, Dimens.padding, 0.0),
                  child: Text(
                    Dictionary.titleOnBoardingLogin,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: widget.positionBottom ?? 0.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                  builder: (context, state) {
                    return state is RemoteConfigLoaded
                        ? _buildTermsConditions(state.remoteConfig)
                        : Container();
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  margin: EdgeInsets.fromLTRB(
                      Dimens.padding, Dimens.padding, Dimens.padding, 25.0),
                  child: RaisedButton(
                      splashColor: Colors.lightGreenAccent,
                      padding: EdgeInsets.all(0.0),
                      color: isAgree ? ColorBase.green : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        Dictionary.acceptLogin,
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        if (isAgree) {
                          widget.authenticationBloc.add(LoggedIn());
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTermsConditions(RemoteConfig remoteConfig) {
    var termsConditions;
    if (remoteConfig.getString(FirebaseConfig.termsConditions).isNotEmpty) {
      termsConditions =
          json.decode(remoteConfig.getString(FirebaseConfig.termsConditions));
      return Container(
        margin: EdgeInsets.fromLTRB(Dimens.padding, 0.0, Dimens.padding, 0.0),
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
              width: MediaQuery.of(context).size.width * 0.75,
              child: RichText(
                text: TextSpan(
                    text: termsConditions['agreement'],
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        color: ColorBase.darkGrey,
                        fontSize: 11.0),
                    children: <TextSpan>[
                      TextSpan(
                          text: Dictionary.termsConditions,
                          style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsConditionsPage(termsConditions)),
                              );
                            })
                    ]),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _remoteConfigBloc.close();
    super.dispose();
  }
}
