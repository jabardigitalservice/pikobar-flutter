import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/rich_text_parser.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class Announcement extends StatelessWidget {
  final String title;
  final String content;
  final BuildContext context;
  final OnLinkTap onLinkTap;
  final String actionUrl;
  final TextStyle textStyleTitle;
  final TextStyle textStyleContent;
  final TextStyle textStyleMoreDetail;

  Announcement(
      {this.title,
      this.content,
      this.context,
      this.onLinkTap,
      this.actionUrl,
      this.textStyleTitle,
      this.textStyleContent,
      this.textStyleMoreDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
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
                  actionUrl != null && actionUrl.isNotEmpty
                      ? RichText(
                          text: TextSpan(children: [
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
                                    openChromeSafariBrowser(url: actionUrl);
                                  })
                          ]),
                        )
                      : Html(
                          data: content,
                          defaultTextStyle: textStyleContent != null
                              ? textStyleContent
                              : TextStyle(
                                  color: Colors.grey[600],
                                  height: 1.4,
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
