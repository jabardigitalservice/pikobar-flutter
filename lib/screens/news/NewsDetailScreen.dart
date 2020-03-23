import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:html/dom.dart' as dom;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NewsDetailScreen extends StatefulWidget {
  final DocumentSnapshot documents;
  final String news;

  NewsDetailScreen({this.documents, this.news});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.news);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          Dictionary.news,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.productSans,
              fontSize: 17.0),
        ), actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  Share.share(
                      '${widget.documents['title']}\nBaca Selengkapnya di aplikasi Pikobar: ${UrlThirdParty.pathPlaystore}');
                  AnalyticsHelper.setLogEvent(
                      Analytics.tappedShareNews, <String, dynamic>{
                    'title': widget.documents['title']
                  });
                },
              ))
        ]),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Hero(
                      tag: Dictionary.heroImageTag,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey,
                        child: CachedNetworkImage(
                          imageUrl: widget.documents['image'],
                          placeholder: (context, url) => Center(
                              heightFactor: 10.2,
                              child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => Container(
                              height: MediaQuery.of(context).size.height / 3.3,
                              color: Colors.grey[200],
                              child: Image.asset(
                                  '${Environment.iconAssets}pikobar.png',
                                  fit: BoxFit.fitWidth)),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HeroImagePreview(
                                    Dictionary.heroImageTag,
                                    imageUrl: widget.documents['image'],
                                  )));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.documents['title'],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Image.network(
                              widget.documents['news_channel_icon'],
                              width: 25.0,
                              height: 25.0,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.documents['news_channel'],
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                    Text(
                                        unixTimeStampToDateTime(widget
                                            .documents['published_at'].seconds),
                                        style: TextStyle(fontSize: 12.0))
                                  ]),
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Html(
                            data: widget.documents['content'],
                            defaultTextStyle:
                                TextStyle(color: Colors.black, fontSize: 15.0),
                            customTextAlign: (dom.Node node) {
                              return TextAlign.justify;
                            },
                            onLinkTap: (url) {
                              _launchURL(url);
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 15.0, right: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5.0, bottom: 20.0),
                          child: OutlineButton(
                            borderSide: BorderSide(color: Colors.grey[600]),
                            child: Text(Dictionary.otherNews,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontFamily: FontsFamily.sourceSansPro,
                                    color: Colors.grey[700])),
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          News(news: widget.news)));
                            },
                          ),
                        ),
//                        _latestNews(state),
                        SizedBox(height: 10.0)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
