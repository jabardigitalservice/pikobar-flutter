import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class TermsConditionsPage extends StatefulWidget {
  final Map<String, dynamic> termsConfig;

  TermsConditionsPage(this.termsConfig);

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    AnalyticsHelper.setLogEvent(Analytics.tappedTermsAndConditions);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CollapsingAppbar(
      scrollController: _scrollController,
      showTitle: _showTitle,
      titleAppbar: Dictionary.termsConditions,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.termsConfig['date'],
                style: TextStyle(
                  fontFamily: FontsFamily.roboto,
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
                          fontFamily: FontsFamily.lato,
                          textAlign: TextAlign.justify),
                    },
                    onLinkTap: (url) {
                      _launchURL(url);
                    }),
              ),
            ],
          ),
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
