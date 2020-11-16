import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class TermsConditionsPage extends StatefulWidget {
  final Map<String, dynamic> termsConfig;
  TermsConditionsPage(this.termsConfig);
  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: Dictionary.termsConditions,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
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
                Text(
                  widget.termsConfig['title'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.termsConfig['date'],
                  style: TextStyle(
                    color: ColorBase.darkGrey,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                  child: Html(
                      data: widget.termsConfig['description'],
                      style: {
                        'body': Style(
                            color: Colors.black,
                            fontSize: FontSize(14.0),
                            textAlign: TextAlign.justify),
                      },
                      onLinkTap: (url) {
                        _launchURL(url);
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  // Function to launch webview and catch parameter
  _launchURL(String url) async {
    List<String> items = [
      '_googleIDToken_',
      '_userUID_',
      '_userName_',
      '_userEmail_'
    ];
    if (StringUtils.containsWords(url, items)) {
      // Check if user login or not
      bool hasToken = await AuthRepository().hasToken();
      if (!hasToken) {
        // User not login send to login page
        bool isLoggedIn = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));

        if (isLoggedIn != null && isLoggedIn) {
          // Catch parameter and change value
          url = await userDataUrlAppend(url);
          // Open webview
          openChromeSafariBrowser(url: url);
        }
      } else {
        // Catch parameter and change value
        url = await userDataUrlAppend(url);
        // Open webview
        openChromeSafariBrowser(url: url);
      }
    } else {
      // Open webview
      openChromeSafariBrowser(url: url);
    }
  }
}
