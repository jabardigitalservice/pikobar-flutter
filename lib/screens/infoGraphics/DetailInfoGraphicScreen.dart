import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/infoGraphicsServices.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pedantic/pedantic.dart';

// ignore: must_be_immutable
class DetailInfoGraphicScreen extends StatefulWidget {
  DocumentSnapshot dataInfoGraphic;

  DetailInfoGraphicScreen({this.dataInfoGraphic});

  @override
  _DetailInfoGraphicScreenState createState() =>
      _DetailInfoGraphicScreenState();
}

class _DetailInfoGraphicScreenState extends State<DetailInfoGraphicScreen> {
  int _current = 0;
  ScrollController _scrollController;
  bool lastStatus = true;

  List<String> getDataUrl() {
    List<String> dataUrl = [];
    for (int i = 0; i < widget.dataInfoGraphic.get('images').length; i++) {
      dataUrl.add(widget.dataInfoGraphic.get('images')[i]);
    }
    return dataUrl;
  }

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
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> dataUrl = getDataUrl();
    return Scaffold(
        body: CollapsingAppbar(
      scrollController: _scrollController,
      heightAppbar: 310.0,
      showTitle: isShrink,
      isBottomAppbar: false,
      actionsAppBar: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: isShrink ? Colors.black : Colors.white,
          ),
          onPressed: () {
            InfoGraphicsServices().shareInfoGraphics(
                widget.dataInfoGraphic['title'],
                widget.dataInfoGraphic['images']);
          },
        )
      ],
      titleAppbar: Dictionary.infoGraphics,
      backgroundAppBar: Column(
        children: [
          Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider(
              options: CarouselOptions(
                initialPage: 0,
                enableInfiniteScroll: dataUrl.length > 1 ? true : false,
                aspectRatio: 9 / 9,
                viewportFraction: 1.0,
                autoPlay: dataUrl.length > 1 ? true : false,
                autoPlayInterval: Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: dataUrl.map((String data) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            child: CachedNetworkImage(
                                imageUrl: data ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) => Center(
                                    heightFactor: 10.2,
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0)),
                                    ),
                                    child: PikobarPlaceholder())),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(0.2),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.circular(Dimens.dialogRadius),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (data.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HeroImagePreview(
                                Dictionary.heroImageTag,
                                galleryItems: dataUrl,
                              ),
                            ));
                      }
                    },
                  );
                });
              }).toList(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dataUrl.map((String data) {
                int index = dataUrl.indexOf(data);
                return _current == index
                    ? Container(
                        width: 24.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30.0),
                            color: ColorBase.green))
                    : Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
              }).toList(),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    unixTimeStampToDateTime(
                        widget.dataInfoGraphic['published_date'].seconds),
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: FontsFamily.roboto,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.dataInfoGraphic['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto,
                            ),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),
                ],
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 195, left: 16, right: 16, bottom: 16),
              child: RoundedButton(
                  borderRadius: BorderRadius.circular(10.0),
                  title: Dictionary.downloadImage,
                  color: ColorBase.green,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto,
                  ),
                  onPressed: () {
                    Platform.isAndroid
                        ? _downloadAttachment(widget.dataInfoGraphic['title'],
                            widget.dataInfoGraphic['images'][_current])
                        : _viewPdf(widget.dataInfoGraphic['title'],
                            widget.dataInfoGraphic['images'][_current]);
                  }),
            )
          ],
        ),
      ),
    ));
  }

  void _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(Analytics.openImage, <String, dynamic>{
      'name_image': title.length < 100 ? title : title.substring(0, 100),
    });
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

      name = name.replaceAll(RegExp(r"\|.*"), '').trim() + '.jpg';

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
          Analytics.tappedDownloadImage, <String, dynamic>{
        'name_image': name.length < 100 ? name : name.substring(0, 100),
      });
    }
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
