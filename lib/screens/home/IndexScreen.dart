// import 'dart:convert';
// import 'dart:io';

// import 'package:bottom_navigation_badge/bottom_navigation_badge.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:pedantic/pedantic.dart';
// import 'package:pikobar_flutter/configs/FlavorBanner.dart';
// import 'package:pikobar_flutter/constants/Dictionary.dart';
// // import 'package:sapawarga/blocs/force_change_profile/Bloc.dart';
// // import 'package:sapawarga/blocs/message_badge/Bloc.dart';
// // import 'package:sapawarga/blocs/notification/Bloc.dart';
// // import 'package:sapawarga/blocs/popup_information/Bloc.dart';
// // import 'package:sapawarga/blocs/showcase_home/Bloc.dart';
// // import 'package:sapawarga/blocs/update_app/Bloc.dart';
// // import 'package:sapawarga/components/DialogInformation.dart';
// // import 'package:sapawarga/components/DialogUpdateApp.dart';
// // import 'package:sapawarga/components/LoadingScreen.dart';
// // import 'package:sapawarga/configs/FlavorBanner.dart';
// // import 'package:sapawarga/constants/Analytics.dart';
// // import 'package:sapawarga/constants/Dictionary.dart';
// // import 'package:sapawarga/constants/Navigation.dart';
// // import 'package:sapawarga/enums/ChangePasswordType.dart';
// // import 'package:sapawarga/exceptions/CustomException.dart';
// // import 'package:sapawarga/models/CounterHoaxModel.dart';
// // import 'package:sapawarga/models/NewsDetailArgumentsModel.dart';
// // import 'package:sapawarga/models/PollingModel.dart';
// // import 'package:sapawarga/models/PopupInformationModel.dart';
// // import 'package:sapawarga/models/UserInfoModel.dart';
// // import 'package:sapawarga/repositories/AuthProfileRepository.dart';
// // import 'package:sapawarga/repositories/BroadcastRepository.dart';
// // import 'package:sapawarga/repositories/CounterHoaxRepository.dart';
// // import 'package:sapawarga/repositories/NotificationRepository.dart';
// // import 'package:sapawarga/repositories/PollingRepository.dart';
// // import 'package:sapawarga/repositories/PopupInformationRepository.dart';
// // import 'package:sapawarga/repositories/SurveyRepository.dart';
// // import 'package:sapawarga/repositories/UpdateAppRepository.dart';
// // import 'package:sapawarga/screens/broadcast/BroadcastListScreen.dart';
// // import 'package:sapawarga/screens/changePassword/ChangePasswordScreen.dart';
// // import 'package:sapawarga/screens/completeProfile/CompleteProfileScreen.dart';
// // import 'package:sapawarga/screens/importantInformation/ImportantInfoDetailScreen.dart';
// // import 'package:sapawarga/screens/main/account/ProfileScreen.dart';
// // import 'package:sapawarga/screens/main/help/HelpScreen.dart';
// // import 'package:sapawarga/screens/main/home/HomeScreen.dart';
// // import 'package:sapawarga/screens/rwActivities/RWActivityDetailScreen.dart';
// // import 'package:sapawarga/screens/usulan/DetailUsulanScreen.dart';
// // import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// // import 'package:sapawarga/utilities/NotificationHelper.dart';
// // import 'package:url_launcher/url_launcher.dart';

// class IndexScreen extends StatefulWidget {
//   @override
//   _IndexScreenState createState() => _IndexScreenState();
// }

// class _IndexScreenState extends State<IndexScreen> {
//   // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//   int _currentIndex = 0;
//   // UpdateAppBloc _updateAppBloc;
//   // ForceChangeProfileBloc _changePasswordBloc;
//   // PopupInformationBloc _popupInformationBloc;
//   // MessageBadgeBloc _messageBadgeBloc;
//   // NotificationBadgeBloc _notificationBadgeBloc;
//   // ShowcaseHomeBloc _showcaseHomeBloc;

