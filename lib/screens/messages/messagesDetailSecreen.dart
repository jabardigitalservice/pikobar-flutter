import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart' as fShare;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:pikobar_flutter/blocs/messages/messageDetil/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:share/share.dart';

class MessageDetailScreen extends StatefulWidget {
  final String id;

  MessageDetailScreen({this.id});

  @override
  _MessageDetailScreenState createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  MessageDetailBloc _messageDetailBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageDetailBloc>(
      create: (context) => _messageDetailBloc = MessageDetailBloc()
        ..add(MessageDetailLoad(messageId: widget.id)),
      child: BlocBuilder<MessageDetailBloc, MessageDetailState>(
          builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
                title: CustomAppBar.setTitleAppBar(Dictionary.message),
                actions: <Widget>[
                  state is MessageDetailLoaded
                      ? Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: IconButton(
                            icon: Icon(FontAwesomeIcons.solidShareSquare,
                                size: 17, color: Colors.white),
                            onPressed: () {
                              _shareMessage(state.data);
                            },
                          ))
                      : Container()
                ]),
            body: state is MessageDetailLoading
                ? _buildLoading(context)
                : state is MessageDetailLoaded
                    ? _buildContent(context, state.data)
                    : Container());
      }),
    );
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
              unixTimeStampToDateTime(data.publishedAt),
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
                _launchUrl(url);
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
        data.actionTitle != null && data.actionUrl != null
            ? RoundedButton(
                title: data.actionTitle,
                color: ColorBase.green,
                textStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                onPressed: () {
                  _launchUrl(data.actionUrl);
                })
            : Container()
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

  _shareMessage(MessageModel data) async {
    Uint8List bytes = await _bytesImageFromHtmlString(data.content);

    if (bytes != null) {
      try {
        await fShare.Share.file(
            Dictionary.appName, '${data.id}.jpg', bytes, 'image/jpg',
            text: '${data.title}\n\n'
                '${data.backLink != null ? 'Baca pesan lengkapnya:\n' + data.backLink.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
                '${Dictionary.sharedFrom}');
      } catch (e) {
        Share.share('${data.title}\n\n'
            '${data.backLink != null ? 'Baca pesan lengkapnya:\n' + data.backLink.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
            '${Dictionary.sharedFrom}');
      }
    } else {
      Share.share('${data.title}\n\n'
          '${data.backLink != null ? 'Baca pesan lengkapnya:\n' + data.backLink.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
          '${Dictionary.sharedFrom}');
    }

    AnalyticsHelper.setLogEvent(Analytics.tappedShareNewsFromMessage,
        <String, dynamic>{'title': data.title});
  }

  _bytesImageFromHtmlString(String htmlString) async {
    try {
      var document = parse(htmlString);
      String urlImage =
          document.getElementsByTagName('img')[0].attributes['src'];
      var request = await HttpClient().getUrl(Uri.parse(urlImage));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      return bytes;
    } catch (e) {
      print(e);
      return null;
    }
  }

  _launchUrl(String url) async {
    List<String> items = [
      '_googleIDToken_',
      '_userUID_',
      '_userName_',
      '_userEmail_'
    ];
    if (StringUtils.containsWords(url, items)) {
      bool hasToken = await AuthRepository().hasToken();
      if (!hasToken) {
        bool isLoggedIn = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));

        if (isLoggedIn != null && isLoggedIn) {
          url = await userDataUrlAppend(url);

          openChromeSafariBrowser(url: url);
        }
      } else {
        url = await userDataUrlAppend(url);
        openChromeSafariBrowser(url: url);
      }
    } else {
      openChromeSafariBrowser(url: url);
    }
  }

  @override
  void dispose() {
    _messageDetailBloc.close();
    super.dispose();
  }
}
