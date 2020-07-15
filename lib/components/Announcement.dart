import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/rich_text_parser.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class Announcement extends StatelessWidget {
  final String title;
  final String content;
  final BuildContext context;
  final OnLinkTap onLinkTap;
  final String actionUrl;

  Announcement(
      {this.title, this.content, this.context, this.onLinkTap, this.actionUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xffFFF3CC), borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Image.asset('${Environment.imageAssets}intersect.png', width: 73),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato),
                  ),
                  SizedBox(height: 10),
                  actionUrl != null && actionUrl.isNotEmpty
                      ? RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: content,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                  fontFamily: FontsFamily.lato),
                            ),
                            TextSpan(
                                text: Dictionary.moreDetail,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    height: 1.5,
                                    color: ColorBase.green,
                                    fontFamily: FontsFamily.lato,
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    openChromeSafariBrowser(url: actionUrl);
                                  })
                          ]),
                        )
                      : Html(
                          data: content,
                          defaultTextStyle: TextStyle(
                              color: Color(0xff828282),
                              height: 1.5,
                              fontSize: 12.0,
                              fontFamily: FontsFamily.lato),
                          customTextAlign: (dom.Node node) {
                            return TextAlign.justify;
                          },
                          onLinkTap: onLinkTap)
                ]),
          ),
        ],
      ),
    );
  }
}