//   BottomNavigationBadge badger;
//   List<BottomNavigationBarItem> items;

//   @override
//   void initState() {
//     initializeDateFormatting();

//     _sendFirebaseUserProperties();

//     _initializeBottomNavigationBar();

//     // _firebaseMessaging.configure(
//     //   onMessage: (Map<String, dynamic> message) async {
//     //     print("onMessage: $message");
//     //     NotificationHelper().showNotification(
//     //         message['notification']['title'], message['notification']['body'],
//     //         payload: jsonEncode(message['data']).toString(),
//     //         onSelectNotification: onSelectNotification);

//     //     _checkNotification();

//     //     if (message['data']['target'] == 'broadcast') {
//     //       _checkUnread();
//     //     }
//     //   },
//     //   onLaunch: (Map<String, dynamic> message) async {
//     //     print("onLaunch: $message");
//     //     _actionNotification(jsonEncode(message['data']).toString());
//     //   },
//     //   onResume: (Map<String, dynamic> message) async {
//     //     print("onResume: $message");
//     //     _actionNotification(jsonEncode(message['data']).toString());
//     //   },
//     // );

//     // _firebaseMessaging.getToken().then((token) => print(token));

//     // _firebaseMessaging.requestNotificationPermissions(
//     //     IosNotificationSettings(sound: true, badge: true, alert: true));

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(Duration(milliseconds: 500), () {
//         _checkUnread();
//         _checkNotification();
//       });
//     });

//     super.initState();
//   }

//   _initializeBottomNavigationBar() {
//     badger = BottomNavigationBadge(
//         backgroundColor: Colors.red,
//         badgeShape: BottomNavigationBadgeShape.circle,
//         textColor: Colors.white,
//         position: BottomNavigationBadgePosition.topRight,
//         textSize: 8);

//     items = [
//       BottomNavigationBarItem(
//           icon: Icon(FontAwesomeIcons.home, size: 16),
//           title: Column(
//             children: <Widget>[
//               SizedBox(height: 4),
//               Text(Dictionary.home),
//             ],
//           )),
//       BottomNavigationBarItem(
//           icon: Icon(FontAwesomeIcons.envelopeOpen, size: 16),
//           title: Column(
//             children: <Widget>[
//               SizedBox(height: 4),
//               Text(Dictionary.message),
//             ],
//           )),
//       BottomNavigationBarItem(
//           icon: Icon(FontAwesomeIcons.questionCircle, size: 16),
//           title: Column(
//             children: <Widget>[
//               SizedBox(height: 4),
//               Text(Dictionary.help),
//             ],
//           )),
//       BottomNavigationBarItem(
//           icon: Icon(FontAwesomeIcons.user, size: 16),
//           title: Column(
//             children: <Widget>[
//               SizedBox(height: 4),
//               Text(Dictionary.account),
//             ],
//           ))
//     ];
//   }

//   Future<void> onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//       _actionNotification(payload);
//     }
//   }

//   _actionNotification(String payload) {
//     final data = json.decode(payload);
//     if (data['target'] == 'notifikasi') {
//       switch (jsonDecode(data['meta'])['target'].toString()) {
//         case 'polling':
//           _openDetailPolling(jsonDecode(data['meta'])['id']);
//           break;
//         case 'survey':
//           _openDetailSurvey(url: jsonDecode(data['meta'])['url']);
//           break;
//         case 'news':
//           _openDetailNews(jsonDecode(data['meta'])['id']);
//           break;
//         case 'saber-hoax':
//           _openDetailSaberHoax(jsonDecode(data['meta'])['id']);
//           break;
//         case 'aspirasi':
//           _openDetailUsulan(jsonDecode(data['meta'])['id']);
//           break;
//         case 'news-important':
//           _openDetailImportantInfo(jsonDecode(data['meta'])['id']);
//           break;
//         case 'user-post':
//           _openDetailRwActivities(
//               jsonDecode(data['meta'])['id'], data['title']);
//           break;
//         case 'url':
//           _launchURL(jsonDecode(data['meta'])['url']);
//           break;
//       }
//     }

//     if (data['target'] == 'broadcast') {
//       print('id = ' + data['id']);
//       _openDetailBroadcast(jsonDecode(data['id']));
//     }

//     if (data['target'] == 'url') {
//       _launchURL(jsonDecode(data['meta'])['url']);
//     }
//   }

//   void onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider<PopupInformationBloc>(
//               create: (context) => _popupInformationBloc = PopupInformationBloc(
//                   repository: PopupInformationRepository())),
//           BlocProvider<ShowcaseHomeBloc>(
//               create: (context) => _showcaseHomeBloc = ShowcaseHomeBloc()),
//         ],
//         child: MultiBlocListener(
//           listeners: [
//             BlocListener<UpdateAppBloc, UpdateAppState>(
//               listener: (context, state) {
//                 if (state is UpdateAppRequired) {
//                   showDialog(
//                       context: context,
//                       builder: (context) => WillPopScope(
//                           onWillPop: () {
//                             return;
//                           },
//                           child: DialogUpdateApp()),
//                       barrierDismissible: false);
//                   _updateAppBloc.close();
//                 } else if (state is UpdateAppUpdated) {
//                   _changePasswordBloc.add(CheckForceChangeProfile());
//                 } else if (state is UpdateAppFailure) {
//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           content: Text(state.error),
//                           actions: <Widget>[
//                             FlatButton(
//                               child: Text(Dictionary.ok.toUpperCase()),
//                               onPressed: () {
//                                 _updateAppBloc.add(CheckUpdate());
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                             FlatButton(
//                               child: Text(Dictionary.close.toUpperCase()),
//                               onPressed: () {
//                                 exit(0);
//                               },
//                             )
//                           ],
//                         );
//                       });
//                 }
//               },
//             ),
//             BlocListener<ForceChangeProfileBloc, ForceChangeProfileState>(
//               listener: (context, state) {
//                 if (state is ForceChangeProfileNotRequired) {
//                   _popupInformationBloc.add(CheckPopupInformation());
//                 }
//               },
//             ),
//             BlocListener<MessageBadgeBloc, MessageBadgeState>(
//               listener: (context, state) {
//                 if (state is MessageBadgeShow) {
//                   setState(() {
//                     items = badger.setBadge(items, "${state.count}", 1);
//                   });
//                 }
//               },
//             ),
//             BlocListener<PopupInformationBloc, PopupInformationState>(
//               listener: (context, state) {
//                 if (state is PopupInformationShow) {
//                   AnalyticsHelper.setLogEvent(
//                       Analytics.EVENT_VIEW_INFORMATION_POPUP);

//                   showDialog(
//                       context: context,
//                       barrierDismissible: false,
//                       builder: (BuildContext context) => DialogInformation(
//                             imageOnly: true,
//                             imageUrl: state.record.imagePathUrl,
//                             description: state.record.description,
//                             buttonText: Dictionary.next2,
//                             onOkPressed: () {
//                               Navigator.of(context).pop();
//                               _actionPopupInformation(state.record);

//                               AnalyticsHelper.setLogEvent(
//                                   Analytics.EVENT_VIEW_DETAIL_INFORMATION_POPUP,
//                                   <String, dynamic>{
//                                     'id': state.record.id,
//                                     'description': state.record.description
//                                   });
//                             },
//                             onClosePressed: () {
//                               Navigator.of(context).pop();
//                               _showcaseHomeBloc.add(LoadShowcaseHome());
//                             },
//                           ));
//                 }
//               },
//             )
//           ],
//           child: BlocBuilder<ForceChangeProfileBloc, ForceChangeProfileState>(
//             bloc: _changePasswordBloc,
//             builder: (context, state) {
//               if (state is ForceChangePasswordRequired) {
//                 return ChangePasswordScreen(type: ChangePasswordType.force);
//               } else if (state is ForceChangeProfileRequired) {
//                 return CompleteProfileScreen();
//               } else if (state is ForceChangeProfileNotRequired) {
//                 return _buildMainScaffold(context);
//               } else {
//                 return LoadingScreen();
//               }
//             },
//           ),
//         ),
//         );
//   }

//   _buildMainScaffold(BuildContext context) {
//     return FlavorBanner(
//       child: Scaffold(
//         body: BlocProvider<NotificationBadgeBloc>(
//           create: (context) => _notificationBadgeBloc = NotificationBadgeBloc(
//               notificationRepository: NotificationRepository()),
//           child: WillPopScope(
//             onWillPop: () {
//               return showDialog(
//                   context: context,
//                   barrierDismissible: false,
//                   builder: (BuildContext context) {
//                     return AlertDialog(
//                       title: Text(Dictionary.confirmExitTitle),
//                       content: Text(Dictionary.confirmExit),
//                       actions: <Widget>[
//                         FlatButton(
//                           child: Text(Dictionary.yes.toUpperCase()),
//                           onPressed: () {
//                             exit(0);
//                           },
//                         ),
//                         FlatButton(
//                           child: Text(Dictionary.cancel.toUpperCase()),
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                         )
//                       ],
//                     );
//                   });
//             },
//             child: _buildContent(_currentIndex),
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//             onTap: onTabTapped,
//             currentIndex: _currentIndex,
//             type: BottomNavigationBarType.fixed,
//             items: items),
//       ),
//     );
//   }

//   Widget _buildContent(int index) {
//     switch (index) {
//       case 0:
//         return HomeScreen(_popupInformationBloc, _showcaseHomeBloc);
//       case 1:
//         return BroadcastListScreen();

//       case 2:
//         return HelpScreen();

//       case 3:
//         return ProfileScreen();

//       default:
//         return HomeScreen(_popupInformationBloc, _showcaseHomeBloc);
//     }
//   }

//   _checkUnread() async {
//     try {
//       await BroadcastRepository().fetchRecords(1);
//       await _messageBadgeBloc.add(CheckMessageBadge(fromNotification: true));
//     } catch (_) {}
//   }

//   _checkNotification() async {
//     try {
//       await NotificationRepository().fetchRecords(1);
//       await _notificationBadgeBloc.add(CheckNotificationBadge());
//     } catch (_) {}
//   }

//   _actionPopupInformation(PopupInformationModel record) {
//     if (record.type == 'internal') {
//       switch (record.internalObjectType) {
//         case 'news':
//           _openDetailNews(record.internalObjectId);
//           break;

//         case 'polling':
//           _openDetailPolling(record.internalObjectId);
//           break;

//         case 'survey':
//           _openDetailSurvey(id: record.internalObjectId);
//           break;

//         case 'saber-hoax':
//           _openDetailSaberHoax(record.internalObjectId);
//           break;
//         case 'gamification':
//           _openGamification();
//           break;
//       }
//     } else {
//       _openInAppBrowser(record.linkUrl);
//     }
//   }

//   //TODO: method2 dibawah ini bisa direusable

//   _openDetailPolling(int id) async {
//     PollingRepository _pollingRepository = PollingRepository();

//     try {
//       if (id != null) {
//         bool isVoted = await _pollingRepository.getVoteStatus(pollingId: id);

//         if (!isVoted) {
//           PollingModel record = await _pollingRepository.getDetail(id);
//           final result = await Navigator.pushNamed(
//               context, NavigationConstrants.PollingDetail,
//               arguments: record);
//           _closePopupInfo(result);
//         } else {
//           unawaited(Fluttertoast.showToast(
//               msg: Dictionary.pollingHasVotedMessage,
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.TOP,
//               backgroundColor: Colors.blue,
//               textColor: Colors.white));
//           _closePopupInfo(null);
//         }
//       } else {
//         final result =
//             await Navigator.pushNamed(context, NavigationConstrants.Polling);
//         _closePopupInfo(result);
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//       _closePopupInfo(null);
//     }
//   }

//   _openDetailSurvey({String url, int id}) async {
//     try {
//       if (url != null) {
//         final result = await Navigator.pushNamed(
//             context, NavigationConstrants.Browser,
//             arguments: url);
//         _closePopupInfo(result);
//       } else {
//         if (id != null) {
//           String externalUrl = await SurveyRepository().getUrl(id);
//           final result = await Navigator.pushNamed(
//               context, NavigationConstrants.Browser,
//               arguments: externalUrl);
//           _closePopupInfo(result);
//         } else {
//           final result =
//               await Navigator.pushNamed(context, NavigationConstrants.Survey);
//           _closePopupInfo(result);
//         }
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//       _closePopupInfo(null);
//     }
//   }

//   _openDetailNews(int id) async {
//     if (id != null) {
//       NewsDetailArgumentsModel argumentsModel =
//           NewsDetailArgumentsModel(id: id, isIdKota: false);
//       final result = await Navigator.pushNamed(
//           context, NavigationConstrants.NewsDetail,
//           arguments: argumentsModel);
//       _closePopupInfo(result);
//     } else {
//       final result = await Navigator.pushNamed(
//           context, NavigationConstrants.NewsIndex,
//           arguments: false);
//       _closePopupInfo(result);
//     }
//   }

//   _openDetailSaberHoax(int id) async {
//     try {
//       if (id != null) {
//         CounterHoaxModel record = await CounterHoaxRepository().getDetail(id);
//         final result = await Navigator.pushNamed(
//             context, NavigationConstrants.SaberHoaxDetail,
//             arguments: record);
//         _closePopupInfo(result);
//       } else {
//         final result =
//             await Navigator.pushNamed(context, NavigationConstrants.SaberHoax);
//         _closePopupInfo(result);
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//       _closePopupInfo(null);
//     }
//   }

//   _openDetailUsulan(int id) async {
//     try {
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => DetailUsulanScreen(
//                     idUsulan: id,
//                     isUsulanSaya: false,
//                   )));
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//     }
//   }

//   _openGamification() {
//     Navigator.pushNamed(context, NavigationConstrants.Mission);
//   }

//   _openDetailBroadcast(int id) {
//     Navigator.pushNamed(context, NavigationConstrants.BroadcastDetail,
//         arguments: id);
//   }

//   _openDetailImportantInfo(int id) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => ImportantInfoDetailScreen(id: id)));
//   }

//   _openDetailRwActivities(int id, String title) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => RWActivityDetailScreen(null, id, title)));
//   }

//   _openInAppBrowser(String externalUrl) async {
//     if (externalUrl != null) {
//       if (externalUrl.contains('market') ||
//           externalUrl.contains('play.google')) {
//         if (await canLaunch(externalUrl)) {
//           await launch(externalUrl);
//         } else {
//           throw 'Could not launch $externalUrl';
//         }
//       } else {
//         final result = await Navigator.pushNamed(
//             context, NavigationConstrants.Browser,
//             arguments: externalUrl);
//         _closePopupInfo(result);
//       }
//     }
//   }

//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   _sendFirebaseUserProperties() async {
//     UserInfoModel userInfo = await AuthProfileRepository().getUserInfo();
//     await AnalyticsHelper.setUserProperty(userInfo);
//   }

//   _closePopupInfo(dynamic result) {
//     if (result != null) {
//       _showcaseHomeBloc.add(LoadShowcaseHome());
//     } else {
//       _showcaseHomeBloc.add(LoadShowcaseHome());
//     }
//   }

//   @override
//   void dispose() {
//     _updateAppBloc.close();
//     _changePasswordBloc.close();
//     super.dispose();
//   }
// }
