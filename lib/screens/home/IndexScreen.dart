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
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/InWebView.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/document/DocumentViewScreen.dart';
import 'package:pikobar_flutter/screens/faq/FaqScreen.dart';
import 'package:pikobar_flutter/screens/home/components/BottomSheetMenu.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/screens/infoGraphics/InfoGraphicsScreen.dart';
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
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';
import 'package:pikobar_flutter/utilities/NPSService.dart';
import 'package:pikobar_flutter/utilities/NotificationHelper.dart';
import 'package:pedantic/pedantic.dart';

class IndexScreen extends StatefulWidget {
  IndexScreen({Key key}) : super(key: key);

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
    removeOutDateLabelNew();
    loadNetPromoterScore();

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

    _firebaseMessaging.getToken().then((token) => print(token));

    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    firebaseInAppMsg.setAutomaticDataCollectionEnabled(true);
  }

  initializeFlutterDownloader() async {
    if (Platform.isAndroid) {
      await FlutterDownloader.initialize();
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
    } else if (Platform.isIOS) {
      await FlutterDownloader.initialize();
      final String _localPath =
          (await _findLocalPath()) + Platform.pathSeparator + 'images';
      final publicDownloadDir = Directory(_localPath);
      bool hasExistedPublicDownloadDir = await publicDownloadDir.exists();

      if (!hasExistedPublicDownloadDir) {
        publicDownloadDir.create();
      }

      final savedDir = Directory(_localPath);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  initializeToken() async {
    await AuthRepository().registerFCMToken();
    await AuthRepository().updateIdToken();
  }

  removeOutDateLabelNew() {
    LabelNew().removeData(Dictionary.labelInfoGraphic);
    LabelNew().removeData(Dictionary.labelNews);
    LabelNew().removeData(Dictionary.labelVideos);
    LabelNew().removeData(Dictionary.labelDocuments);
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
          // ignore: deprecated_member_use
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.home),
            ],
          )),
      BottomNavigationBarItem(
        icon: Icon(EvaIcons.messageCircleOutline, size: 24),
        // ignore: deprecated_member_use
        title: Text(Dictionary.message),
      ),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.questionMarkCircleOutline, size: 24),
          // ignore: deprecated_member_use
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text('Menu'),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.questionMarkCircleOutline, size: 24),
          // ignore: deprecated_member_use
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.help),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(EvaIcons.personOutline, size: 24),
          // ignore: deprecated_member_use
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
    } else if (data['target'] == 'infographics') {
      if (data['id'] != null &&
          data['id'] != 'null' &&
          data['type'] != null &&
          data['type'] != 'null') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailInfoGraphicScreen(
                  id: data['id'].toString().trim(),
                  infographicType: data['type'],
                )));
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => InfoGraphicsScreen()));
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
    } else if (data['target'] == 'self_reports') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SelfReportScreen(toNextScreen: true,)));
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
    } else if (data['target'] == 'documents') {
      if (data['url'] != null && data['url'] != 'null') {
        Platform.isAndroid
            ? _downloadAttachment(data['title'], data['url'])
            : _viewPdf(data['title'], data['url']);
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

  void _viewPdf(String title, String url) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InWebView(url: url, title: title)));

    await AnalyticsHelper.setLogEvent(Analytics.openDocument, <String, dynamic>{
      'name_document': title.length < 100 ? title : title.substring(0, 100),
    });
  }

  void _downloadAttachment(String name, String url) async {
    if (!await Permission.storage.status.isGranted) {
      unawaited(showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  'assets/icons/folder.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionDownloadAttachment,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  Permission.storage.request().then((val) {
                    _onStatusRequested(val, name, url);
                  });
                },
              )));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentViewScreen(
            url: url,
            nameFile: name,
          ),
        ),
      );

      await AnalyticsHelper.setLogEvent(
          Analytics.tappedDownloadDocuments, <String, dynamic>{
        'name_document': name.length < 100 ? name : name.substring(0, 100),
      });
    }
  }

  void _onStatusRequested(PermissionStatus statuses, String name, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(name, url);
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
                margin: EdgeInsets.only(bottom: 22.0),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF16A75C), Color(0xFF9BDBB3)],
                        transform: GradientRotation(45)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(0.0, 2.0), //(x,y)
                          blurRadius: 5.0,
                          spreadRadius: 0.0),
                    ],
                    border: Border.all(color: Colors.white, width: 4.0)),
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
              // ignore: deprecated_member_use
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

  loadNetPromoterScore() async {
    await NPSService.loadNetPromoterScore(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
