import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  final String id;
  final DocumentSnapshot documents;
  final String news;
  final bool isFromNotification;

  NewsDetailScreen({this.id, this.documents, this.news, this.isFromNotification = false});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {

  DocumentSnapshot _document;
  String _newsType;
  String _title = '';
  String _backLink = '';
  bool _isLoaded = false;


  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.news);

    _document = widget.documents;

    if (widget.news == Dictionary.worldNews) {
      _newsType = NewsType.articlesWorld;
    } else if (widget.news == Dictionary.nationalNews) {
      _newsType = NewsType.articlesNational;
    } else {
      _newsType = NewsType.articles;
    }

    if (_document != null) {
      _isLoaded = true;
      _title = widget.documents['title'];
      _backLink = widget.documents['backlink'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: CustomAppBar.setTitleAppBar(Dictionary.news),
            actions: <Widget>[
              _isLoaded ? Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.solidShareSquare, size: 17, color: Colors.white),
                    onPressed: () {
                      Share.share(
                          '$_title\n\n${_backLink != null ? 'Baca berita lengkapnya:\n'+_backLink : ''}\n\n${Dictionary.sharedFrom}');
                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedShareNews, <String, dynamic>{
                        'title': widget.documents['title']
                      });
                    },
                  )) : Container()
            ]),
        body: Container(
          child: _document == null ? FutureBuilder<DocumentSnapshot>(
              future: Firestore.instance
                  .collection(_newsType)
                  .document(widget.id)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoading(context);
                } else {
                  if (snapshot.data.data != null) {
                    _document = snapshot.data;
                    _isLoaded = true;
                    _title = snapshot.data['title'];
                    _backLink = snapshot.data['backlink'] != null ? snapshot.data['backlink'] : '';

                    if (widget.isFromNotification) {
                      SchedulerBinding.instance.addPostFrameCallback((_) =>
                          setState(() {}));
                    }
                    return _buildContent(context, _document);
                  } else {
                    return _buildLoading(context);
                  }
                }
              }) : _buildContent(context, _document),
        ));
  }

  _buildLoading(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Skeleton(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Colors.grey,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4.0),
                                  width: 150.0,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                              ]),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    _loadingText(),
                    SizedBox(height: 10.0),
                    _loadingText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadingText() {
    List<Widget> widgets = [];

    for(int i=0; i<4; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 18.0,
        color: Colors.grey,
      ));
    }

    widgets.add(Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: MediaQuery
          .of(context)
          .size
          .width / 2,
      height: 18.0,
      color: Colors.grey,
    ));

    return Column( crossAxisAlignment: CrossAxisAlignment.start,children: widgets);
  }

  _buildContent(BuildContext context, DocumentSnapshot data) {
    return SingleChildScrollView(
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
                    imageUrl: data['image'],
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2, child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        height: MediaQuery.of(context).size.height / 3.3,
                        color: Colors.grey[200],
                        child: Image.asset('${Environment.iconAssets}pikobar.png',
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
                              imageUrl: data['image'],
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
                    data['title'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Image.network(
                        data['news_channel_icon'],
                        width: 25.0,
                        height: 25.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['news_channel'],
                                style: TextStyle(fontSize: 12.0),
                              ),
                              Text(
                                  unixTimeStampToDateTime(
                                      data['published_at'].seconds),
                                  style: TextStyle(fontSize: 12.0))
                            ]),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Html(
                      data: data['content'],
                      defaultTextStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      customTextAlign: (dom.Node node) {
                        return TextAlign.left;
                      },
                      onLinkTap: (url) {
                        _launchURL(url);
                      })
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
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
                                builder: (context) => News(news: widget.news)));
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
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
