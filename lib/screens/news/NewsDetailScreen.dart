import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/news/newsDetail/Bloc.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pedantic/pedantic.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart' as fShare;

// ignore: must_be_immutable
class NewsDetailScreen extends StatefulWidget {
  final String id;
  final String news;
  final NewsModel model;

  NewsDetailScreen({Key key, this.id, this.news, this.model}) : super(key: key);

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  // ignore: close_sinks, unused_field
  NewsDetailBloc _newsDetailBloc;
  String _newsType;
  ScrollController _scrollController;
  bool lastStatus = true;
  bool isUpdateData = true;
  NewsModel dataNews;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.news);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    dataNews = widget.model;

    if (widget.news == Dictionary.importantInfo) {
      _newsType = NewsType.articlesImportantInfo;
    } else if (widget.news == Dictionary.worldNews) {
      _newsType = NewsType.articlesWorld;
    } else if (widget.news == Dictionary.nationalNews) {
      _newsType = NewsType.articlesNational;
    } else {
      _newsType = NewsType.articles;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsDetailBloc>(
        create: (context) => _newsDetailBloc = NewsDetailBloc()
          ..add(NewsDetailLoad(newsCollection: _newsType, newsId: widget.id)),
        child: BlocListener<NewsDetailBloc, NewsDetailState>(
            listener: (context, state) {
              if (state is NewsDetailLoaded) {
                setState(() {
                  dataNews = state.record;
                });
              }
            }, child: BlocBuilder<NewsDetailBloc, NewsDetailState>(
          builder: (context, state) {
            return _buildScaffold(context, state);
          },
        )));
  }

  Scaffold _buildScaffold(BuildContext context, NewsDetailState state) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CollapsingAppbar(
          scrollController: _scrollController,
          heightAppbar: 300.0,
          showTitle: isShrink,
          isBottomAppbar: false,
          actionsAppBar: [
            IconButton(
              icon: Icon(
                Icons.share,
                color: isShrink ? Colors.black : Colors.white,
              ),
              onPressed: () {
                if (dataNews != null) {
                  widget.news == Dictionary.importantInfo
                      ? _shareMessage(dataNews)
                      : Share.share(
                      '${dataNews.title}\n\n${dataNews.backlink != null ? 'Baca berita lengkapnya:\n' + dataNews.backlink : ''}\n\n${Dictionary.sharedFrom}');
                  AnalyticsHelper.setLogEvent(Analytics.tappedShareNews,
                      <String, dynamic>{'title': dataNews.title});
                }
              },
            )
          ],
          titleAppbar: dataNews != null ? dataNews.title : '',
          backgroundAppBar: GestureDetector(
            child: Hero(
                tag: Dictionary.heroImageTag,
                child: Stack(
                  children: [
                    Image.network(
                      dataNews != null ? dataNews.image : '',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ),
                    Container(
                      color: Colors.black12.withOpacity(0.2),
                    )
                  ],
                )),
            onTap: () {
              if (dataNews != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HeroImagePreview(
                          Dictionary.heroImageTag,
                          imageUrl: dataNews.image,
                        )));
              }
            },
          ),
          body: dataNews == null
              ? state is NewsDetailLoading
              ? _buildLoading(context)
              : state is NewsDetailLoaded
              ? _buildContent(context, state.record)
              : state is NewsDetailFailure
              ? ErrorContent(error: state.error)
              : Container()
              : _buildContent(context, dataNews),
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

  _buildContent(BuildContext context, NewsModel data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 5.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _newsType != NewsType.articlesImportantInfo &&
                                      data.newsChannel.isNotEmpty
                                      ? Text(
                                      unixTimeStampToDateTime(
                                          data.publishedAt) +
                                          ' • ' +
                                          data.newsChannel,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: FontsFamily.roboto))
                                      : Container()
                                ]),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      data.title,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontFamily: FontsFamily.roboto,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Html(
                      data: data.content,
                      style: {
                        'body': Style(
                            color: Colors.black,
                            fontSize: FontSize(14.0),
                            textAlign: TextAlign.start),
                      },
                      onLinkTap: (url) {
                        _launchURL(url);
                      })
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 20.0, top: 15.0, right: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  data.actionTitle != null &&
                      data.actionTitle.isNotEmpty &&
                      data.actionUrl != null &&
                      data.actionUrl.isNotEmpty
                      ? RoundedButton(
                      title: data.actionTitle,
                      color: ColorBase.green,
                      textStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      onPressed: () {
                        _launchURL(data.actionUrl);
                      })
                      : Container(),
                  data.attachmentUrl.isNotEmpty
                      ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1.0,
                    color: Colors.grey,
                    margin: EdgeInsets.only(top: 25.0, bottom: 16.0),
                  )
                      : Container(),
                  data.attachmentUrl.isNotEmpty
                      ? Row(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        child: Text(data.attachmentName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: FontsFamily.roboto,
                                color: Colors.grey[800])),
                      ),
                      ButtonTheme(
                        minWidth: 129.0,
                        height: 34.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: RaisedButton(
                          color: ColorBase.green,
                          highlightElevation: 5,
                          child: Text(Dictionary.downloadAttachment,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: FontsFamily.roboto,
                                  color: Colors.white)),
                          onPressed: () {
                            Platform.isAndroid
                                ? _downloadAttachment(data.attachmentName,
                                data.attachmentUrl)
                                : _viewPdf(data.attachmentName,
                                data.attachmentUrl);
                          },
                        ),
                      )
                    ],
                  )
                      : Container(),
                  SizedBox(height: 25.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
  }

  void _downloadAttachment(String name, String url) async {
    if (!await Permission.storage.status.isGranted) {
      unawaited(showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
            image: Image.asset(
              'assets/icons/folder.png',
              fit: BoxFit.contain,
              color: Colors.white,
            ),
            description: Dictionary.permissionDownloadAttachment,
            onOkPressed: () {
              Navigator.of(context).pop();
              Permission.storage.request().then((val) {
                _onStatusRequested(val, name, url);
              });
            },
          )));
    } else {
      Fluttertoast.showToast(
          msg: Dictionary.downloadingFile,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);

      name = name.replaceAll(RegExp(r"\|.*"), '').trim() + '.pdf';

      try {
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: Environment.downloadStorage,
          fileName: name,
          showNotification: true,
          // show download progress in status bar (for Android)
          openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
        );
      } catch (e) {
        String dir = (await getExternalStorageDirectory()).path + '/download';
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: dir,
          fileName: name,
          showNotification: true,
          // show download progress in status bar (for Android)
          openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
        );
      }

      await AnalyticsHelper.setLogEvent(
          Analytics.tappedDownloadImportantInfo, <String, dynamic>{
        'name_document': name.length < 100 ? name : name.substring(0, 100),
      });
    }
  }

  void _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(
        Analytics.openFileImportantInfo, <String, dynamic>{
      'name_document': title.length < 100 ? title : title.substring(0, 100),
    });
  }

  void _shareMessage(NewsModel data) async {
    String content = await stringFromHtmlString(data.content);
    if (data.image != null) {
      try {
        blockCircleLoading(context: context, dismissible: true);

        var request = await HttpClient().getUrl(Uri.parse(data.image));
        var response = await request.close();
        Uint8List bytes = await consolidateHttpClientResponseBytes(response);

        Navigator.of(context).pop();

        await fShare.Share.file(
            Dictionary.appName, '${data.id}.jpg', bytes, 'image/jpg',
            text: '${data.title}\n\n'
                '$content\n\n'
                '${data.actionUrl != null ? data.actionTitle + ':\n' + data.actionUrl.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
                '${Dictionary.sharedFrom}');
      } catch (e) {
        Share.share('${data.title}\n\n'
            '$content\n\n'
            '${data.actionUrl != null ? data.actionTitle + ':\n' + data.actionUrl.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
            '${Dictionary.sharedFrom}');
      }
    } else {
      Share.share('${data.title}\n\n'
          '$content\n\n'
          '${data.actionUrl != null ? data.actionTitle + ':\n' + data.actionUrl.replaceAll(new RegExp(r"\s+\b|\b\s"), "") : ''}\n\n'
          '${Dictionary.sharedFrom}');
    }

    AnalyticsHelper.setLogEvent(
        Analytics.tappedImportantInfoDetailShare, <String, dynamic>{
      'title':
      data.title.length < 100 ? data.title : data.title.substring(0, 100)
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}