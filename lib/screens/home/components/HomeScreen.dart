import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/banners/Bloc.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
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
import 'package:pikobar_flutter/configs/SharedPreferences/HistoryTabHome.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/ProfileUid.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/home/components/JabarToday.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';

class HomeScreen extends StatefulWidget {
  final IndexScreenState indexScreenState;

  HomeScreen({this.indexScreenState});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
  TabController tabController;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.home);
    getDataFromServer();
    setControllerTab();
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

  setControllerTab() async {
    String historyTab =
        await HistoryTabHomeSharedPreference.getHistoryTabHome();
    tabController =
        new TabController(vsync: this, length: listItemTitleTab.length);
    for (int i = 0; i < listItemTitleTab.length; i++) {
      if (historyTab != null) {
        if (historyTab == listItemTitleTab[i]) {
          setState(() {
            tabController.animateTo(i);
          });
        }
      }
    }
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
                _documentsBloc = DocumentsBloc()..add(DocumentsLoad())),
        BlocProvider<CheckDistributionBloc>(
            create: (context) => CheckDistributionBloc(
                checkDistributionRepository: CheckDistributionRepository()))
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
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
          tabController: tabController,
          paddingBubbleTab: 10,
          sizeLabel: 13.0,
          onTap: (index) async {
            if (listItemTitleTab[index] == Dictionary.covidInformation) {
              _newsListBloc.add(
                  NewsListLoad(NewsType.allArticles, statImportantInfo: true));
            }
            AnalyticsHelper.setLogEvent(analyticsData[index]);
            await HistoryTabHomeSharedPreference.setHistoryTabHome(
                listItemTitleTab[index]);
          },
          tabBarView: <Widget>[
            JabarTodayScreen(),
            CovidInformationScreen(),
          ],
          isExpand: true,
        ),
        AlertUpdate()
      ],
    );
  }

  @override
  void dispose() {
    tabController.dispose();
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
    if (_videoListBloc != null) {
      _videoListBloc.close();
    }
    if (_infoGraphicsListBloc != null) {
      _infoGraphicsListBloc.close();
    }
    if (_documentsBloc != null) {
      _documentsBloc.close();
    }
    super.dispose();
  }
}
