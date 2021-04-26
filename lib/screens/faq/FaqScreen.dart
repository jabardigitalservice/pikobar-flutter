import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/blocs/faq/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Connection.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

@immutable
class FaqScreen extends StatefulWidget {
  final bool isNewPage;

  const FaqScreen({Key key, this.isNewPage = true}) : super(key: key);

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqListBloc _faqListBloc = FaqListBloc();
  // ignore: unused_field, close_sinks
  RemoteConfigBloc _remoteConfigBloc;
  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController;
  String searchQuery = '';
  Timer _debounce;
  bool isConnected = false;
  final containerWidth = 40.0;
  int indexTab = 0;

  List<Widget> listWidgetTab = [];
  List<dynamic> listDataRemoteConfigTab = [];
  List<String> listItemTitleTab = [];
  List<DocumentSnapshot> listDataFaq;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.faq);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    checkConnection();
    super.initState();
  }

  checkConnection() async {
    isConnected = await Connection().checkConnection(kUrlGoogle);
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<RemoteConfigBloc>(
          create: (BuildContext context) =>
              _remoteConfigBloc = RemoteConfigBloc()..add(RemoteConfigLoad()),
          child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
              builder: (context, remoteState) {
            if (remoteState is RemoteConfigLoaded) {
              final Map<String, dynamic> getLabel = RemoteConfigHelper.decode(
                  remoteConfig: remoteState.remoteConfig,
                  firebaseConfig: FirebaseConfig.labels,
                  defaultValue: FirebaseConfig.labelsDefaultValue);

              listWidgetTab.clear();
              listDataRemoteConfigTab.clear();
              listItemTitleTab.clear();
              listDataRemoteConfigTab = getLabel['faq'] as List;

              listDataRemoteConfigTab.forEach((element) {
                if (element['published']) {
                  listWidgetTab.add(_buildFaq());
                  listItemTitleTab.add(element['title']);
                }
              });

              return BlocProvider<FaqListBloc>(
                create: (context) => _faqListBloc
                  ..add(FaqListLoad(
                      faqCollection: kFaq,
                      category:
                          listDataRemoteConfigTab[0]['category'].toString())),
                child: CustomBubbleTab(
                  isStickyHeader: widget.isNewPage,
                  titleHeader: Dictionary.faq,
                  listItemTitleTab: listItemTitleTab,
                  indicatorColor: ColorBase.green,
                  labelColor: Colors.white,
                  showTitle: _showTitle,
                  searchBar: CustomAppBar.buildSearchField(_searchController,
                      Dictionary.searchInformation, updateSearchQuery,
                      margin: const EdgeInsets.only(
                          left: Dimens.contentPadding,
                          right: 16.0,
                          bottom: Dimens.contentPadding)),
                  unselectedLabelColor: Colors.grey,
                  scrollController: _scrollController,
                  onTap: (index) {
                    setState(() {});
                    indexTab = index;
                    _faqListBloc.add(FaqListLoad(
                        faqCollection: kFaq,
                        category: listDataRemoteConfigTab[index]['category']
                            .toString()));
                    AnalyticsHelper.setLogEvent(
                        listDataRemoteConfigTab[index]['analytic'].toString());
                  },
                  tabBarView: listWidgetTab,
                  isExpand: true,
                ),
              );
            } else {
              return _buildLoading();
            }
          })),
    );
  }

  Widget _buildFaq() {
    return BlocBuilder<FaqListBloc, FaqListState>(
      builder: (context, state) {
        return state is FaqListLoaded
            ? _buildContent(state.faqList)
            : _buildLoading();
      },
    );
  }

  Widget _buildContent(List<DocumentSnapshot> listData) {
    if (searchQuery != null) {
      listDataFaq = listData
          .where((test) =>
              test['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
              test['content'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      listDataFaq = listData;
    }

    return listDataFaq.isNotEmpty
        ? ListView.builder(
            itemCount: listDataFaq.length,
            padding: const EdgeInsets.only(bottom: 30.0),
            itemBuilder: (_, int index) {
              return _cardContent(listDataFaq[index]);
            },
          )
        : ListView(
            children: [
              EmptyData(
                message: Dictionary.emptyData,
                desc: Dictionary.descEmptyData,
                isFlare: false,
                image: "${Environment.imageAssets}not_found.png",
              )
            ],
          );
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
    _faqListBloc.add(FaqListLoad(
        faqCollection: kFaq,
        category: listDataRemoteConfigTab[indexTab]['category'].toString()));
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        _faqListBloc.add(FaqListLoad(
            faqCollection: kFaq,
            category:
                listDataRemoteConfigTab[indexTab]['category'].toString()));
        setState(() {
          searchQuery = _searchController.text;
        });
      } else if (_searchController.text.isEmpty) {
        _clearSearchQuery();
      }
    });

    AnalyticsHelper.analyticSearch(
        searchController: _searchController, event: Analytics.tappedFaqSearch);
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Skeleton(
                  width: MediaQuery.of(context).size.width - 140,
                  height: 20.0,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Skeleton(
                    width: MediaQuery.of(context).size.width - 190,
                    height: 20.0,
                  ),
                ),
                trailing: Skeleton(
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                color: Colors.grey[300],
                height: 1,
              )
            ],
          )),
    );
  }

  Widget _cardContent(dataHelp) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ScrollOnExpand(
                  scrollOnExpand: false,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    tapHeaderToExpand: true,
                    tapBodyToCollapse: true,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        dataHelp['title'],
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Html(
                        data: dataHelp['content'].replaceAll('\n', '</br>'),
                        style: {
                          'body': Style(
                              margin: EdgeInsets.zero,
                              color: Colors.grey[600],
                              fontSize: const FontSize(14.0),
                              textAlign: TextAlign.start),
                          'li':
                              Style(margin: const EdgeInsets.only(bottom: 10.0))
                        },
                        onLinkTap: (url) {
                          launchExternal(url);
                        },
                      ),
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          crossFadePoint: 0,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: Dimens.contentPadding, right: Dimens.contentPadding),
            color: Colors.grey[300],
            height: 1,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
