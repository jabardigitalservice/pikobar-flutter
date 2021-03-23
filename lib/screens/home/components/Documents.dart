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
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/screens/document/DocumentViewScreen.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

// ignore: must_be_immutable
class Documents extends StatefulWidget {
  final String searchQuery;
  CovidInformationScreenState covidInformationScreenState;

  Documents({Key key, this.searchQuery, this.covidInformationScreenState})
      : super(key: key);

  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List<DocumentSnapshot> dataDocuments = [];
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew = LabelNew();

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
    return BlocListener<DocumentsBloc, DocumentsState>(
        listener: (context, state) {
      if (state is DocumentsLoaded) {
        isGetDataLabel = true;
        getDataLabel();
      }
    }, child: BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        return state is DocumentsLoaded
            ? _buildContent(state.documents, getLabel)
            : _buildLoading();
      },
    ));
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelDocuments).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
    }
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
                    fontFamily: FontsFamily.roboto,
                    fontSize: 16.0),
              ),
              InkWell(
                child: Text(
                  Dictionary.more,
                  style: TextStyle(
                      color: ColorBase.green,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.roboto,
                      fontSize: Dimens.textSubtitleSize),
                ),
                onTap: () async {
                  final result = await Navigator.pushNamed(
                      context, NavigationConstrants.Document,
                      arguments: widget.covidInformationScreenState) as bool;

                  if (result) {
                    isGetDataLabel = result;
                    getDataLabel();
                  }

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
                fontFamily: FontsFamily.roboto,
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
              right: Dimens.padding,
              top: Dimens.padding,
              bottom: Dimens.padding),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                width: 150.0,
                height: 150.0,
                padding: const EdgeInsets.only(left: Dimens.padding),
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

  Widget _buildContent(
      List<DocumentSnapshot> documents, Map<String, dynamic> getLabel) {
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
      if (dataDocuments.isEmpty) {
        widget.covidInformationScreenState.isEmptyDataDocument = true;
      }
    }

    getDataLabel();

    return dataDocuments.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      getLabel['documents']['title'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsFamily.roboto,
                          fontSize: Dimens.textTitleSize),
                    ),
                    InkWell(
                      child: Text(
                        Dictionary.more,
                        style: TextStyle(
                            color: ColorBase.green,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontsFamily.roboto,
                            fontSize: Dimens.textSubtitleSize),
                      ),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                                context, NavigationConstrants.Document,
                                arguments: widget.covidInformationScreenState)
                            as bool;

                        if (result) {
                          isGetDataLabel = result;
                          getDataLabel();
                        }

                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedDocumentsMore);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 265,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    padding: const EdgeInsets.only(
                        right: Dimens.padding,
                        top: Dimens.padding,
                        bottom: Dimens.padding),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        widget.searchQuery != null ? dataDocuments.length : 5,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document = dataDocuments[index];
                      return Container(
                        padding: EdgeInsets.only(left: Dimens.padding),
                        width: 150.0,
                        height: 150.0,
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              child: Stack(
                                children: [
                                  Container(
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
                                            child:
                                                CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3.3,
                                          color: Colors.grey[200],
                                          child: Image.asset(
                                              '${Environment.iconAssets}pikobar.png',
                                              fit: BoxFit.fitWidth),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: Image.asset(
                                      '${Environment.iconAssets}pdf_icon.png',
                                      scale: 2,
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  labelNew.readNewInfo(
                                      document.id,
                                      document['published_at']
                                          .seconds
                                          .toString(),
                                      dataLabel,
                                      Dictionary.labelDocuments);
                                  widget.covidInformationScreenState.widget
                                      .homeScreenState
                                      .getAllUnreadData();
                                });
                                Platform.isAndroid
                                    ? _downloadAttachment(document['title'],
                                        document['document_url'])
                                    : _viewPdf(document['title'],
                                        document['document_url']);
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        labelNew.readNewInfo(
                                            document.id,
                                            document['published_at']
                                                .seconds
                                                .toString(),
                                            dataLabel,
                                            Dictionary.labelDocuments);
                                        widget.covidInformationScreenState
                                            .widget.homeScreenState
                                            .getAllUnreadData();
                                      });
                                      Platform.isAndroid
                                          ? _downloadAttachment(
                                              document['title'],
                                              document['document_url'])
                                          : _viewPdf(document['title'],
                                              document['document_url']);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['title'],
                                            style: TextStyle(
                                                fontSize:
                                                    Dimens.textSubtitleSize,
                                                fontFamily: FontsFamily.roboto,
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
                                              labelNew.isLabelNew(
                                                      document.id.toString(),
                                                      dataLabel)
                                                  ? LabelNewScreen()
                                                  : Container(),
                                              Expanded(
                                                child: Text(
                                                  unixTimeStampToCustomDateFormat(
                                                      document['published_at']
                                                          .seconds,
                                                      'EEEE, dd MMM yyyy'),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          FontsFamily.roboto,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                    }),
              )
            ],
          )
        : Container();
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
