import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/Statistics.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BannerListSlider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  _buildButtonColumn(String iconPath, String label, String route,
      {Object arguments}) {
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
            ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
            child: IconButton(
              color: Theme.of(context).textTheme.body1.color,
              icon: Image.asset(iconPath),
              onPressed: () {
                if (route != null) {
                  switch (route) {
                    case UrlThirdParty.urlCoronaEscort:
                      _launchUrl(route);
                      break;
                    case UrlThirdParty.urlIGSaberHoax:
                      _launchUrl(route);
                      break;
                    default:
                      Navigator.pushNamed(context, route, arguments: arguments);
                  }
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

  _buildButtonDisable(String iconPath, String label) {
    return Expanded(
      child: GestureDetector(
        child: Column(
          children: [
            Stack(children: [
              Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        color: Colors.black.withOpacity(.2),
                        offset: Offset(2.0, 4.0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white),
                child: IconButton(
                  color: Theme.of(context).textTheme.body1.color,
                  icon: Image.asset(iconPath),
                  onPressed: null,
                ),
              ),
              Positioned(
                  right: 2.0,
                  child: Image.asset(
                    '${Environment.iconAssets}bookmark_1.png',
                    width: 18.0,
                    height: 18.0,
                  ))
            ]),
            SizedBox(height: 12.0),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).textTheme.body1.color,
                ))
          ],
        ),
        onTap: () {
          if (label == Dictionary.qna) {
            Fluttertoast.showToast(
                msg: Dictionary.onDevelopment,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(Dictionary.onDevelopment),
              duration: Duration(seconds: 1),
            ));
          }
        },
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
          ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
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
          _buildButtonColumn('${Environment.iconAssets}pikobar.png',
              Dictionary.pikobar, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlCoronaInfo),
          _buildButtonColumn('${Environment.iconAssets}logistic.png',
              Dictionary.logistic, NavigationConstrants.Browser,
              arguments: UrlThirdParty.urlLogisticsInfo),
          _buildButtonColumn('${Environment.iconAssets}virus.png',
              Dictionary.kawalCorona, UrlThirdParty.urlCoronaEscort),
        ],
      ),
    );

    Widget secondRowShortcuts = Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildButtonColumn('${Environment.iconAssets}completed.png',
              Dictionary.survey, NavigationConstrants.Survey),
          _buildButtonDisable('${Environment.iconAssets}magnifying_glass.png',
              Dictionary.selfDiagnose),
          _buildButtonDisable(
              '${Environment.iconAssets}network.png', Dictionary.selfTracing),
          _buildButtonColumnLayananLain(
              '${Environment.iconAssets}menu_other.png', Dictionary.otherMenus),
        ],
      ),
    );

    Widget topContainer = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(Dimens.padding, 10.0, Dimens.padding, 20.0),
      decoration: BoxDecoration(
        color: ColorBase.grey,
          boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          //            blurRadius: 5,
          offset: Offset(0.0, 0.05),
        ),
      ]),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              Dictionary.menus,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.productSans,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(height: Dimens.padding),
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
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        Dictionary.provJabar,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.productSans,
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications,
                size: 20.0, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(Dictionary.onDevelopment),
                duration: Duration(seconds: 1),
              ));
            },
          )
        ],
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
                child: ListView(children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                      child: BannerListSlider()),
                  Container(
                    color: ColorBase.grey,
                      margin: EdgeInsets.only(top: 10.0),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Statistics()),
                  topContainer,
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
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
                                  height: 400,
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
                      ],
                    ),
                  )
                ]),
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
                                '${Environment.iconAssets}saber_hoax.png',
                                Dictionary.saberHoax,
                                UrlThirdParty.urlIGSaberHoax),
                            _buildButtonColumn(
                                '${Environment.iconAssets}world.png',
                                Dictionary.worldInfo,
                                NavigationConstrants.Browser,
                                arguments: UrlThirdParty.urlWorldCoronaInfo),
                            _buildButtonDisable(
                                '${Environment.iconAssets}conversation.png',
                                Dictionary.qna),
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

  _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
