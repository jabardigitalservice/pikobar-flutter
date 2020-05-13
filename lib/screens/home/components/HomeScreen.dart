import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/banners/Bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/Documents.dart';
import 'package:pikobar_flutter/screens/home/components/InfoGraphics.dart';
import 'package:pikobar_flutter/screens/home/components/MenuList.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/SpreadSection.dart';
import 'package:pikobar_flutter/screens/home/components/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

import 'BannerListSlider.dart';

class HomeScreen extends StatefulWidget {
  final IndexScreenState indexScreenState;

  HomeScreen({this.indexScreenState});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RemoteConfigBloc _remoteConfigBloc;
  BannersBloc _bannersBloc;
  StatisticsBloc _statisticsBloc;
  RapidTestBloc _rapidTestBloc;
  PcrTestBloc _pcrTestBloc;
  NewsListBloc _newsListBloc;
  bool isLoading = true;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.home);
    getDataFromServer();
    super.initState();
  }

  void getDataFromServer() {
    Firestore.instance
        .collection('broadcasts')
        .orderBy('published_at', descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      insertIntoDatabase(snapshot);
    }).catchError((error) {});
  }

  Future<void> insertIntoDatabase(QuerySnapshot snapshot) async {
    await MessageRepository().insertToDatabase(snapshot.documents);
    widget.indexScreenState.getCountMessage();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteConfigBloc>(
            create: (BuildContext context) => _remoteConfigBloc =
                RemoteConfigBloc()..add(RemoteConfigLoad())),
        BlocProvider<BannersBloc>(
            create: (context) =>
                _bannersBloc = BannersBloc()..add(BannersLoad())),
        BlocProvider<StatisticsBloc>(
            create: (context) =>
                _statisticsBloc = StatisticsBloc()..add(StatisticsLoad())),
        BlocProvider<RapidTestBloc>(
            create: (context) =>
            _rapidTestBloc = RapidTestBloc()..add(RapidTestLoad())),
        BlocProvider<PcrTestBloc>(
            create: (context) =>
            _pcrTestBloc = PcrTestBloc()..add(PcrTestLoad())),
        BlocProvider<NewsListBloc>(
            create: (context) =>
            _newsListBloc = NewsListBloc()..add(NewsListLoad(Collections.newsJabar)))
      ],
      child: Scaffold(
        backgroundColor: ColorBase.grey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: ColorBase.green,
          title: Row(
            children: <Widget>[
              Image.asset('${Environment.logoAssets}logo.png',
                  width: 40.0, height: 40.0),
              Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Dictionary.appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.intro,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          Dictionary.subTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.intro,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
        body: buildContent(),
      ),
    );
  }

  Widget buildContent() {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          color: ColorBase.green,
        ),
        ListView(children: [
          /// Banners Section
          Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: BannerListSlider()),

          /// Statistics Announcement
          AnnouncementScreen(),

          /// Statistics Section
          Container(
              color: ColorBase.grey,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.only(bottom: 10.0),
              child: Statistics()),

          /// Menus & Spread Sections
          Column(
            children: <Widget>[
              /// Menus Section
              MenuList(),

              /// Spread Section
              SpreadSection(),
            ],
          ),

          /// News & Videos Sections
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.padding),
                  alignment: Alignment.topLeft,
                  child: Text(
                    Dictionary.newsUpdate,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontsFamily.productSans,
                        fontSize: 16.0),
                  ),
                ),
                Container(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          onTap: (index) {
                            if (index == 0) {
                              _newsListBloc.add(NewsListLoad(Collections.newsJabar));
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedNewsJabar);
                            } else if (index == 1) {
                              _newsListBloc.add(NewsListLoad(Collections.newsNational));
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedNewsNational);
                            } else if (index == 2) {
                              _newsListBloc.add(NewsListLoad(Collections.newsWorld));
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedNewsWorld);
                            }
                          },
                          labelColor: Colors.black,
                          indicatorColor: ColorBase.green,
                          indicatorWeight: 2.8,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                Dictionary.latestNews,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontsFamily.productSans,
                                    fontSize: 13.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                Dictionary.nationalNews,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontsFamily.productSans,
                                    fontSize: 13.0),
                              ),
                            ),
                            Tab(
                                child: Text(
                              Dictionary.worldNews,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: FontsFamily.productSans,
                                  fontSize: 13.0),
                            )),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 400,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              NewsScreen(
                                  news: Dictionary.latestNews, maxLength: 3),
                              NewsScreen(
                                  news: Dictionary.nationalNews, maxLength: 3),
                              NewsScreen(
                                  news: Dictionary.worldNews, maxLength: 3),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: VideoList(),
                ),
                SizedBox(
                  height: 24,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: InfoGraphics(),
                ),
                SizedBox(
                  height: 24,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Documents(),
                ),
                SizedBox(
                  height: 24,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                ),
              ],
            ),
          )
        ]),
        AlertUpdate()
      ],
    );
  }

  @override
  void dispose() {
    _remoteConfigBloc.close();
    _bannersBloc.close();
    _statisticsBloc.close();
    _rapidTestBloc.close();
    _pcrTestBloc.close();
    _newsListBloc.close();
    super.dispose();
  }
}
