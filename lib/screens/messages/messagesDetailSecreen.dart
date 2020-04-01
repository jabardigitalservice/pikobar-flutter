import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:html/dom.dart' as dom;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageDetailScreen extends StatefulWidget {
  final MessageModel document;
  final String id;
  final bool isFromNotification;

  MessageDetailScreen(
      {this.document, this.id, this.isFromNotification = false});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  MessageModel _document;
  String _title = '';
  String _backLink = '';
  bool _isLoaded = false;

  @override
  void initState() {
    _document = widget.document;

    if (_document != null) {
      _isLoaded = true;
      _title = widget.document.title;
      _backLink = widget.document.title;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: CustomAppBar.setTitleAppBar(Dictionary.message), actions: <Widget>[
          _isLoaded
              ? Container(
                  margin: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      Share.share(
                          '$_title\n${_backLink != null ? _backLink + '\n' : ''}\nBaca Selengkapnya di aplikasi Pikobar : ${UrlThirdParty.pathPlaystore}');
                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedShareNewsFromMessage,
                          <String, dynamic>{'title': widget.document.title});
                    },
                  ))
              : Container()
        ]),
        body: Container(
          child: _document == null
              ? FutureBuilder<DocumentSnapshot>(
                  future: Firestore.instance
                      .collection('broadcasts')
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
                        _document = MessageModel(
                            backlink: snapshot.data['backlink'],
                            title: snapshot.data['title'],
                            pubilshedAt: snapshot.data['published_at'],
                            readAt: 100);
                        _isLoaded = true;
                        _title = snapshot.data['title'];
                        _backLink = snapshot.data['backlink'] != null
                            ? snapshot.data['backlink']
                            : '';

                        if (widget.isFromNotification) {
                          SchedulerBinding.instance
                              .addPostFrameCallback((_) => setState(() {}));
                        }

                        return _buildContent(context, _document);
                      } else {
                        return _buildLoading(context);
                      }
                    }
                  })
              : _buildContent(context, _document),
        ));
  }

  _buildLoading(BuildContext context) {
    return Skeleton(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 20.0,
              color: Colors.grey,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              width: MediaQuery.of(context).size.width / 3,
              height: 10.0,
              color: Colors.grey,
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              color: Colors.grey,
            ),
            SizedBox(height: 10.0),
            _loadingText(),
            SizedBox(height: 10.0),
            _loadingText(),
          ],
        ),
      ),
    );
  }

  _loadingText() {
    List<Widget> widgets = [];

    for (int i = 0; i < 4; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        height: 18.0,
        color: Colors.grey,
      ));
    }

    widgets.add(Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: MediaQuery.of(context).size.width / 2,
      height: 18.0,
      color: Colors.grey,
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  _buildContent(BuildContext context, MessageModel data) {
    return ListView(
      padding: EdgeInsets.all(Dimens.padding),
      children: <Widget>[
        _buildText(
            Text(
              data.title,
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            context),
        _buildText(
            Text(
              unixTimeStampToDateTime(data.pubilshedAt),
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
            context),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 6, bottom: Dimens.padding),
          child: Html(
              data: data.content,
              defaultTextStyle: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14.0,
                  fontFamily: FontsFamily.productSans),
              customTextAlign: (dom.Node node) {
                return TextAlign.left;
              },
              onLinkTap: (url) {
                _launchURL(url);
              },
              customTextStyle: (dom.Node node, TextStyle baseStyle) {
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "p":
                      return baseStyle.merge(TextStyle(height: 1.3));
                  }
                }
                return baseStyle;
              }),
        ),
        SizedBox(
          height: Dimens.sbHeight,
        ),
      ],
    );
  }

  _buildText(Text text, context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 10.0),
      child: text,
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
