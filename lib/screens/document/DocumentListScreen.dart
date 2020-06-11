import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/document/DocumentServices.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

import 'DocumentViewScreen.dart';

class DocumentListScreen extends StatefulWidget {
  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.document);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.document),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Collections.documents)
            .orderBy('published_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> data = [];

            snapshot.data.documents.forEach((record) {
              if (record['published']) {
                data.add(record);
              }
            });

            if (data.isNotEmpty) {
              return _buildContent(data);
            } else {
              return EmptyData(message: Dictionary.emptyDataDocuments);
            }
          } else {
            return _buildLoading();
          }
        },
      ),
    );
    //   body:
  }

  Widget _buildContent(List<DocumentSnapshot> dataDocuments) {
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Row(
              children: <Widget>[
                SizedBox(width: 20),
                Text(
                  Dictionary.date,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 45),
                Text(
                  Dictionary.titleDocument,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Container()
              ],
            ),
          ),
          ListView.builder(
              padding: const EdgeInsets.only(
                   bottom: 16.0, top: 10.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataDocuments.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = dataDocuments[index];

                return Container(
                    child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            unixTimeStampToDateDocs(
                                document['published_at'].seconds),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Platform.isAndroid
                                    ? _downloadAttachment(document['title'],
                                    document['document_url'])
                                    : _viewPdf(document['title'],
                                    document['document_url']);
                              },
                              child: Text(
                                document['title'],
                                style: TextStyle(
                                    color: Colors.lightBlueAccent[700],
                                    decoration: TextDecoration.underline,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.share,
                                  size: 17, color: Color(0xFF27AE60)),
                              onPressed: () {
                                DocumentServices().shareDocument(
                                    document['title'], document['document_url']);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: SizedBox(
                        height: 10,
                        child: Container(
                          color: Colors.grey[200],
                        ),
                      ),
                    )
                  ],
                ));
              })
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Skeleton(
            height: 25.0,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 9,
            itemBuilder: (context, index) {
              return Container(
                  child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Skeleton(
                        height: 20.0,
                        width: 40,
                        padding: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Skeleton(
                                height: 20.0,
                                width: MediaQuery.of(context).size.width / 1.6,
                                padding: 10.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Skeleton(
                          height: 30.0,
                          width: 30.0,
                          padding: 10.0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Skeleton(
                      height: 1.5,
                      width: MediaQuery.of(context).size.width,
                      padding: 10.0,
                    ),
                  )
                ],
              ));
            })
      ],
    );
  }

  void _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(Analytics.openDocument, <String, dynamic>{
      'name_document': title.length < 100 ? title : title.substring(0, 100),
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
//      Fluttertoast.showToast(
//          msg: Dictionary.downloadingFile,
//          toastLength: Toast.LENGTH_LONG,
//          gravity: ToastGravity.BOTTOM,
//          fontSize: 16.0);

//      name = name.replaceAll(RegExp(r"\|.*"), '').trim() + '.pdf';
//
//      try {
//        await FlutterDownloader.enqueue(
//          url: url,
//          savedDir: Environment.downloadStorage,
//          fileName: name,
//          showNotification: true,
//          // show download progress in status bar (for Android)
//          openFileFromNotification:
//              true, // click on notification to open downloaded file (for Android)
//        );
//      } catch (e) {
//        String dir = (await getExternalStorageDirectory()).path + '/download';
//        await FlutterDownloader.enqueue(
//          url: url,
//          savedDir: dir,
//          fileName: name,
//          showNotification: true,
//          // show download progress in status bar (for Android)
//          openFileFromNotification:
//              true, // click on notification to open downloaded file (for Android)
//        );
//      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentViewScreen(
            url: url,
            nameFile: name,
          ),
        ),
      );

      await AnalyticsHelper.setLogEvent(
          Analytics.tappedDownloadDocuments, <String, dynamic>{
        'name_document': name.length < 100 ? name : name.substring(0, 100),
      });
    }
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
  }
}
