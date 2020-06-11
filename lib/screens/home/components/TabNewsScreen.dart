import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/RemoteConfigBloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/StatShowImportantInfo.dart';

// ignore: must_be_immutable
class TabNewsScreen extends StatefulWidget {

  @override
  _TabNewsScreenState createState() => _TabNewsScreenState();
}

class _TabNewsScreenState extends State<TabNewsScreen> {
  String typeNews = Dictionary.importantInfo;
  NewsListBloc newsListBloc;
  bool checkInitTypeNews = true;


  buildContent(RemoteConfigLoaded state) {
    if (checkInitTypeNews) {
      if (!StatShowImportantInfo.getStatImportantTab(state)) {
        typeNews = Dictionary.latestNews;
        newsListBloc
            .add(NewsListLoad(Collections.newsJabar));

        checkInitTypeNews = false;
      }else{
        newsListBloc
            .add(NewsListLoad(Collections.importantInfor));
        checkInitTypeNews = false;
      }
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  left: Dimens.padding,
                  right: Dimens.padding,
                  top: Dimens.padding),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Dictionary.newsUpdate,
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
                          fontSize: 12.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsListScreen(news: Dictionary.allNews),
                        ),
                      );
                      AnalyticsHelper.setLogEvent(Analytics.tappedMore);
                    },
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.only(
                left: Dimens.padding, right: Dimens.padding, top: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              Dictionary.descNews,
              style: TextStyle(
                  color: Colors.black,
                fontFamily: FontsFamily.lato,
                  fontSize: 12.0,),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: DefaultTabController(
              length: StatShowImportantInfo.getStatImportantTab(state) ? 4 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TabBar(
                    isScrollable: true,
                    onTap: (index) {
                      setState(() {});
                      if (StatShowImportantInfo.getStatImportantTab(state)) {
                        if (index == 0) {
                          typeNews = Dictionary.importantInfo;
                          newsListBloc
                              .add(NewsListLoad(Collections.importantInfor));
                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedImportantInfo);
                        }
                      }

                      if (StatShowImportantInfo.getStatImportantTab(state)
                          ? index == 1
                          : index == 0) {
                        typeNews = Dictionary.latestNews;
                        newsListBloc
                            .add(NewsListLoad(Collections.newsJabar));
                        AnalyticsHelper.setLogEvent(Analytics.tappedNewsJabar);
                      }
                      if (StatShowImportantInfo.getStatImportantTab(state)
                          ? index == 2
                          : index == 1) {
                        typeNews = Dictionary.nationalNews;
                        newsListBloc
                            .add(NewsListLoad(Collections.newsNational));
                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedNewsNational);
                      }
                      if (StatShowImportantInfo.getStatImportantTab(state)
                          ? index == 3
                          : index == 2) {
                        typeNews = Dictionary.worldNews;
                        newsListBloc
                            .add(NewsListLoad(Collections.newsWorld));
                        AnalyticsHelper.setLogEvent(Analytics.tappedNewsWorld);
                      }
                    },
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicator: BubbleTabIndicator(
                      indicatorHeight: 37.0,
                      indicatorColor: ColorBase.green,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                    indicatorColor: ColorBase.green,
                    indicatorWeight: 0.1,
                    labelPadding: EdgeInsets.all(10),
                    tabs: <Widget>[
                      if (StatShowImportantInfo.getStatImportantTab(state))
                        Tab(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: typeNews == Dictionary.importantInfo
                                        ? ColorBase.green
                                        : Colors.grey,
                                    width: 1)),
                            child: Text(
                              Dictionary.importantInfo,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 12.0),
                            ),
                          ),
                        ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: typeNews == Dictionary.latestNews
                                      ? ColorBase.green
                                      : Colors.grey,
                                  width: 1)),
                          child: Text(
                            Dictionary.titleLatestNews,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: FontsFamily.lato,
                                fontSize: 12.0),
                          ),
                        ),
                      ),
                      Tab(
                          child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: typeNews == Dictionary.nationalNews
                                    ? ColorBase.green
                                    : Colors.grey,
                                width: 1)),
                        child: Text(
                          Dictionary.titleNationalNews,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0),
                        ),
                      )),
                      Tab(
                          child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: typeNews == Dictionary.worldNews
                                    ? ColorBase.green
                                    : Colors.grey,
                                width: 1)),
                        child: Text(
                          Dictionary.titleWorldNews,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0),
                        ),
                      )),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 320,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        if (StatShowImportantInfo.getStatImportantTab(state))
                          NewsScreen(
                              news: Dictionary.importantInfo, maxLength: 3),
                        NewsScreen(news: Dictionary.latestNews, maxLength: 3),
                        NewsScreen(news: Dictionary.nationalNews, maxLength: 3),
                        NewsScreen(news: Dictionary.worldNews, maxLength: 3),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    newsListBloc = BlocProvider.of<NewsListBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, state) {
      return state is RemoteConfigLoaded ? buildContent(state) : Container();
    });
  }
}
