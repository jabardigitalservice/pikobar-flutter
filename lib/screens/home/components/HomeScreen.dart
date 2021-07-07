import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/area/cityListBloc/Bloc.dart';
import 'package:pikobar_flutter/blocs/banners/Bloc.dart';
import 'package:pikobar_flutter/blocs/checkDistribution/CheckDistributionBloc.dart';
import 'package:pikobar_flutter/blocs/dailyChart/DailyChartBloc.dart';
import 'package:pikobar_flutter/blocs/documents/Bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/infographicslist/Bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcrIndividu/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdtAntigen/Bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/HistoryTabHome.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/ProfileUid.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/repositories/DailyChartRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/home/components/JabarToday.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

class HomeScreen extends StatefulWidget {
  final IndexScreenState indexScreenState;

  HomeScreen({Key key, this.indexScreenState}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  RemoteConfigBloc _remoteConfigBloc;
  BannersBloc _bannersBloc;
  StatisticsBloc _statisticsBloc;
  RapidTestBloc _rapidTestBloc;
  RapidTestAntigenBloc _rapidTestAntigenBloc;
  PcrTestBloc _pcrTestBloc;
  PcrTestIndividuBloc _pcrTestIndividuBloc;
  DailyChartBloc _dailyChartBloc;
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
  int totalUnreadInfo = 0;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.home);
    getDataFromServer();
    setControllerTab();
    getAllUnreadData();
    super.initState();
  }

  getAllUnreadData() {
    Future.delayed(Duration(milliseconds: 0), () async {
      var data = await LabelNew().getAllUnreadDataLabel();
      if (!mounted) return;
      setState(() {
        totalUnreadInfo = data;
      });
    });
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
    getAllUnreadData();
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
        BlocProvider<RapidTestAntigenBloc>(
            create: (context) => _rapidTestAntigenBloc = RapidTestAntigenBloc()
              ..add(RapidTestAntigenLoad())),
        BlocProvider<PcrTestIndividuBloc>(
            create: (context) => _pcrTestIndividuBloc = PcrTestIndividuBloc()
              ..add(PcrTestIndividuLoad())),
        BlocProvider<NewsListBloc>(create: (context) => NewsListBloc()),
        BlocProvider<ImportantInfoListBloc>(
            create: (context) => ImportantInfoListBloc()),
        BlocProvider<VideoListBloc>(create: (context) => VideoListBloc()),
        BlocProvider<InfoGraphicsListBloc>(
            create: (context) => InfoGraphicsListBloc()),
        BlocProvider<DocumentsBloc>(create: (context) => DocumentsBloc()),
        BlocProvider<CheckDistributionBloc>(
            create: (context) => CheckDistributionBloc(
                checkDistributionRepository: CheckDistributionRepository())),
        BlocProvider<CityListBloc>(
            create: (context) => CityListBloc()..add(CityListLoad())),
        BlocProvider<DailyChartBloc>(
            create: (context) => _dailyChartBloc =
                DailyChartBloc(dailyChartRepository: DailyChartRepository())
                  ..add(LoadDailyChart())),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
                listener: (BuildContext context, InfoGraphicsListState state) {
              if (state is InfoGraphicsListLoaded) {
                getAllUnreadData();
              }
            }),
            BlocListener<NewsListBloc, NewsListState>(
                listener: (BuildContext context, NewsListState state) {
              if (state is NewsListLoaded) {
                getAllUnreadData();
              }
            }),
            BlocListener<VideoListBloc, VideoListState>(
                listener: (BuildContext context, VideoListState state) {
              if (state is VideosLoaded) {
                getAllUnreadData();
              }
            }),
            BlocListener<DocumentsBloc, DocumentsState>(
                listener: (BuildContext context, DocumentsState state) {
              if (state is DocumentsLoaded) {
                getAllUnreadData();
              }
            }),
          ],
          child: buildContent(),
        ),
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
          titleNameLabelNew: listItemTitleTab[1],
          totalInfoUnread: totalUnreadInfo,
          onTap: (index) async {
            getAllUnreadData();
            AnalyticsHelper.setLogEvent(analyticsData[index]);
            await HistoryTabHomeSharedPreference.setHistoryTabHome(
                listItemTitleTab[index]);
          },
          tabBarView: <Widget>[
            JabarTodayScreen(dailyChartBloc: _dailyChartBloc),
            CovidInformationScreen(
              homeScreenState: this,
            ),
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
    if (_bannersBloc != null) {
      _bannersBloc.close();
    }
    if (_statisticsBloc != null) {
      _statisticsBloc.close();
    }
    if (_rapidTestBloc != null) {
      _rapidTestBloc.close();
    }
    if (_rapidTestAntigenBloc != null) {
      _rapidTestAntigenBloc.close();
    }
    if (_pcrTestBloc != null) {
      _pcrTestBloc.close();
    }
    if (_pcrTestIndividuBloc != null) {
      _pcrTestIndividuBloc.close();
    }
    if (_dailyChartBloc != null) {
      _dailyChartBloc.close();
    }

    super.dispose();
  }
}
