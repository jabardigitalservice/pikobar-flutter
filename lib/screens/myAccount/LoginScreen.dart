import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class LoginScreen extends StatefulWidget {
 final AuthenticationBloc authenticationBloc;
  LoginScreen({this.authenticationBloc});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Stack(
            children: <Widget>[
              Image.asset('${Environment.iconAssets}backgroundProfile.png'),
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  child:
                      Image.asset('${Environment.iconAssets}emptyProfile.png'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            Dictionary.textLogin,
            style: TextStyle(
                color: Color(0xff4F4F4F),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Text('',
              style: TextStyle(
                color: Color(0xff27AE60),
                fontSize: 14,
              )),
          SizedBox(
            height: 20,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20,
                          child: Image.asset(
                              '${Environment.iconAssets}versionLogo.png')),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        Dictionary.versionText,
                        style: TextStyle(color: Color(0xff4F4F4F)),
                      ),
                    ],
                  ),
                  Text(
                    _versionText + ' ' + Dictionary.betaText,
                    style: TextStyle(color: Color(0xff828282)),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              onPressed: () {
                widget.authenticationBloc.add(LoggedIn());
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Dictionary.textLoginButton,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff4F4F4F)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 20,
                            child: Image.asset(
                                '${Environment.iconAssets}googleIcon.png')),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
