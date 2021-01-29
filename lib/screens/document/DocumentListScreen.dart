import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

import 'DocumentViewScreen.dart';

// ignore: must_be_immutable
class DocumentListScreen extends StatefulWidget {
  CovidInformationScreenState covidInformationScreenState;

  DocumentListScreen({Key key, this.covidInformationScreenState})
      : super(key: key);

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  ScrollController _scrollController;
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  String searchQuery;
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew = LabelNew();

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.document);
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      child: CollapsingAppbar(
        searchBar: CustomAppBar.buildSearchField(
            _searchController, Dictionary.searchInformation, updateSearchQuery),
        showTitle: _showTitle,
        titleAppbar: Dictionary.document,
        scrollController: _scrollController,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(kDocuments)
              .orderBy('published_at', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              List<DocumentSnapshot> data = [];

              snapshot.data.docs.forEach((record) {
                if (record['published']) {
                  data.add(record);
                }
              });

              if (data.isNotEmpty) {
                return _buildContent(data);
              } else {
                return EmptyData(
                  message: Dictionary.emptyData,
                  desc: '',
                  isFlare: false,
                  image: "${Environment.imageAssets}not_found.png",
                );
              }
            } else {
              return _buildLoading();
            }
          },
        ),
      ),
      onWillPop: _onWillPop,
    ));
    //   body:
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  Widget _buildContent(List<DocumentSnapshot> dataDocuments) {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      dataDocuments = dataDocuments
          .where((test) =>
              test['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    getDataLabel();

    return dataDocuments.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0, top: 10.0),
            shrinkWrap: true,
            itemCount: dataDocuments.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = dataDocuments[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: Dimens.padding,
                          right: Dimens.padding,
                          bottom: Dimens.padding),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: document['images'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  heightFactor: 4.2,
                                  child: CupertinoActivityIndicator(),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.3,
                                  color: Colors.grey[200],
                                  child: Image.asset(
                                    '${Environment.iconAssets}pikobar.png',
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.black12.withOpacity(0.2),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.circular(Dimens.dialogRadius),
                            ),
                          ),
                          Image.asset(
                            '${Environment.iconAssets}pdf_icon.png',
                            height: 80,
                            width: 80,
                          ),
                          Positioned(
                            left: 10,
                            right: 10,
                            bottom: 0,
                            top: 215,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    labelNew.isLabelNew(
                                            document.id.toString(), dataLabel)
                                        ? LabelNewScreen()
                                        : Container(),
                                    Expanded(
                                      child: Text(
                                        unixTimeStampToDateTime(
                                            document['published_at'].seconds),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontFamily: FontsFamily.roboto),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  document['title'],
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: FontsFamily.roboto),
                                  textAlign: TextAlign.left,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        labelNew.readNewInfo(
                            document.id,
                            document['published_at'].seconds.toString(),
                            dataLabel,
                            Dictionary.labelDocuments);
                        if (widget.covidInformationScreenState != null) {
                          widget.covidInformationScreenState.widget
                              .homeScreenState
                              .getAllUnreadData();
                        }
                      });
                      Platform.isAndroid
                          ? _downloadAttachment(
                              document['title'], document['document_url'])
                          : _viewPdf(
                              document['title'], document['document_url']);
                    },
                  ),
                ],
              );
            })
        : ListView(
            children: [
              EmptyData(
                message: Dictionary.emptyData,
                desc: Dictionary.descEmptyData,
                isFlare: false,
                image: "${Environment.imageAssets}not_found.png",
              ),
            ],
          );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                height: 300.0,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Skeleton(
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        setState(() {
          searchQuery = _searchController.text;
        });
        AnalyticsHelper.setLogEvent(Analytics.tappedSerachDocument);
      } else {
        _clearSearchQuery();
      }
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery(null);
    });
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
