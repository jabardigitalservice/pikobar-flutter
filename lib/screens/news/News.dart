import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/news/NewsDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/StatShowImportantInfo.dart';

class NewsListScreen extends StatelessWidget {
  final String news;
  final CovidInformationScreenState covidInformationScreenState;
  final String title;
  const NewsListScreen(
      {Key key, this.news, this.covidInformationScreenState, this.title})
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
        news: news,
        covidInformationScreenState: covidInformationScreenState,
        title: title,
      ),
    );
  }
}

class News extends StatefulWidget {
  final String news;
  final CovidInformationScreenState covidInformationScreenState;
  final String title;

  const News({Key key, this.news, this.covidInformationScreenState, this.title})
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
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew;

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
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, state) {
      return state is RemoteConfigLoaded ? buildContent(state) : Container();
    });
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
      onWillPop: _onWillPop,
      isStickyHeader: true,
      titleHeader: widget.title,
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
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        _newsListBloc.add(NewsListLoad(listCollectionData[index],
            statImportantInfo: statImportantInfo));
        AnalyticsHelper.setLogEvent(analyticsData[index]);
      },
      tabBarView: <Widget>[
        _buildNews(searchQuery, Dictionary.allNews),
        if (statImportantInfo)
          _buildNewsImportant(searchQuery, Dictionary.importantInfo),
        _buildNewsJabar(searchQuery, Dictionary.latestNews),
        _buildNewsNational(searchQuery, Dictionary.nationalNews),
        _buildNewsWorld(searchQuery, Dictionary.worldNews),
      ],
      isExpand: true,
    );
  }

  _buildNews(String searchQuery, news) {
    labelNew = LabelNew();
    return BlocListener<NewsListBloc, NewsListState>(
      listener: (context, state) {
        if (state is NewsListLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is NewsListLoaded
                      ? _buildContent(
                          list: state.newsList,
                          searchQuery: searchQuery,
                          news: news)
                      : _buildLoading(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _buildNewsImportant(String searchQuery, news) {
    labelNew = LabelNew();
    return BlocListener<NewsListBloc, NewsListState>(
      listener: (context, state) {
        if (state is NewsListImportantLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is NewsListImportantLoaded
                      ? _buildContent(
                          list: state.newsList,
                          searchQuery: searchQuery,
                          news: news)
                      : _buildLoading(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _buildNewsJabar(String searchQuery, news) {
    labelNew = LabelNew();
    return BlocListener<NewsListBloc, NewsListState>(
      listener: (context, state) {
        if (state is NewsListJabarLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is NewsListJabarLoaded
                      ? _buildContent(
                          list: state.newsList,
                          searchQuery: searchQuery,
                          news: news)
                      : _buildLoading(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _buildNewsNational(String searchQuery, news) {
    labelNew = LabelNew();
    return BlocListener<NewsListBloc, NewsListState>(
      listener: (context, state) {
        if (state is NewsListNationalLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is NewsListNationalLoaded
                      ? _buildContent(
                          list: state.newsList,
                          searchQuery: searchQuery,
                          news: news)
                      : _buildLoading(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _buildNewsWorld(String searchQuery, news) {
    labelNew = LabelNew();
    return BlocListener<NewsListBloc, NewsListState>(
      listener: (context, state) {
        if (state is NewsListWorldLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child: BlocBuilder<NewsListBloc, NewsListState>(
        builder: (context, state) {
          return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is NewsListWorldLoaded
                      ? _buildContent(
                          list: state.newsList,
                          searchQuery: searchQuery,
                          news: news)
                      : _buildLoading(),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelNews).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
    }
  }

  _buildContent({List<NewsModel> list, String searchQuery, news}) {
    if (searchQuery != null) {
      list = list
          .where((test) =>
              test.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    getDataLabel();
    return list.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length > 100 ? 100 : list.length,
            padding: const EdgeInsets.only(bottom: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return designListNews(list[index], news);
            },
          )
        : EmptyData(
            message: Dictionary.emptyData,
            desc: Dictionary.descEmptyData,
            isFlare: false,
            image: "${Environment.imageAssets}not_found.png",
          );
  }

  Widget designListNews(NewsModel data, String news) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: Dimens.contentPadding),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 35,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                child: CachedNetworkImage(
                  imageUrl: data.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      heightFactor: 4.2, child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Container(
                      height: MediaQuery.of(context).size.height / 3.3,
                      color: Colors.grey[200],
                      child: Image.asset('${Environment.iconAssets}pikobar.png',
                          fit: BoxFit.fitWidth)),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 35,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
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
                    children: [
                      labelNew.isLabelNew(data.id.toString(), dataLabel)
                          ? LabelNewScreen()
                          : Container(),
                      Expanded(
                        child: Text(
                          unixTimeStampToDateTime(data.publishedAt),
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    data.title,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
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
      onTap: () async {
        setState(() {
          labelNew.readNewInfo(data.id, data.publishedAt.toString(), dataLabel,
              Dictionary.labelNews);
          if (widget.covidInformationScreenState != null) {
            widget.covidInformationScreenState.widget.homeScreenState
                .getAllUnreadData();
          }
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                NewsDetailScreen(id: data.id, news: news, model: data),
          ),
        );
        AnalyticsHelper.setLogEvent(
            Analytics.tappedNewsDetail, <String, dynamic>{'title': data.title});
      },
    );
  }

  _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        setState(() {
          searchQuery = _searchController.text;
        });
      } else {
        _clearSearchQuery();
      }
    });

    AnalyticsHelper.analyticSearch(
        searchController: _searchController, event: Analytics.tappedSearchNews);
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
