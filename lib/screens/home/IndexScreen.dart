
import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/faq/FaqScreen.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/messages/messages.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  int _currentIndex = 0;

  BottomNavigationBadge badger;
  List<BottomNavigationBarItem> items;

  @override
  void initState() {
    initializeDateFormatting();

    _initializeBottomNavigationBar();

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     NotificationHelper().showNotification(
    //         message['notification']['title'], message['notification']['body'],
    //         payload: jsonEncode(message['data']).toString(),
    //         onSelectNotification: onSelectNotification);

    //     _checkNotification();

    //     if (message['data']['target'] == 'broadcast') {
    //       _checkUnread();
    //     }
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     _actionNotification(jsonEncode(message['data']).toString());
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     _actionNotification(jsonEncode(message['data']).toString());
    //   },
    // );

    // _firebaseMessaging.getToken().then((token) => print(token));

    // _firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true));

    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 500), () {
        _checkUnread();
        _checkNotification();
      });
    });*/

    super.initState();
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
          icon: Icon(FontAwesomeIcons.envelopeOpen, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.message),
            ],
          )),
      BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.questionCircle, size: 16),
          title: Column(
            children: <Widget>[
              SizedBox(height: 4),
              Text(Dictionary.help),
            ],
          )),
    ];
  }

  // Future<void> onSelectNotification(String payload) async {
  //   if (payload != null) {
  //     debugPrint('notification payload: ' + payload);
  //     _actionNotification(payload);
  //   }
  // }

  // _actionNotification(String payload) {
  //   final data = json.decode(payload);
  //   if (data['target'] == 'notifikasi') {
  //     switch (jsonDecode(data['meta'])['target'].toString()) {
  //       case 'polling':
  //         _openDetailPolling(jsonDecode(data['meta'])['id']);
  //         break;
  //       case 'survey':
  //         _openDetailSurvey(url: jsonDecode(data['meta'])['url']);
  //         break;
  //       case 'news':
  //         _openDetailNews(jsonDecode(data['meta'])['id']);
  //         break;
  //       case 'saber-hoax':
  //         _openDetailSaberHoax(jsonDecode(data['meta'])['id']);
  //         break;
  //       case 'aspirasi':
  //         _openDetailUsulan(jsonDecode(data['meta'])['id']);
  //         break;
  //       case 'news-important':
  //         _openDetailImportantInfo(jsonDecode(data['meta'])['id']);
  //         break;
  //       case 'user-post':
  //         _openDetailRwActivities(
  //             jsonDecode(data['meta'])['id'], data['title']);
  //         break;
  //       case 'url':
  //         _launchURL(jsonDecode(data['meta'])['url']);
  //         break;
  //     }
  //   }

  //   if (data['target'] == 'broadcast') {
  //     print('id = ' + data['id']);
  //     _openDetailBroadcast(jsonDecode(data['id']));
  //   }

  //   if (data['target'] == 'url') {
  //     _launchURL(jsonDecode(data['meta'])['url']);
  //   }
  // }

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

      case 3:
      // return ProfileScreen();

      default:
        return HomeScreen();
    }
  }

  // _checkUnread() async {
  //   try {
  //     await BroadcastRepository().fetchRecords(1);
  //     await _messageBadgeBloc.add(CheckMessageBadge(fromNotification: true));
  //   } catch (_) {}
  // }

  // _checkNotification() async {
  //   try {
  //     await NotificationRepository().fetchRecords(1);
  //     await _notificationBadgeBloc.add(CheckNotificationBadge());
  //   } catch (_) {}
  // }

  // _actionPopupInformation(PopupInformationModel record) {
  //   if (record.type == 'internal') {
  //     switch (record.internalObjectType) {
  //       case 'news':
  //         _openDetailNews(record.internalObjectId);
  //         break;

  //       case 'polling':
  //         _openDetailPolling(record.internalObjectId);
  //         break;

  //       case 'survey':
  //         _openDetailSurvey(id: record.internalObjectId);
  //         break;

  //       case 'saber-hoax':
  //         _openDetailSaberHoax(record.internalObjectId);
  //         break;
  //       case 'gamification':
  //         _openGamification();
  //         break;
  //     }
  //   } else {
  //     _openInAppBrowser(record.linkUrl);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
