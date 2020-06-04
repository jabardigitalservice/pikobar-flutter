import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/StatShowImportantInfo.dart';

// ignore: must_be_immutable
class NewsListScreen extends StatelessWidget {
  String news;

  NewsListScreen({this.news});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteConfigBloc>(
            create: (context) => RemoteConfigBloc()..add(RemoteConfigLoad())),
        BlocProvider<NewsListBloc>(create: (context) => NewsListBloc())
      ],
      child: News(news: news),
    );
  }
}

// ignore: must_be_immutable
class News extends StatefulWidget {
  String news;

  News({this.news});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  List<Tab> myTabs = [];
  TabController tabController;
  NewsListBloc _newsListBloc;
  bool statImportantInfo = true;
  bool checkStatImportantInfo = true;

  @override
  void initState() {
    _newsListBloc = BlocProvider.of<NewsListBloc>(context);
    AnalyticsHelper.setCurrentScreen(Analytics.news);
    super.initState();
  }

  setListTab(Color color, bool statImportantInfo) {
    myTabs.clear();
    myTabs.add(addTab(Dictionary.allNews, Dictionary.allNews, color));
    if (statImportantInfo) {
      myTabs.add(
          addTab(Dictionary.importantInfo, Dictionary.importantInfo, color));
    }
    myTabs
        .add(addTab(Dictionary.titleLatestNews, Dictionary.latestNews, color));
    myTabs.add(
        addTab(Dictionary.titleNationalNews, Dictionary.nationalNews, color));
    myTabs.add(addTab(Dictionary.titleWorldNews, Dictionary.worldNews, color));
  }

  setControllerTab(bool statImportantInfo) {
    tabController = new TabController(vsync: this, length: myTabs.length);
    tabController.addListener(_handleTabSelection);
    if (widget.news == NewsType.allArticles) {
      tabController.animateTo(0);
      _newsListBloc.add(NewsListLoad(NewsType.allArticles));
    }
    if (statImportantInfo) {
      if (widget.news == Dictionary.importantInfo) {
        tabController.animateTo(1);
        _newsListBloc.add(NewsListLoad(Collections.importantInfor));
      }
    }
    if (widget.news == Dictionary.latestNews) {
      tabController.animateTo(statImportantInfo ? 2 : 1);
      _newsListBloc.add(NewsListLoad(Collections.newsJabar));
    }
    if (widget.news == Dictionary.nationalNews) {
      tabController.animateTo(statImportantInfo ? 3 : 2);
      _newsListBloc.add(NewsListLoad(Collections.newsNational));
    }
    if (widget.news == Dictionary.worldNews) {
      tabController.animateTo(statImportantInfo ? 4 : 3);
      _newsListBloc.add(NewsListLoad(Collections.newsWorld));
    }
  }

  Tab addTab(String titleTab, String typeNews, Color color) {
    return Tab(
        child: Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: color != null
                  ? color
                  : widget.news == typeNews ? ColorBase.green : Colors.grey,
              width: 1)),
      child: Text(
        titleTab,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans,
            fontSize: 13.0),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomAppBar.setTitleAppBar(Dictionary.news),
        ),
        body: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
            builder: (context, state) {
          return state is RemoteConfigLoaded
              ? buildContent(state)
              : Container();
        }));
  }

  buildContent(RemoteConfigLoaded state) {
    statImportantInfo = StatShowImportantInfo.getStatImportantTab(state);
    if(checkStatImportantInfo){
      setListTab(null, statImportantInfo);
      setControllerTab(statImportantInfo);
      checkStatImportantInfo = false;
    }
    return Container(
        child: DefaultTabController(
      length: statImportantInfo ? 5 : 4,
      child: Column(
        children: <Widget>[
          TabBar(
            labelPadding: EdgeInsets.all(6),
            isScrollable: true,
            indicator: BubbleTabIndicator(
              indicatorHeight: 37.0,
              indicatorColor: ColorBase.green,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: ColorBase.orange,
            indicatorWeight: 2.8,
            tabs: myTabs,
            controller: tabController,
            onTap: (index) {
              setListTab(Colors.grey,
                  StatShowImportantInfo.getStatImportantTab(state));
              if (index == 0) {
                widget.news = Dictionary.allNews;
                myTabs[index] =
                    addTab(Dictionary.allNews, widget.news, ColorBase.green);
                AnalyticsHelper.setLogEvent(Analytics.tappedAllNews);
              }
              if (StatShowImportantInfo.getStatImportantTab(state)) {
                if (index == 1) {
                  widget.news = Dictionary.importantInfo;
                  myTabs[index] = addTab(
                      Dictionary.importantInfo, widget.news, ColorBase.green);
                  AnalyticsHelper.setLogEvent(Analytics.tappedImportantInfo);
                }
              }

              if (StatShowImportantInfo.getStatImportantTab(state)
                  ? index == 2
                  : index == 1) {
                widget.news = Dictionary.latestNews;
                myTabs[index] = addTab(
                    Dictionary.titleLatestNews, widget.news, ColorBase.green);
                AnalyticsHelper.setLogEvent(Analytics.tappedNewsJabar);
              }
              if (StatShowImportantInfo.getStatImportantTab(state)
                  ? index == 3
                  : index == 2) {
                widget.news = Dictionary.nationalNews;
                myTabs[index] = addTab(
                    Dictionary.titleNationalNews, widget.news, ColorBase.green);
                AnalyticsHelper.setLogEvent(Analytics.tappedNewsNational);
              }
              if (StatShowImportantInfo.getStatImportantTab(state)
                  ? index == 4
                  : index == 3) {
                widget.news = Dictionary.worldNews;
                myTabs[index] = addTab(
                    Dictionary.titleWorldNews, widget.news, ColorBase.green);
                AnalyticsHelper.setLogEvent(Analytics.tappedNewsWorld);
              }
              setState(() {});
            },
          ),
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 144,
              child: TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  NewsScreen(news: NewsType.allArticles),
                  if (statImportantInfo)
                    NewsScreen(news: Dictionary.importantInfo),
                  NewsScreen(news: Dictionary.latestNews),
                  NewsScreen(news: Dictionary.nationalNews),
                  NewsScreen(news: Dictionary.worldNews),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          _newsListBloc.add(NewsListLoad(NewsType.allArticles));
          break;
        case 1:
          _newsListBloc.add(NewsListLoad(Collections.importantInfor));
          break;
        case 2:
          _newsListBloc.add(NewsListLoad(Collections.newsJabar));
          break;
        case 3:
          _newsListBloc.add(NewsListLoad(Collections.newsNational));
          break;
        case 4:
          _newsListBloc.add(NewsListLoad(Collections.newsWorld));
          break;
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    _newsListBloc.close();
    super.dispose();
  }
}
