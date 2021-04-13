import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/StatShowImportantInfo.dart';

class NewsListScreen extends StatelessWidget {
  final String news;
  final CovidInformationScreenState covidInformationScreenState;

  const NewsListScreen({Key key, this.news, this.covidInformationScreenState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteConfigBloc>(
            create: (context) => RemoteConfigBloc()..add(RemoteConfigLoad())),
        BlocProvider<NewsListBloc>(create: (context) => NewsListBloc())
      ],
      child: News(
          news: news, covidInformationScreenState: covidInformationScreenState),
    );
  }
}


class News extends StatefulWidget {
  final String news;
  final CovidInformationScreenState covidInformationScreenState;

  const News({Key key, this.news, this.covidInformationScreenState})
      : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  TabController tabController;
  ScrollController _scrollController;
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  String searchQuery;
  NewsListBloc _newsListBloc;
  bool statImportantInfo = true;
  bool checkStatImportantInfo = true;
  List<String> listItemTitleTab = [
    Dictionary.allNews,
    Dictionary.importantInfo,
    Dictionary.latestNews,
    Dictionary.nationalNews,
    Dictionary.worldNews
  ];

  List<String> listCollectionData = [
    NewsType.allArticles,
    kImportantInfor,
    kNewsJabar,
    kNewsNational,
    kNewsWorld
  ];

  List<String> analyticsData = [
    Analytics.tappedAllNews,
    Analytics.tappedImportantInfo,
    Analytics.tappedNewsJabar,
    Analytics.tappedNewsNational,
    Analytics.tappedNewsWorld,
  ];

  @override
  void initState() {
    _newsListBloc = BlocProvider.of<NewsListBloc>(context);
    AnalyticsHelper.setCurrentScreen(Analytics.news);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  setControllerTab(bool statImportantInfo) {
    tabController =
        new TabController(vsync: this, length: listItemTitleTab.length);
    tabController.addListener(_handleTabSelection);
    for (int i = 0; i < listItemTitleTab.length; i++) {
      if (widget.news == listItemTitleTab[i]) {
        tabController.animateTo(i);
        _newsListBloc.add(NewsListLoad(listCollectionData[i],
            statImportantInfo: statImportantInfo));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: _onWillPop,
      child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, state) {
        return state is RemoteConfigLoaded ? buildContent(state) : Container();
      }),
    ));
  }

  buildContent(RemoteConfigLoaded state) {
    statImportantInfo = StatShowImportantInfo.getStatImportantTab(state);
    if (checkStatImportantInfo) {
      if (statImportantInfo) {
        setControllerTab(statImportantInfo);
      } else {
        listItemTitleTab.removeAt(1);
        listCollectionData.removeAt(1);
        listCollectionData.removeAt(1);
        setControllerTab(statImportantInfo);
      }
      checkStatImportantInfo = false;
    }
    return CustomBubbleTab(
      isStickyHeader: true,
      titleHeader: Dictionary.news,
      listItemTitleTab: listItemTitleTab,
      indicatorColor: ColorBase.green,
      searchBar: CustomAppBar.buildSearchField(
          _searchController, Dictionary.searchInformation, updateSearchQuery),
      labelColor: Colors.white,
      showTitle: _showTitle,
      scrollController: _scrollController,
      unselectedLabelColor: ColorBase.netralGrey,
      tabController: tabController,
      typeTabSelected: widget.news,
      onTap: (index) {
         _scrollController
                        .jumpTo(_scrollController.position.minScrollExtent);
        _newsListBloc.add(NewsListLoad(listCollectionData[index],
            statImportantInfo: statImportantInfo));
        AnalyticsHelper.setLogEvent(analyticsData[index]);
      },
      tabBarView: <Widget>[
        NewsScreen(
            news: Dictionary.allNews,
            searchQuery: searchQuery,
            covidInformationScreenState: widget.covidInformationScreenState),
        if (statImportantInfo)
          NewsScreen(
            news: Dictionary.importantInfo,
            searchQuery: searchQuery,
            covidInformationScreenState: widget.covidInformationScreenState,
          ),
        NewsScreen(
          news: Dictionary.latestNews,
          searchQuery: searchQuery,
          covidInformationScreenState: widget.covidInformationScreenState,
        ),
        NewsScreen(
          news: Dictionary.nationalNews,
          searchQuery: searchQuery,
          covidInformationScreenState: widget.covidInformationScreenState,
        ),
        NewsScreen(
          news: Dictionary.worldNews,
          searchQuery: searchQuery,
          covidInformationScreenState: widget.covidInformationScreenState,
        ),
      ],
      isExpand: true,
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        setState(() {
          searchQuery = _searchController.text;
        });
        AnalyticsHelper.setLogEvent(Analytics.tappedSearchNews);
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

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      _newsListBloc.add(NewsListLoad(listCollectionData[tabController.index],
          statImportantInfo: statImportantInfo));
    }
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  @override
  void dispose() {
    _searchController.dispose();
    tabController.dispose();
    _newsListBloc.close();
    super.dispose();
  }
}
