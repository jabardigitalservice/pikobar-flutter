import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class NewsListScreen extends StatelessWidget {
  final String news;

  NewsListScreen({this.news});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsListBloc>(
        create: (context) => NewsListBloc(), child: News(news: news));
  }
}

class News extends StatefulWidget {
  final String news;

  News({this.news});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: Text(
        Dictionary.importantInfo,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans,
            fontSize: 13.0),
      ),
    ),
    new Tab(
      child: Text(
        Dictionary.titleLatestNews,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans,
            fontSize: 13.0),
      ),
    ),
    new Tab(
        child: Text(
          Dictionary.titleNationalNews,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.productSans,
              fontSize: 13.0),
        )),
    new Tab(
        child: Text(
          Dictionary.titleWorldNews,
          textAlign: TextAlign.center,
          style: TextStyle(

              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.productSans,
              fontSize: 13.0),
        )),
  ];
  TabController tabController;
  NewsListBloc _newsListBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.news);

    super.initState();
    _newsListBloc = BlocProvider.of<NewsListBloc>(context);

    tabController = new TabController(vsync: this, length: myTabs.length);
    tabController.addListener(_handleTabSelection);
    if (widget.news == Dictionary.importantInfo) {
      tabController.animateTo(0);
      _newsListBloc.add(NewsListLoad(Collections.importantInfor));
    } else if (widget.news == Dictionary.latestNews) {
      tabController.animateTo(1);
      _newsListBloc.add(NewsListLoad(Collections.newsJabar));
    } else if (widget.news == Dictionary.nationalNews) {
      tabController.animateTo(2);
      _newsListBloc.add(NewsListLoad(Collections.newsNational));
    } else {
      tabController.animateTo(3);
      _newsListBloc.add(NewsListLoad(Collections.newsWorld));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomAppBar.setTitleAppBar(Dictionary.news),
        ),
        body: Container(
            child: DefaultTabController(
                length: 4,
                child: Column(
                  children: <Widget>[
                    TabBar(
                      isScrollable: true,
                      indicator: BubbleTabIndicator(
                        indicatorHeight: 35.0,
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
                        if (index == 0) {
                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedImportantInfo);
                        }
                        if (index == 1) {
                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedNewsJabar);
                        } else if (index == 2) {
                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedNewsNational);
                        } else if (index == 3) {
                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedNewsWorld);
                        }
                      },
                    ),

                   SingleChildScrollView(
                     child: Container(
                       height: MediaQuery.of(context).size.height-129,
                       child:  TabBarView(
                         controller: tabController,
                         physics: NeverScrollableScrollPhysics(),
                         children: <Widget>[
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
            )
        ));
  }

  void _handleTabSelection() {
    if (tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          _newsListBloc.add(NewsListLoad(Collections.importantInfor));
          break;
        case 1:
          _newsListBloc.add(NewsListLoad(Collections.newsJabar));
          break;
        case 2:
          _newsListBloc.add(NewsListLoad(Collections.newsNational));
          break;
        case 3:
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
