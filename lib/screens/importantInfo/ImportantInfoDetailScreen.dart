import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantDetail/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pedantic/pedantic.dart';

class ImportantInfoDetailScreen extends StatefulWidget {
  final String id;

  ImportantInfoDetailScreen({this.id});

  @override
  _ImportantInfoDetailScreenState createState() =>
      _ImportantInfoDetailScreenState();
}

class _ImportantInfoDetailScreenState extends State<ImportantInfoDetailScreen> {
  ImportantInfoDetailBloc _importantInfoDetailBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.tappedImportantInfoDetail);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportantInfoDetailBloc>(
      create: (context) => _importantInfoDetailBloc = ImportantInfoDetailBloc()
        ..add(ImportantInfoDetailLoad(importantInfoId: widget.id)),
      child: BlocBuilder<ImportantInfoDetailBloc, importantInfoDetailState>(
        bloc: _importantInfoDetailBloc,
        builder: (context, state) {
          return _buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold _buildScaffold(
      BuildContext context, importantInfoDetailState state) {
    return Scaffold(
        appBar: AppBar(
          title: CustomAppBar.setTitleAppBar(Dictionary.importantInfo),
//            actions: <Widget>[
//              state is ImportantInfoDetailLoaded
//                  ? Container(
//                      margin: EdgeInsets.only(right: 10.0),
//                      child: IconButton(
//                        icon: Icon(FontAwesomeIcons.solidShareSquare,
//                            size: 17, color: Colors.white),
//                        onPressed: () {
//                          Share.share(
//                              '${state.record.title}\n\n${state.record.actionUrl != null ? 'Baca lengkapnya:\n' + state.record.actionUrl : ''}\n\n${Dictionary.sharedFrom}');
//                          AnalyticsHelper.setLogEvent(
//                              Analytics.tappedImportantInfoDetailShare,
//                              <String, dynamic>{'title': state.record.title});
//                        },
//                      ))
//                  :
//              Container()
//            ]
        ),
        body: state is ImportantInfoDetailLoading
            ? _buildLoading(context)
            : state is ImportantInfoDetailLoaded
                ? _buildContent(context, state.record)
                : Container());
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

  _buildContent(BuildContext context, ImportantinfoModel data) {
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
                    imageUrl: data.image,
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
                              imageUrl: data.image,
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
                    data.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
//                  Row(
//                    children: <Widget>[
//                      Image.network(
//                        data.newsChannelIcon,
//                        width: 25.0,
//                        height: 25.0,
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(left: 5.0),
//                        child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                data.newsChannel,
//                                style: TextStyle(fontSize: 12.0),
//                              ),
//                              Text(
//                                  unixTimeStampToDateTime(
//                                      data.publishedAt),
//                                  style: TextStyle(fontSize: 12.0))
//                            ]),
//                      )
//                    ],
//                  ),
                  SizedBox(height: 10.0),
                  Html(
                      data: data.content,
                      defaultTextStyle:
                          TextStyle(color: Colors.black, fontSize: 15.0),
                      customTextAlign: (dom.Node node) {
                        return TextAlign.left;
                      },
                      onLinkTap: (url) {
                        _launchURL(url);
                      }),
                  SizedBox(height: 10.0),

                  data.actionTitle != null && data.actionUrl != null
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
                                      fontFamily: FontsFamily.productSans,
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
                                        fontFamily: FontsFamily.productSans,
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
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  _launchURL(String url) async {
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

  void _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(
        Analytics.openFileImportantInfo, <String, dynamic>{
      'name_document': title.length < 100 ? title : title.substring(0, 100),
    });
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
  }
}
