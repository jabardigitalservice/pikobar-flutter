import 'package:flutter/material.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class OnBoardingLoginScreen extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final double positionBottom;

  OnBoardingLoginScreen({this.authenticationBloc, this.positionBottom});

  @override
  _OnBoardingLoginScreenState createState() => _OnBoardingLoginScreenState();
}

class _OnBoardingLoginScreenState extends State<OnBoardingLoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(60.0, 60.0, 60.0, 0.0),
                  child: Image.asset('${Environment.imageAssets}onboarding_login.png', width: 242.0,)),

              Container(
                margin: EdgeInsets.fromLTRB(Dimens.padding, 40.0, Dimens.padding, 0.0),
                child: Text(Dictionary.titleOnBoardingLogin, textAlign: TextAlign.center, style: TextStyle(fontFamily: FontsFamily.productSans, fontWeight: FontWeight.bold, fontSize: 14.0),),
              )
            ],
          ),
        ),

        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: widget.positionBottom??0.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(Dimens.padding, 0.0, Dimens.padding, 0.0),
                child: Text(Dictionary.disclaimerOnBoardingLogin, textAlign: TextAlign.center, style: TextStyle(fontFamily: FontsFamily.productSans, fontSize: 10.0),),
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                margin: EdgeInsets.fromLTRB(Dimens.padding, Dimens.padding, Dimens.padding, 25.0),
                child: RaisedButton(
                    splashColor: Colors.lightGreenAccent,
                    padding: EdgeInsets.all(0.0),
                    color: ColorBase.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  child: Text(Dictionary.acceptLogin, style: TextStyle(fontFamily: FontsFamily.productSans, fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white),),
                    onPressed: (){
                      widget.authenticationBloc.add(LoggedIn());
                    }),
              )
            ],
          ),
        ),
      ],
    );
  }
}
