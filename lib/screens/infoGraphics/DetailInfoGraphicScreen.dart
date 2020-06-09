import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
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

  List<String> getDataUrl() {
    List<String> dataUrl = [];
    for (int i = 0; i < widget.dataInfoGraphic.data['images'].length; i++) {
      dataUrl.add(widget.dataInfoGraphic.data['images'][i]);
    }
    return dataUrl;
  }

  @override
  Widget build(BuildContext context) {
    List<String> dataUrl = getDataUrl();
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.infoGraphics),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CarouselSlider(
                  initialPage: 0,
                  enableInfiniteScroll: dataUrl.length > 1 ? true : false,
                  aspectRatio: 9 / 9,
                  viewportFraction: 1.0,
                  autoPlay: dataUrl.length > 1 ? true : false,
                  autoPlayInterval: Duration(seconds: 5),
                  items: dataUrl.map((String data) {
                    return Builder(builder: (BuildContext context) {
                      return GestureDetector(
                        child: Container(
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
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
                  child: Row(
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
                Container(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        unixTimeStampToDateTime(widget
                            .dataInfoGraphic['published_date'].seconds),
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: FontsFamily.lato,
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
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           Expanded(
                             child:  Text(
                              widget.dataInfoGraphic['title'],
                               style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontFamily: FontsFamily.lato,
                               ),
                               textAlign: TextAlign.left,
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                             ),
                           ),
                            Container(
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                alignment: Alignment.topRight,
                                icon: Icon(FontAwesomeIcons.share,
                                    size: 17, color: Color(0xFF27AE60)),
                                onPressed: () {
                                  InfoGraphicsServices()
                                      .shareInfoGraphics(
                                      widget
                                          .dataInfoGraphic['title'],
                                      widget.dataInfoGraphic[
                                      'images']);
                                },
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: RoundedButton(
                      borderRadius: BorderRadius.circular(10.0),
                      title: Dictionary.downloadImage,
                      color: ColorBase.green,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato,
                      ),
                      onPressed: () {
                        Platform.isAndroid
                            ? _downloadAttachment(
                                widget.dataInfoGraphic['title'],
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
}
