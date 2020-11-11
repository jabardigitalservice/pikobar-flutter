import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/documents/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/ShareButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/document/DocumentServices.dart';
import 'package:pikobar_flutter/screens/document/DocumentViewScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

class Documents extends StatefulWidget {
  final String searchQuery;

  Documents({this.searchQuery});

  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List<DocumentSnapshot> dataDocuments = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, remoteState) {
        return remoteState is RemoteConfigLoaded
            ? _buildHeader(remoteState.remoteConfig)
            : _buildHeaderLoading();
      },
    );
  }

  Widget _buildHeader(RemoteConfig remoteConfig) {
    Map<String, dynamic> getLabel = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.labels,
        defaultValue: FirebaseConfig.labelsDefaultValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                getLabel['documents']['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.lato,
                    fontSize: Dimens.textTitleSize),
              ),
              InkWell(
                child: Text(
                  Dictionary.more,
                  style: TextStyle(
                      color: ColorBase.green,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.lato,
                      fontSize: Dimens.textSubtitleSize),
                ),
                onTap: () {
                  Navigator.pushNamed(context, NavigationConstrants.Document);

                  AnalyticsHelper.setLogEvent(Analytics.tappedDocumentsMore);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          // child: Text(
          //   getLabel['documents']['description'],
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontFamily: FontsFamily.lato,
          //       fontSize: 12.0),
          //   textAlign: TextAlign.left,
          // ),
        ),
        BlocBuilder<DocumentsBloc, DocumentsState>(
          builder: (context, state) {
            return state is DocumentsLoaded
                ? _buildContent(state.documents)
                : _buildLoading();
          },
        )
      ],
    );
  }

  Widget _buildHeaderLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Dictionary.documents,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.lato,
                    fontSize: 16.0),
              ),
              InkWell(
                child: Text(
                  Dictionary.more,
                  style: TextStyle(
                      color: ColorBase.green,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.lato,
                      fontSize: Dimens.textSubtitleSize),
                ),
                onTap: () {
                  Navigator.pushNamed(context, NavigationConstrants.Document);

                  AnalyticsHelper.setLogEvent(Analytics.tappedDocumentsMore);
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            Dictionary.descDocument,
            style: TextStyle(
                color: Colors.black,
                fontFamily: FontsFamily.lato,
                fontSize: 12.0),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          padding: const EdgeInsets.only(
              left: 11.0, right: 16.0, top: 16.0, bottom: 16.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                width: 150,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 140,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Skeleton(
                          width: MediaQuery.of(context).size.width / 1.4,
                          padding: 10.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Skeleton(
                                  height: 20.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  padding: 10.0,
                                ),
                                SizedBox(height: 8),
                                Skeleton(
                                  height: 20.0,
                                  width: MediaQuery.of(context).size.width / 2,
                                  padding: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget _buildContent(List<DocumentSnapshot> documents) {
    dataDocuments.clear();
    documents.forEach((record) {
      if (record['published'] && dataDocuments.length < 5) {
        dataDocuments.add(record);
      }
    });

    if (widget.searchQuery != null) {
      dataDocuments = dataDocuments
          .where((test) => test['title']
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
    }

    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: dataDocuments.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.searchQuery != null ? dataDocuments.length : 5,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = dataDocuments[index];
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 150,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: 140,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: document['images'] ?? '',
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                  heightFactor: 4.2,
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                color: Colors.grey[200],
                                child: Image.asset(
                                    '${Environment.iconAssets}pikobar.png',
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Platform.isAndroid
                              ? _downloadAttachment(
                                  document['title'], document['document_url'])
                              : _viewPdf(
                                  document['title'], document['document_url']);
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Platform.isAndroid
                                    ? _downloadAttachment(document['title'],
                                        document['document_url'])
                                    : _viewPdf(document['title'],
                                        document['document_url']);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      document['title'],
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: FontsFamily.lato,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            unixTimeStampToDateTime(
                                                document['published_at']
                                                    .seconds),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: FontsFamily.lato,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                );
              })
          : EmptyData(
              message: Dictionary.emptyData,
              desc: '',
              isFlare: false,
              image: "${Environment.imageAssets}not_found.png",
            ),
    );

    // return SingleChildScrollView(
    //   child: ListView(
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     children: <Widget>[
    //       Container(
    //         decoration: BoxDecoration(
    //             color: Colors.grey[200],
    //             border: Border.all(color: Colors.grey[200]),
    //             borderRadius: BorderRadius.circular(8.0)),
    //         padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    //         margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
    //         child: Row(
    //           children: <Widget>[
    //             SizedBox(width: 10),
    //             Container(
    //               width: 85,
    //               child: Text(
    //                 Dictionary.date,
    //                 style: TextStyle(
    //                     color: Colors.black,
    //                     fontSize: 14.0,
    //                     fontFamily: FontsFamily.lato,
    //                     fontWeight: FontWeight.w600),
    //                 textAlign: TextAlign.left,
    //                 maxLines: 2,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ),
    //             Text(
    //               Dictionary.titleDocument,
    //               style: TextStyle(
    //                   color: Colors.black,
    //                   fontFamily: FontsFamily.lato,
    //                   fontSize: 14.0,
    //                   fontWeight: FontWeight.w600),
    //               textAlign: TextAlign.left,
    //               maxLines: 2,
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             Container()
    //           ],
    //         ),
    //       ),
    //       dataDocuments.isNotEmpty
    //           ? ListView.builder(
    //               padding: const EdgeInsets.only(
    //                   left: 16.0, right: 16.0, bottom: 16.0, top: 10.0),
    //               shrinkWrap: true,
    //               physics: NeverScrollableScrollPhysics(),
    //               itemCount: dataDocuments.length,
    //               itemBuilder: (context, index) {
    //                 final DocumentSnapshot document = dataDocuments[index];
    //
    //                 return Container(
    //                     child: Column(
    //                   children: <Widget>[
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: <Widget>[
    //                         SizedBox(width: 10),
    //                         Container(
    //                           width: 85,
    //                           child: Text(
    //                             unixTimeStampToDateDocs(
    //                                 document['published_at'].seconds),
    //                             style: TextStyle(
    //                                 color: Colors.black,
    //                                 fontFamily: FontsFamily.lato,
    //                                 fontSize: 13.0),
    //                             textAlign: TextAlign.left,
    //                             maxLines: 2,
    //                             overflow: TextOverflow.ellipsis,
    //                           ),
    //                         ),
    //                         Expanded(
    //                           child: InkWell(
    //                             onTap: () {
    //                               Platform.isAndroid
    //                                   ? _downloadAttachment(document['title'],
    //                                       document['document_url'])
    //                                   : _viewPdf(document['title'],
    //                                       document['document_url']);
    //                             },
    //                             child: Text(
    //                               document['title'],
    //                               style: TextStyle(
    //                                   fontFamily: FontsFamily.lato,
    //                                   color: Colors.lightBlueAccent[700],
    //                                   decoration: TextDecoration.underline,
    //                                   fontSize: 13.0),
    //                               textAlign: TextAlign.left,
    //                             ),
    //                           ),
    //                         ),
    //                         ShareButton(
    //                           onPressed: () {
    //                             DocumentServices().shareDocument(
    //                                 document['title'],
    //                                 document['document_url']);
    //                           },
    //                         )
    //                       ],
    //                     ),
    //                     Container(
    //                       margin: EdgeInsets.only(top: 10, bottom: 10),
    //                       color: Colors.grey[200],
    //                       width: MediaQuery.of(context).size.width,
    //                       height: 1.5,
    //                     )
    //                   ],
    //                 ));
    //               })
    //           : EmptyData(
    //               message: Dictionary.emptyData,
    //               desc: '',
    //               isFlare: false,
    //               image: "${Environment.imageAssets}not_found.png",
    //             )
    //     ],
    //   ),
    // );
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
//
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
