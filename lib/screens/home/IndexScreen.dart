import 'dart:convert';
import 'dart:io';

import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/components/DialogUpdateApp.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/screens/faq/FaqScreen.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/messages/messages.dart';
import 'package:pikobar_flutter/screens/myAccount/myAccount.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/screens/news/NewsDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/AnnouncementSharedPreference.dart';
import 'package:pikobar_flutter/utilities/NotificationHelper.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FirebaseInAppMessaging firebaseInAppMsg = FirebaseInAppMessaging();

  int _currentIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;

  @override
  void initState() {
    initializeDateFormatting();

    // checkAppVersion();
    _initializeBottomNavigationBar();
    setStatAnnouncement();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        NotificationHelper().showNotification(
            message['notification']['title'], message['notification']['body'],
            payload: jsonEncode(message['data']),
            onSelectNotification: onSelectNotification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _actionNotification(jsonEncode(message['data']));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _actionNotification(jsonEncode(message['data']));
      },
    );

//    _firebaseMessaging.getToken().then((token) => print(token));

    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    firebaseInAppMsg.setAutomaticDataCollectionEnabled(true);

    super.initState();
  }

   setStatAnnouncement()async{
    await AnnouncementSharedPreference.setAnnounceScreen(true);
  }

  Future<void> checkAppVersion() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    String appVersion;
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
    });

    if (Platform.isAndroid) {
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();

      bool forceUpdateRequired =
          remoteConfig.getString(FirebaseConfig.forceUpdateRequired) == 'false'
              ? false
              : true;
      String storeUrl = remoteConfig.getString(FirebaseConfig.storeUrl);
      String currentVersion =
          remoteConfig.getString(FirebaseConfig.currentVersion);

      if (forceUpdateRequired && appVersion != currentVersion) {
        showDialog(
            context: context,
            builder: (context) => WillPopScope(
                onWillPop: () {
                  return;
                },
                child: DialogUpdateApp(
                  linkUpdate: storeUrl,
                )),
            barrierDismissible: false);
      }
    }
  }

  _initializeBottomNavigationBar() {
    badger = BottomNavigationBadge(
        backgroundColor: Colors.red,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 8);

    items = [
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.home, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.home),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidEnvelope, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.message),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidQuestionCircle, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.help),
            ],
          )),

           BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.profile),
            ],
          )),
    ];
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);

      _actionNotification(payload);

    }
  }

  _actionNotification(String payload) {
    final data = jsonDecode(payload);
    if (data['target'] == 'news') {
      String newsType;

      switch (data['type']) {
        case NewsType.articles :
          newsType = Dictionary.latestNews;
          break;

        case NewsType.articlesNational :
          newsType = Dictionary.nationalNews;
          break;

        case NewsType.articlesWorld :
          newsType = Dictionary.worldNews;
          break;

        default:
          newsType = Dictionary.latestNews;
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewsDetailScreen(
            id: data['id'],
            news: newsType,
            isFromNotification: true,
          )));
    } else if (data['target'] == 'broadcast') {

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessageDetailScreen(
            id: data['id'],
            isFromNotification: true,
          )));
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainScaffold(context);
  }

  _buildMainScaffold(BuildContext context) {
    return Scaffold(
      body: _buildContent(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: items),
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        AnalyticsHelper.setLogEvent(Analytics.tappedMessage);
        return Messages();

      case 2:
        AnalyticsHelper.setLogEvent(Analytics.tappedFaq);
        return FaqScreen();

         case 3:
        return MyAccount();

      default:
        return HomeScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
