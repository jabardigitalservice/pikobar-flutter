import 'dart:io';

import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/components/DialogUpdateApp.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/faq/FaqScreen.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/messages/messages.dart';
import 'package:pikobar_flutter/utilities/NotificationHelper.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;

  @override
  void initState() {
    initializeDateFormatting();

    checkAppVersion();
    _initializeBottomNavigationBar();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        NotificationHelper().showNotification(
            message['notification']['title'], message['notification']['body'],
            payload: 'payload', onSelectNotification: onSelectNotification);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    //_firebaseMessaging.getToken().then((token) => print(token));

    _firebaseMessaging.subscribeToTopic('general');

    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));

    super.initState();
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

      print(remoteConfig.getString('force_update_current_version'));
      print('versi device $appVersion');
      if (appVersion !=
          remoteConfig.getString('force_update_current_version')) {
        _showAlert(context, remoteConfig.getString('force_update_store_url'));
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
    ];
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
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
        return Messages();

      case 2:
        return FaqScreen();

      default:
        return HomeScreen();
    }
  }

  void _showAlert(BuildContext context, String urlStore) {
    showDialog(
        context: context,
        builder: (context) => WillPopScope(
            onWillPop: () {
              return;
            },
            child: DialogUpdateApp(
              linkUpdate: urlStore,
            )),
        barrierDismissible: false);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
