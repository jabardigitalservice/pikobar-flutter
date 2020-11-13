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
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/ProfileUid.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/home/components/Documents.dart';
import 'package:pikobar_flutter/screens/home/components/GroupHomeBanner.dart';
import 'package:pikobar_flutter/screens/home/components/InfoGraphics.dart';
import 'package:pikobar_flutter/screens/home/components/JabarToday.dart';
import 'package:pikobar_flutter/screens/home/components/MenuList.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/screens/home/components/SpreadSection.dart';
import 'package:pikobar_flutter/screens/home/components/statistics/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/TabNewsScreen.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';

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
  List<String> listItemTitleTab = [
    Dictionary.jabarToday,
    Dictionary.covidInformation
  ];
  List<String> analyticsData = [
    Analytics.tappedJabarToday,
    Analytics.tappedCovidInformation,
  ];

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.home);
    getDataFromServer();
    super.initState();
  }

  void getDataFromServer() {
    FirebaseFirestore.instance
        .collection('broadcasts')
        .orderBy('published_at', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      insertIntoDatabase(snapshot);
    }).catchError((error) {});
  }

  Future<void> insertIntoDatabase(QuerySnapshot snapshot) async {
    await MessageRepository().insertToDatabase(snapshot.docs);
    widget.indexScreenState.getCountMessage();
    isLoading = false;
  }

  Future<void> getDataProfileFromServer() async {
    String uid = await ProfileUidSharedPreference.getProfileUid();
    if (uid != null) {
      FirebaseFirestore.instance
          .collection(kUsers)
          .where('id', isEqualTo: uid)
          .get()
          .then((QuerySnapshot snapshot) {
        HealthCheck()
            .isUserHealty(snapshot.docs[0].get('health_status').toString());
      }).catchError((error) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getDataProfileFromServer();
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
              ..add(
                  NewsListLoad(NewsType.allArticles, statImportantInfo: true))),
        BlocProvider<ImportantInfoListBloc>(
            create: (context) =>
                _importantInfoListBloc = ImportantInfoListBloc()
                  ..add(ImportantInfoListLoad(kImportantInfor))),
        BlocProvider<VideoListBloc>(
            create: (context) =>
                _videoListBloc = VideoListBloc()..add(LoadVideos(limit: 5))),
        BlocProvider<InfoGraphicsListBloc>(
            create: (context) => _infoGraphicsListBloc = InfoGraphicsListBloc()
              ..add(InfoGraphicsListLoad(
                  infoGraphicsCollection: kInfographics, limit: 3))),
        BlocProvider<DocumentsBloc>(
            create: (context) =>
                _documentsBloc = DocumentsBloc()..add(DocumentsLoad(limit: 5)))
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
        CustomBubbleTab(
          listItemTitleTab: listItemTitleTab,
          indicatorColor: ColorBase.green,
          labelColor: Colors.white,
          isScrollable: false,
          unselectedLabelColor: Colors.grey,
          sizeLabel: 13.0,
          onTap: (index) {
            AnalyticsHelper.setLogEvent(analyticsData[index]);
          },
          tabBarView: <Widget>[
            JabarTodayScreen(),
            CovidInformationScreen(),
          ],
          isExpand: true,
        ),

//         ListView(children: [
//           /// Banners Section
//           Container(
//               margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
//               child: BannerListSlider()),
//
//           /// Statistics Announcement
//           AnnouncementScreen(),
//
//           /// Statistics Section
//           Container(
//               color: ColorBase.grey,
//               margin: EdgeInsets.only(top: 10.0),
//               padding: EdgeInsets.only(bottom: Dimens.dividerHeight),
//               child: Statistics()),
//
//           /// Menus & Spread Sections
//           Column(
//             children: <Widget>[
//               /// Menus Section
//               MenuList(),
//
//               // Group Home Banner Section
//               GroupHomeBanner(),
//
//               /// Spread Section
//               SpreadSection(),
//
//               /// Important Info
// //              Container(
// //                color: ColorBase.grey,
// //                child: ImportantInfoScreen(maxLength: 3),
// //              ),
//             ],
//           ),
//
//           /// News & Videos Sections
//           SizedBox(
//             height: Dimens.dividerHeight,
//             child: Container(
//               color: ColorBase.grey,
//             ),
//           ),
//           TabNewsScreen(),
//
//           SizedBox(
//             height: Dimens.dividerHeight,
//             child: Container(
//               color: ColorBase.grey,
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 16.0),
//             child: VideoList(),
//           ),
//           SizedBox(
//             height: Dimens.dividerHeight,
//             child: Container(
//               color: ColorBase.grey,
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 16.0),
//             child: InfoGraphics(),
//           ),
//           SizedBox(
//             height: Dimens.dividerHeight,
//             child: Container(
//               color: ColorBase.grey,
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 16.0),
//             child: Documents(),
//           ),
//           SizedBox(
//             height: Dimens.dividerHeight,
//             child: Container(
//               color: ColorBase.grey,
//             ),
//           ),
//           Container(
//             padding: EdgeInsets.only(top: 25.0),
//             child: SocialMedia(),
//           ),
//         ]
//         ),
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
    if (_pcrTestBloc != null) {
      _pcrTestBloc.close();
    }
    _newsListBloc.close();
    if (_importantInfoListBloc != null) {
      _importantInfoListBloc.close();
    }
    _videoListBloc.close();
    if (_infoGraphicsListBloc != null) {
      _infoGraphicsListBloc.close();
    }
    if (_documentsBloc != null) {
      _documentsBloc.close();
    }
    super.dispose();
  }
}
