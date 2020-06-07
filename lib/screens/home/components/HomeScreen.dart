import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/banners/Bloc.dart';
import 'package:pikobar_flutter/blocs/documents/Bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/Documents.dart';
import 'package:pikobar_flutter/screens/home/components/GroupHomeBanner.dart';
import 'package:pikobar_flutter/screens/home/components/ImportantInfoScreen.dart';
import 'package:pikobar_flutter/screens/home/components/InfoGraphics.dart';
import 'package:pikobar_flutter/screens/home/components/MenuList.dart';
import 'package:pikobar_flutter/screens/home/components/SpreadSection.dart';
import 'package:pikobar_flutter/screens/home/components/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/TabNewsScreen.dart';
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
  ImportantInfoListBloc _importantInfoListBloc;
  VideoListBloc _videoListBloc;
  InfoGraphicsListBloc _infoGraphicsListBloc;
  DocumentsBloc _documentsBloc;
  bool isLoading = true;
  String typeNews = Dictionary.importantInfo;

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
            create: (context) => _newsListBloc = NewsListBloc()
              ..add(NewsListLoad(Collections.newsJabar))),
        BlocProvider<ImportantInfoListBloc>(
            create: (context) =>
                _importantInfoListBloc = ImportantInfoListBloc()
                  ..add(ImportantInfoListLoad(Collections.importantInfor))),
        BlocProvider<VideoListBloc>(
            create: (context) =>
                _videoListBloc = VideoListBloc()..add(LoadVideos(limit: 5))),
        BlocProvider<InfoGraphicsListBloc>(
            create: (context) => _infoGraphicsListBloc = InfoGraphicsListBloc()
              ..add(InfoGraphicsListLoad(limit: 3))),
        BlocProvider<DocumentsBloc>(
            create: (context) =>
                _documentsBloc = DocumentsBloc()..add(DocumentsLoad(limit: 3)))
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                Image.asset('${Environment.logoAssets}logo.png',
                    width: 24.0, height: 24.0),
                Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      Dictionary.appName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.intro,
                      ),
                    ))
              ],
            ),
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
          color: Colors.white,
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
              padding: EdgeInsets.only(bottom: 24.0),
              child: Statistics()),

          /// Menus & Spread Sections
          Column(
            children: <Widget>[
              /// Menus Section
              MenuList(),

              // Group Home Banner Section
              GroupHomeBanner(),

              /// Spread Section
              SpreadSection(),

              /// Important Info
//              Container(
//                color: ColorBase.grey,
//                child: ImportantInfoScreen(maxLength: 3),
//              ),
            ],
          ),

          /// News & Videos Sections
          SizedBox(
            height: 24,
            child: Container(
              color: ColorBase.grey,
            ),
          ),
          TabNewsScreen(),

          SizedBox(
            height: 24,
            child: Container(
              color: ColorBase.grey,
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
    _importantInfoListBloc.close();
    _videoListBloc.close();
    _infoGraphicsListBloc.close();
    _documentsBloc.close();
    super.dispose();
  }
}
