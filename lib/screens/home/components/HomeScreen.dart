import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/MenuList.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/SpreadSection.dart';
import 'package:pikobar_flutter/screens/home/components/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/checkVersion.dart';

import 'BannerListSlider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.home);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.notifications, size: 20.0, color: Colors.white),
          //   onPressed: () {
          //     Scaffold.of(context).showSnackBar(SnackBar(
          //       content: Text(Dictionary.onDevelopment),
          //       duration: Duration(seconds: 1),
          //     ));

          //     AnalyticsHelper.setLogEvent(Analytics.tappedNotification);
          //   },
          // )
        ],
      ),
      body: FutureBuilder<RemoteConfig>(
          future: setupRemoteConfig(),
          builder: (BuildContext context,
              AsyncSnapshot<RemoteConfig> snapshot) {
            return snapshot.hasData ? buildContent(snapshot.data):Container();
          }),
    );
  }

  Widget buildContent(RemoteConfig remoteConfig) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.15,
          color: ColorBase.green,
        ),
        Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: [

                /// Banners Section
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: BannerListSlider()),

                /// Statistics Announcement
                AnnouncementScreen(remoteConfig),

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
                    MenuList(remoteConfig),

                    /// Spread Section
                    SpreadSection(remoteConfig),
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
                                    AnalyticsHelper.setLogEvent(
                                        Analytics.tappedNewsJabar);
                                  } else if (index == 1) {
                                    AnalyticsHelper.setLogEvent(
                                        Analytics.tappedNewsNational);
                                  } else if (index == 2) {
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
                                  children: <Widget>[
                                    NewsScreen(
                                        news: Dictionary.latestNews,
                                        maxLength: 3),
                                    NewsScreen(
                                        news: Dictionary.nationalNews,
                                        maxLength: 3),
                                    NewsScreen(
                                        news: Dictionary.worldNews,
                                        maxLength: 3),
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
                    ],
                  ),
                )
              ]),
            )
          ],
        )
      ],
    );
  }


  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      FirebaseConfig.jshCaption: Dictionary.saberHoax,
      FirebaseConfig.jshUrl: UrlThirdParty.urlIGSaberHoax,
      FirebaseConfig.pikobarCaption: Dictionary.pikobar,
      FirebaseConfig.pikobarUrl: UrlThirdParty.urlCoronaInfo,
      FirebaseConfig.worldInfoCaption: Dictionary.worldInfo,
      FirebaseConfig.worldInfoUrl: UrlThirdParty.urlWorldCoronaInfo,
      FirebaseConfig.nationalInfoCaption: Dictionary.nationalInfo,
      FirebaseConfig.nationalInfoUrl: UrlThirdParty.urlCoronaEscort,
      FirebaseConfig.donationCaption: Dictionary.donation,
      FirebaseConfig.donationUrl: UrlThirdParty.urlDonation,
      FirebaseConfig.logisticCaption: Dictionary.logistic,
      FirebaseConfig.logisticUrl: UrlThirdParty.urlLogisticsInfo,
      FirebaseConfig.reportEnabled: false,
      FirebaseConfig.reportCaption: Dictionary.caseReport,
      FirebaseConfig.reportUrl: UrlThirdParty.urlCaseReport,
      FirebaseConfig.qnaEnabled: false,
      FirebaseConfig.qnaCaption: Dictionary.qna,
      FirebaseConfig.qnaUrl: UrlThirdParty.urlQNA,
      FirebaseConfig.selfTracingEnabled: false,
      FirebaseConfig.selfTracingCaption: Dictionary.selfTracing,
      FirebaseConfig.selfTracingUrl: UrlThirdParty.urlSelfTracing,
      FirebaseConfig.volunteerEnabled: false,
      FirebaseConfig.volunteerCaption: Dictionary.volunteer,
      FirebaseConfig.volunteerUrl: UrlThirdParty.urlVolunteer,
      FirebaseConfig.selfDiagnoseEnabled: false,
      FirebaseConfig.selfDiagnoseCaption: Dictionary.selfDiagnose,
      FirebaseConfig.selfDiagnoseUrl: UrlThirdParty.urlSelfDiagnose,
      FirebaseConfig.spreadCheckLocation: '',
      FirebaseConfig.announcement: false,
    });

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();

      checkVersion(context, remoteConfig);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    return remoteConfig;
  }

  @override
  void deactivate() {
//     _notificationBadgeBloc.add(CheckNotificationBadge());
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
