import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pedantic/pedantic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/documents/Bloc.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/components/ThumbnailCard.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

import 'DocumentViewScreen.dart';

class DocumentListScreen extends StatefulWidget {
  final CovidInformationScreenState covidInformationScreenState;

  const DocumentListScreen({Key key, this.covidInformationScreenState})
      : super(key: key);

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final int _limitMax = 500;
  final int _limitPerPage = 10;
  final int _limitPerSearch = 25;

  List<LabelNewModel> _dataLabel = [];
  List<DocumentSnapshot> _allDocs = [];
  List<DocumentSnapshot> _limitedDocs = [];

  LabelNew _labelNew = LabelNew();
  Timer _debounce;
  String _searchQuery;
  bool _isGetDataLabel = true;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.document);
    _searchController.addListener((() {
      _onSearchChanged();
    }));

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        await _getMoreData();
      }

      setState(() {});
    });
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocumentsBloc>(
      create: (context) =>
          DocumentsBloc()..add(DocumentsLoad(limit: _limitMax)),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: WillPopScope(
            child: CollapsingAppbar(
              searchBar: CustomAppBar.buildSearchField(
                  context,
                  _searchController,
                  Dictionary.searchInformation,
                  _updateSearchQuery),
              showTitle: _showTitle,
              titleAppbar: Dictionary.document,
              scrollController: _scrollController,
              body: BlocListener<DocumentsBloc, DocumentsState>(
                listener: (_, state) {
                  if (state is DocumentsLoaded) {
                    _allDocs = state.documents;

                    int limit = _allDocs.length > _limitPerPage
                        ? _limitPerPage
                        : _allDocs.length;

                    _limitedDocs = _allDocs.getRange(0, limit).toList();

                    _getDataLabel();
                  }
                },
                child: BlocBuilder<DocumentsBloc, DocumentsState>(
                  builder: (context, state) {
                    return state is DocumentsLoaded
                        ? _buildContent(_limitedDocs)
                        : _buildLoading();
                  },
                ),
              ),
            ),
            onWillPop: _onWillPop,
          )),
    );
    //   body:
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  Widget _buildContent(List<DocumentSnapshot> dataDocuments) {
    if (_searchQuery != null && _searchQuery.isNotEmpty) {
      dataDocuments = _allDocs
          .where((test) =>
              test['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .take(_limitPerSearch)
          .toList();
    }

    int itemCount =
        _searchQuery == null && dataDocuments.length != _allDocs.length
            ? dataDocuments.length + 1
            : dataDocuments.length;

    return dataDocuments.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0, top: 10.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == dataDocuments.length) {
                return CupertinoActivityIndicator();
              }

              DocumentSnapshot document = dataDocuments[index];

              return ThumbnailCard(
                imageUrl: document['images'],
                centerIcon: Image.asset(
                  '${Environment.iconAssets}pdf_icon.png',
                  height: 80,
                  width: 80,
                ),
                title: document['title'],
                date: unixTimeStampToDateTime(document['published_at'].seconds),
                label: _labelNew.isLabelNew(document.id.toString(), _dataLabel)
                    ? LabelNewScreen()
                    : Container(),
                onTap: () {
                  setState(() {
                    _labelNew.readNewInfo(
                        document.id,
                        document['published_at'].seconds.toString(),
                        _dataLabel,
                        Dictionary.labelDocuments);
                    if (widget.covidInformationScreenState != null) {
                      widget.covidInformationScreenState.widget.homeScreenState
                          .getAllUnreadData();
                    }
                  });
                  Platform.isAndroid
                      ? _downloadAttachment(
                          document['title'], document['document_url'])
                      : _viewPdf(document['title'], document['document_url']);
                },
              );
            })
        : EmptyData(
            message: Dictionary.emptyData,
            desc: Dictionary.descEmptyData,
            isFlare: false,
            image: "${Environment.imageAssets}not_found.png",
          );
  }

  Widget _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                height: 300.0,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimens.borderRadius),
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

  Future<void> _getMoreData() async {
    if (_searchQuery == null) {
      final nextPage = _limitedDocs.length + _limitPerPage;
      final limit = _allDocs.length > nextPage ? nextPage : _limitedDocs.length;

      _limitedDocs
          .addAll(_allDocs.getRange(_limitedDocs.length, limit).toList());
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  Future<void> _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(Analytics.openDocument, <String, dynamic>{
      'name_document': title.length < 100 ? title : title.substring(0, 100),
    });
  }

  Future<void> _downloadAttachment(String name, String url) async {
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
        if (mounted) {
          setState(() {
            _searchQuery = _searchController.text;
          });
        }
      } else {
        _clearSearchQuery();
      }
    });

    AnalyticsHelper.analyticSearch(
        searchController: _searchController,
        event: Analytics.tappedSerachDocument);
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _updateSearchQuery(null);
    });
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
    }
  }

  void _getDataLabel() {
    if (_isGetDataLabel) {
      _labelNew.getDataLabel(Dictionary.labelDocuments).then((value) {
        if (!mounted) return;
        setState(() {
          _dataLabel = value;
        });
      });
      _isGetDataLabel = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
