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
  TabController tabController;
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
    Collections.importantInfor,
    Collections.newsJabar,
    Collections.newsNational,
    Collections.newsWorld
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
    super.initState();
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
        appBar: AppBar(
          backgroundColor: Colors.white,
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
    return Container(
      child: CustomBubbleTab(
        listItemTitleTab: listItemTitleTab,
        indicatorColor: ColorBase.green,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabController: tabController,
        typeTabSelected: widget.news,
        onTap: (index) {
          AnalyticsHelper.setLogEvent(analyticsData[index]);
        },
        tabBarView: <Widget>[
          NewsScreen(news:  Dictionary.allNews),
          if (statImportantInfo) NewsScreen(news: Dictionary.importantInfo),
          NewsScreen(news: Dictionary.latestNews),
          NewsScreen(news: Dictionary.nationalNews),
          NewsScreen(news: Dictionary.worldNews),
        ],
        heightTabBarView: MediaQuery.of(context).size.height - 148,
        paddingTopTabBarView: 0,
      ),
    );
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      _newsListBloc.add(NewsListLoad(listCollectionData[tabController.index],
          statImportantInfo: statImportantInfo));
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    _newsListBloc.close();
    super.dispose();
  }
}
