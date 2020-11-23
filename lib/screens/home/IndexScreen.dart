import 'dart:convert';
import 'dart:io';

import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/faq/FaqScreen.dart';
import 'package:pikobar_flutter/screens/home/components/BottomSheetMenu.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/messages/messages.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/screens/myAccount/ProfileScreen.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/screens/news/NewsDetailScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationDetailScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/DeviceUpdateHelper.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';
import 'package:pikobar_flutter/utilities/NotificationHelper.dart';

class IndexScreen extends StatefulWidget {
  @override
  IndexScreenState createState() => IndexScreenState();
}

class IndexScreenState extends State<IndexScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FirebaseInAppMessaging firebaseInAppMsg = FirebaseInAppMessaging();

  int _currentIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;
  int countMessage = 0;
  DateTime currentBackPressTime;

  bool showAllMenus = true;

  @override
  void initState() {
    initializeBackgroundLocation();
    initializeFirebaseMessaging();
    initializeDateFormatting();
    initializePlatformState();
    initializeFlutterDownloader();
    initializeBottomNavigationBar();
    initializeToken();
    getCountMessage();

    super.initState();
  }

  initializeFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (message['notification'] != null) {
          NotificationHelper().showNotification(
              message['notification']['title'], message['notification']['body'],
              payload:
                  jsonEncode(Platform.isAndroid ? message['data'] : message),
              onSelectNotification: onSelectNotification);
        } else {
          NotificationHelper().showNotification(
              message['aps']['alert']['title'], message['aps']['alert']['body'],
              payload:
                  jsonEncode(Platform.isAndroid ? message['data'] : message),
              onSelectNotification: onSelectNotification);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _actionNotification(
            jsonEncode(Platform.isAndroid ? message['data'] : message));
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _actionNotification(
            jsonEncode(Platform.isAndroid ? message['data'] : message));
      },
    );

    // _firebaseMessaging.getToken().then((token) => print(token));

    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    firebaseInAppMsg.setAutomaticDataCollectionEnabled(true);
  }

  initializeFlutterDownloader() async {
    await FlutterDownloader.initialize();
    if (Platform.isAndroid) {
      String localPath =
          (await getExternalStorageDirectory()).path + '/download';
      final publicDownloadDir = Directory(Environment.downloadStorage);
      final savedDir = Directory(localPath);
      bool hasExistedPublicDownloadDir = await publicDownloadDir.exists();
      bool hasExistedSavedDir = await savedDir.exists();
      if (!hasExistedPublicDownloadDir) {
        publicDownloadDir.create();
      }
      if (!hasExistedSavedDir) {
        savedDir.create();
      }
    }
  }

  initializeToken() async {
    await AuthRepository().registerFCMToken();
    await AuthRepository().updateIdToken();
  }

  initializeBottomNavigationBar() {
    badger = BottomNavigationBadge(
        backgroundColor: Colors.red,
        badgeShape: BottomNavigationBadgeShape.circle,
        textColor: Colors.white,
        position: BottomNavigationBadgePosition.topRight,
        textSize: 8);

    items = [
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.homeOutline, size: 24),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.home),
            ],
          )),
      BottomNavigationBarItem(
        icon: Icon(EvaIcons.messageCircleOutline, size: 24),
        title: Text(Dictionary.message),
      ),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.questionMarkCircleOutline, size: 24),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text('Menu'),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.questionMarkCircleOutline, size: 24),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.help),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.personOutline, size: 24),
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

  _actionNotification(String payload) async {
    final data = jsonDecode(payload);
    if (data['target'] == 'news') {
      String newsType;

      switch (data['type']) {
        case NewsType.articles:
          newsType = Dictionary.latestNews;
          break;

        case NewsType.articlesNational:
          newsType = Dictionary.nationalNews;
          break;

        case NewsType.articlesWorld:
          newsType = Dictionary.worldNews;
          break;

        default:
          newsType = Dictionary.latestNews;
      }

      if (data['id'] != null && data['id'] != 'null') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
                  id: data['id'].toString().trim(),
                  news: newsType,
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsListScreen(news: newsType)));
      }
    } else if (data['target'] == 'broadcast') {
      if (data['id'] != null && data['id'] != 'null') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                MessageDetailScreen(id: data['id'].toString().trim())));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Messages(indexScreenState: this)));
      }
    } else if (data['target'] == 'important_info') {
      if (data['id'] != null && data['id'] != 'null') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
                  id: data['id'].toString().trim(),
                  news: Dictionary.importantInfo,
                )));
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                NewsListScreen(news: Dictionary.importantInfo)));
      }
    } else if (data['target'] == 'content_education') {
      if (data['id'] != null && data['id'] != 'null') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EducationDetailScreen(
                  id: data['id'].toString().trim(),
                  educationCollection: kEducationContent,
                )));
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SelfReportScreen()));
      }
    } else if (data['target'] == 'url') {
      if (data['url'] != null && data['url'] != 'null') {
        await launchUrl(context: context, url: data['url']);
      }
    }
  }

  void onTabTapped(int index) {
    if (index != 2) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: WillPopScope(
            child: _buildContent(_currentIndex),
            onWillPop: onWillPop,
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                type: BottomNavigationBarType.fixed,
                items: items),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.only(bottom: 30.0),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFF16A75C),
                          Color(0xFF9BDBB3)
                        ],
                        transform: GradientRotation(45)
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(0.0, 2.0), //(x,y)
                          blurRadius: 5.0,
                          spreadRadius: 0.0
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 4.0)
                ),
                child: Image.asset('${Environment.iconAssets}menu.png'),
              ),
              onTap: () {
                BottomSheetMenu.showBottomSheetMenu(context: context);
              },
            ),
          ),
        )
      ],
    );
  }

  /// Function double tap back when close from apps
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: Dictionary.infoTapBack);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return HomeScreen(indexScreenState: this);
      case 1:
        AnalyticsHelper.setLogEvent(Analytics.tappedMessage);
        return Messages(indexScreenState: this);
      case 3:
        AnalyticsHelper.setLogEvent(Analytics.tappedFaq);
        return FaqScreen(isNewPage: false);
      case 4:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  getCountMessage() {
    Future.delayed(Duration(milliseconds: 0), () async {
      countMessage = await MessageRepository().hasUnreadData();
      setState(() {
        // ignore: unnecessary_statements
        if (countMessage <= 0) {
          items[1] = BottomNavigationBarItem(
              icon: Icon(EvaIcons.messageCircleOutline, size: 24),
              title: Column(
                children: <Widget>[
                  SizedBox(height: 4),
                  Text(Dictionary.message),
                ],
              ));
        } else {
          items = badger.setBadge(items, countMessage.toString(), 1);
        }
      });
    });
  }

  initializeBackgroundLocation() async {
    await LocationService.initializeBackgroundLocation(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
