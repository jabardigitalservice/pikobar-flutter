import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class Announcement extends StatelessWidget {
  final String title;
  final String content;
  final BuildContext context;
  final OnTap onLinkTap;
  final String actionUrl;
  final TextStyle textStyleTitle;
  final TextStyle textStyleContent;
  final TextStyle textStyleMoreDetail;
  final Style htmlStyle;

  Announcement(
      {this.title,
      this.content,
      this.context,
      this.onLinkTap,
      this.actionUrl,
      this.textStyleTitle,
      this.textStyleContent,
      this.textStyleMoreDetail,
      this.htmlStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
      decoration: BoxDecoration(
          color: ColorBase.announcementBackgroundColor,
          borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Image.asset('${Environment.imageAssets}intersect.png', width: 73),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ///Set Text title section
                  title != null && title.isNotEmpty
                      ? Text(
                          title,
                          style: textStyleTitle != null
                              ? textStyleTitle
                              : TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.lato),
                        )
                      : Container(),
                  title != null && title.isNotEmpty
                      ? SizedBox(height: 10)
                      : Container(),

                  ///Set Text content & url if actionUrl is not empty
                  actionUrl != null && actionUrl.isNotEmpty
                      ? RichText(
                          text: TextSpan(children: [
                            /// Set Text content section
                            TextSpan(
                              text: content,
                              style: textStyleContent != null
                                  ? textStyleContent
                                  : TextStyle(
                                      fontSize: 12.0,
                                      height: 1.4,
                                      color: Colors.grey[600],
                                      fontFamily: FontsFamily.lato),
                            ),

                            /// Set Text url section
                            TextSpan(
                                text: Dictionary.moreDetail,
                                style: textStyleMoreDetail != null
                                    ? textStyleMoreDetail
                                    : TextStyle(
                                        fontSize: 12.0,
                                        height: 1.4,
                                        color: ColorBase.green,
                                        fontFamily: FontsFamily.lato,
                                        fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    AnalyticsHelper.setLogEvent(Analytics.announcement);
                                    openChromeSafariBrowser(url: actionUrl);
                                  })
                          ]),
                        )

                      ///Set Text content if actionUrl is empty
                      : Html(
                          data: content,
                          style: {
                            'body': htmlStyle != null ? htmlStyle : Style(
                                margin: EdgeInsets.zero,
                                color: Colors.grey[600],
                                fontSize: FontSize(12.0),
                                fontFamily: FontsFamily.lato,
                                textAlign: TextAlign.justify),
                          },
                          onLinkTap: onLinkTap)
                ]),
          ),
        ],
      ),
    );
  }
}
