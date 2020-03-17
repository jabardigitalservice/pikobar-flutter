import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'BannerListSlider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _mainRefreshController = RefreshController();

  String odpCount = '';
  String pdpCount = '';
  String positifCount = '';

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  _buildButtonColumn(String iconPath, String label, String route) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2.0),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                color: Colors.black.withOpacity(.2),
                offset: Offset(2.0, 4.0),
              ),
            ], borderRadius: BorderRadius.circular(12.0), color: Colors.white),
            child: IconButton(
              color: Theme.of(context).textTheme.body1.color,
              icon: Image.asset(iconPath),
              onPressed: () {
                if (route != null) {
                  Navigator.pushNamed(context, route);
                }
              },
            ),
          ),
          SizedBox(height: 12.0),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).textTheme.body1.color,
              ))
        ],
      ),
    );
  }

  _buildButtonColumnLayananLain(String iconPath, String label) {
    return Expanded(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(.2),
                  offset: Offset(2.0, 2.0),
                ),
              ], borderRadius: BorderRadius.circular(12.0), color: Colors.white),
              child: IconButton(
                color: Theme.of(context).textTheme.body1.color,
                icon: Image.asset(iconPath),
                onPressed: () {
                  _mainHomeBottomSheet(context);
                },
              ),
            ),
            SizedBox(height: 12.0),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.body1.color,
                ))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget firstRowShortcuts = Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}emergency_numbers.png',
              Dictionary.phoneBookEmergency, NavigationConstrants.Phonebook),
          _buildButtonColumn(
              '${Environment.iconAssets}pikobar.png', Dictionary.pikobar, ''),
          _buildButtonColumn(
              '${Environment.iconAssets}logistic.png', Dictionary.logistic, ''),
          _buildButtonColumn(
              '${Environment.iconAssets}virus.png', Dictionary.kawalCorona, ''),
        ],
      ),
    );

    Widget secondRowShortcuts = Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn(
              '${Environment.iconAssets}completed.png', Dictionary.survey, ''),
          _buildButtonColumn(
              '${Environment.iconAssets}network.png', Dictionary.selfDiagnose, ''),
          _buildButtonColumn('${Environment.iconAssets}network.png',
              Dictionary.selfTracing, ''),

          _buildButtonColumn('${Environment.iconAssets}menu-other.png',
              Dictionary.otherMenus, ''),
          /*_buildButtonColumnLayananLain(
              '${Environment.iconAssets}menu-other.png', Dictionary.otherMenus),*/
        ],
      ),
    );

    Widget topContainer = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          //            blurRadius: 5,
          offset: Offset(0.0, 0.05),
        ),
      ]),
      child: Column(
        children: <Widget>[
          firstRowShortcuts,
          SizedBox(
            height: 8.0,
          ),
          secondRowShortcuts
        ],
      ),
    );

    return Scaffold(
      backgroundColor: ColorBase.grey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: ColorBase.green,
        title: Row(
          children: <Widget>[
            Image.asset('${Environment.logoAssets}logo.png',
                width: 35.0, height: 35.0),
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Dictionary.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.intro,
                      ),
                    ),
                    Text(
                      Dictionary.provJabar,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.intro,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            color: ColorBase.green,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: SmartRefresher(
                  controller: _mainRefreshController,
                  enablePullDown: true,
                  header: WaterDropMaterialHeader(),
                  onRefresh: () async {
                    _mainRefreshController.refreshCompleted();
                  },
                  child: ListView(children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: BannerListSlider()),
                    Container(
                        margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                        child: Statistics(odpCount: odpCount,
                            pdpCount: pdpCount,
                            positifCount: positifCount)),
                    topContainer,
                    SizedBox(
                      height: 8.0,
                      child: Container(
                        color: Color(0xFFE5E5E5),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          // ImportantInfoListHome(),
                          // Container(
                          //              padding: EdgeInsets.all(15.0),
                          //              child: Row(
                          //                mainAxisAlignment:
                          //                    MainAxisAlignment.spaceBetween,
                          //                children: <Widget>[
                          //                  Text(
                          //                    Dictionary.titleHumasJabar,
                          //                    style: TextStyle(
                          //                        color:
                          //                            Color.fromRGBO(0, 0, 0, 0.73),
                          //                        fontWeight: FontWeight.bold,
                          //                        fontFamily:
                          //                            FontsFamily.productSans,
                          //                        fontSize: 18.0),
                          //                  ),
                          //                  TextButton(
                          //                    title: Dictionary.viewAll,
                          //                    textStyle: TextStyle(
                          //                        color: Colors.green,
                          //                        fontWeight: FontWeight.w600,
                          //                        fontSize: 13.0),
                          //                    onTap: () {
                          //                      Navigator.push(
                          //                        context,
                          //                        MaterialPageRoute(
                          //                          builder: (context) =>
                          //                              BrowserScreen(
                          //                            url: UrlThirdParty
                          //                                .newsHumasJabarTerkini,
                          //                          ),
                          //                        ),
                          //                      );

                          //                      AnalyticsHelper.setLogEvent(
                          //                        Analytics.EVENT_VIEW_LIST_HUMAS,
                          //                      );
                          //                    },
                          //                  ),
                          //                ],
                          //              ),
                          //            ),
                          //            HumasJabarListScreen(),
                          //            Container(
                          //              child: Column(
                          //                crossAxisAlignment:
                          //                    CrossAxisAlignment.start,
                          //                children: <Widget>[
                          //                  ListTile(
                          //                    leading: Text(
                          //                      Dictionary.news,
                          //                      style: TextStyle(
                          //                          color: Color.fromRGBO(
                          //                              0, 0, 0, 0.73),
                          //                          fontWeight: FontWeight.bold,
                          //                          fontFamily:
                          //                              FontsFamily.productSans,
                          //                          fontSize: 18.0),
                          //                    ),
                          //                  ),
                          //                  SingleChildScrollView(
                          //                    scrollDirection: Axis.horizontal,
                          //                    child: Row(
                          //                      crossAxisAlignment:
                          //                          CrossAxisAlignment.start,
                          //                      children: <Widget>[
                          //                        NewsListScreen(isIdKota: false),
                          //                        NewsListScreen(isIdKota: true)
                          //                      ],
                          //                    ),
                          //                  ),
                          //                ],
                          //              ),
                          //            ),
                          Container(
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: <Widget>[
                                  TabBar(
                                    labelColor: Colors.black,
                                    tabs: <Widget>[
                                      Tab(text: Dictionary.liveUpdate),
                                      Tab(text: Dictionary.persRilis),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    height: 390,
                                    child: TabBarView(
                                      children: <Widget>[
                                        NewsScreen(
                                            isLiveUpdate: true, maxLength: 3),
                                        NewsScreen(
                                            isLiveUpdate: false, maxLength: 3),
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
                          //            Container(
                          //              padding:
                          //                  EdgeInsets.symmetric(vertical: 16.0),
                          //              child: VideoListKokab(),
                          //            )
                        ],
                      ),
                    )
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _mainHomeBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        elevation: 60.0,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 14.0),
                      color: Colors.black,
                      height: 1.5,
                      width: 40.0,
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: Dimens.padding, top: 10.0),
                  child: Text(
                    Dictionary.otherMenus,
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      offset: Offset(0.0, 0.05),
                    ),
                  ]),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildButtonColumn(
                                '${Environment.iconAssets}pikobar.png',
                                Dictionary.survey,
                                NavigationConstrants.infoPKB),
                            _buildButtonColumn(
                                '${Environment.iconAssets}pikobar.png',
                                Dictionary.saberHoax,
                                NavigationConstrants.SaberHoax),
                            _buildButtonColumn(
                                '${Environment.iconAssets}pikobar.png',
                                Dictionary.survey,
                                NavigationConstrants.AdministrationList),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 8.0,
                      ),
                      // secondRowShortcuts
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void _loadStatistics() {
    Firestore.instance
        .collection('statistics')
        .document('jabar-dan-nasional')
        .get()
        .then((DocumentSnapshot ds) {
      odpCount = ds['odp']['total']['jabar'] != null
          ? '${ds['odp']['total']['jabar']}'
          : '-';
      pdpCount = ds['pdp']['total']['jabar'] != null
          ? '${ds['pdp']['total']['jabar']}'
          : '-';
      positifCount =
      ds['aktif']['jabar'] != null ? '${ds['aktif']['jabar']}' : '-';

      setState(() {});
    },
        onError: (error) {
          odpCount = '-';
          pdpCount = '-';
          positifCount = '-';
          setState(() {});
        });
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
