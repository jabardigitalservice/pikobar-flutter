import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:html/dom.dart' as dom;

class Announcement extends StatelessWidget {
  final String title;
  final String content;

  Announcement({this.title, this.content});

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
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato),
                  ),
                  SizedBox(height: 15),
                  Html(
                      data:content,
                      defaultTextStyle: TextStyle(
                          color: Color(0xff828282),
                          fontSize: 10.0,
                          fontFamily: FontsFamily.lato),
                      customTextAlign: (dom.Node node) {
                        return TextAlign.justify;
                      },
                      onLinkTap: (url) {
//                        _launchURL(
//                            url,
//                            dataAnnouncement[i]['title'] != null
//                                ? dataAnnouncement[i]['title']
//                                : Dictionary.titleInfoTextAnnouncement);
                      }),
                ]),
          ),
        ],
      ),
    );
  }

}
