import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatefulWidget {
  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          Dictionary.sayThanks,
          style: TextStyle(
              color: ColorBase.netralGrey,
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.lato,
              fontSize: Dimens.textSubtitleSize),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          Dictionary.followOurSosmed,
          style: TextStyle(
              color: ColorBase.netralGrey,
              fontFamily: FontsFamily.lato,
              fontSize: Dimens.textSubtitleSize),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () async {
                launchUrl(kUrlInstagramPikobar, '');
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset(
                  '${Environment.logoAssets}instagram_logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () async {
                launchUrl(kUrlTwitterPikobar, '');
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset(
                  '${Environment.logoAssets}twitter_logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () async {
                launchUrl(kUrlFacebookPikobarProtocol, kUrlFacebookPikobar);
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                child: Image.asset(
                  '${Environment.logoAssets}facebook_logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ],
    );
  }

  launchUrl(String url, String fallbackUrl) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        universalLinksOnly: true,
      );
    } else {
      await launch(
        fallbackUrl,
        universalLinksOnly: true,
      );
      throw 'There was a problem to open the url: $url';
    }
  }
}
