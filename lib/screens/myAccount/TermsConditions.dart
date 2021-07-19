import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class TermsConditionsPage extends StatefulWidget {
  final Map<String, dynamic> termsAndPrivacyConfig;
  final String title;

  TermsConditionsPage({Key key, this.termsAndPrivacyConfig, this.title})
      : super(key: key);

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  ScrollController _scrollController;

  @override
  void initState() {
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
      titleAppbar: widget.title,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('${Environment.logoAssets}logo.png',
                        width: 50, height: 50),
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
              ),
              Text(
                widget.termsAndPrivacyConfig['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.termsAndPrivacyConfig['date'] ?? '',
                style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  color: ColorBase.darkGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Html(
                    data: widget.termsAndPrivacyConfig['description'],
                    style: {
                      'body': Style(
                          color: Colors.black,
                          fontSize: FontSize(14),
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
