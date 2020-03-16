// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pedantic/pedantic.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sapawarga/blocs/authentication/Bloc.dart';
// import 'package:sapawarga/blocs/notification/Bloc.dart';
// import 'package:sapawarga/components/EmptyData.dart';
// import 'package:sapawarga/components/ErrorContent.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Navigation.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/exceptions/CustomException.dart';
// import 'package:sapawarga/models/CounterHoaxModel.dart';
// import 'package:sapawarga/models/NewsDetailArgumentsModel.dart';
// import 'package:sapawarga/models/NotificationModel.dart';
// import 'package:sapawarga/models/PollingModel.dart';
// import 'package:sapawarga/repositories/CounterHoaxRepository.dart';
// import 'package:sapawarga/repositories/NotificationRepository.dart';
// import 'package:sapawarga/repositories/PollingRepository.dart';
// import 'package:sapawarga/repositories/SurveyRepository.dart';
// import 'package:sapawarga/screens/importantInformation/ImportantInfoDetailScreen.dart';
// import 'package:sapawarga/screens/rwActivities/RWActivityDetailScreen.dart';
// import 'package:sapawarga/screens/usulan/DetailUsulanScreen.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class NotificationListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<NotificationListBloc>(
//       create: (context) => NotificationListBloc(
//           notificationRepository: NotificationRepository()),
//       child: NotificationList(),
//     );
//   }
// }

// class NotificationList extends StatefulWidget {
//   @override
//   _NotificationListState createState() => _NotificationListState();
// }

// class _NotificationListState extends State<NotificationList> {
//   final RefreshController _mainRefreshController = RefreshController();

//   NotificationListBloc _notificationListBloc;
//   AuthenticationBloc _authenticationBloc;

//   @override
//   void initState() {
//     AnalyticsHelper.setCurrentScreen(Analytics.NOTIFICATIONS);
//     AnalyticsHelper.setLogEvent(Analytics.EVENT_VIEW_LIST_NOTIFICATION);

//     _notificationListBloc = BlocProvider.of<NotificationListBloc>(context);
//     _notificationListBloc.add(NotificationListLoad());
//     _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(Dictionary.notification),
//         ),
//         body: BlocListener<NotificationListBloc, NotificationListState>(
//           bloc: _notificationListBloc,
//           listener: (context, state) {
//             if (state is NotificationListFailure) {
//               if (state.error.contains(Dictionary.errorUnauthorized)) {
//                 _authenticationBloc.add(LoggedOut());
//                 Navigator.of(context).pop();
//               }
//             }
//           },
//           child: SmartRefresher(
//             controller: _mainRefreshController,
//             enablePullDown: true,
//             header: WaterDropMaterialHeader(),
//             onRefresh: () async {
//               _notificationListBloc.add(NotificationListLoad());
//               _mainRefreshController.refreshCompleted();
//             },
//             child: BlocBuilder<NotificationListBloc, NotificationListState>(
//               bloc: _notificationListBloc,
//               builder: (context, state) {
//                 return state is NotificationListLoading
//                     ? buildLoading()
//                     : state is NotificationListLoaded
//                         ? state.records.isNotEmpty
//                             ? buildContent(state)
//                             : EmptyData(
//                                 message: Dictionary.emptyDataNotifications)
//                         : state is NotificationListFailure
//                             ? ErrorContent(error: state.error)
//                             : buildLoading();
//               },
//             ),
//           ),
//         ));
//   }

//   ListView buildLoading() {
//     return ListView.separated(
//       separatorBuilder: (context, index) => Divider(
//         color: Colors.black,
//       ),
//       itemCount: 6,
//       itemBuilder: (context, index) => Skeleton(
//         child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Container(
//               child: Row(
//                 children: <Widget>[
//                   Container(
//                     width: 24.0,
//                     height: 24.0,
//                     color: Colors.grey[300],
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 80,
//                     margin: EdgeInsets.only(left: 10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                             width: MediaQuery.of(context).size.width - 90,
//                             height: 20.0,
//                             color: Colors.grey[300]),
//                         SizedBox(height: 8.0),
//                         Container(
//                             width: MediaQuery.of(context).size.width - 250,
//                             height: 20.0,
//                             color: Colors.grey[300]),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )),
//       ),
//     );
//   }

//   ListView buildContent(NotificationListLoaded state) {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => Divider(
//         color: Colors.grey[500],
//       ),
//       itemCount: state.records.length,
//       itemBuilder: (context, index) => GestureDetector(
//         child: Container(
//           color: state.records[index].readAt == null ? Color(0xFFF8FFF8) : null,
//           padding: EdgeInsets.all(10.0),
//           child: Container(
//             child: Row(
//               children: <Widget>[
//                 buildImage(state.records[index].meta.target),
//                 Container(
//                   width: MediaQuery.of(context).size.width - 80,
//                   margin: EdgeInsets.only(left: 10.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(state.records[index].title,
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 16.0,
//                               fontWeight: state.records[index].readAt == null
//                                   ? FontWeight.bold
//                                   : null)),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         onTap: () {
//           _actionNotification(state.records[index]);

//           AnalyticsHelper.setLogEvent(
//               Analytics.EVENT_VIEW_DETAIL_NOTIFICATION, <String, dynamic>{
//             'id': state.records[index].id,
//             'title': state.records[index].title
//           });
//         },
//       ),
//     );
//   }

//   Image buildImage(String target) {
//     String pathIcon;

//     switch (target) {
//       case 'polling':
//         pathIcon = '${Environment.iconAssets}polling.png';
//         break;
//       case 'survey':
//         pathIcon = '${Environment.iconAssets}survey.png';
//         break;
//       case 'news':
//         pathIcon = '${Environment.iconAssets}broadcast.png';
//         break;
//       case 'saber-hoax':
//         pathIcon = '${Environment.iconAssets}saber_hoax.png';
//         break;
//       case 'url':
//         pathIcon = '${Environment.iconAssets}lapor.png';
//         break;
//       default:
//         pathIcon = '${Environment.iconAssets}lapor.png';
//         break;
//     }

//     return Image.asset(pathIcon, width: 24.0, height: 24.0);
//   }

//   _actionNotification(NotificationModel record) {
//     _notificationListBloc.add(NotificationListTap(id: record.id));

//     switch (record.meta.target) {
//       case 'polling':
//         _openDetailPolling(record.meta.id);
//         break;
//       case 'survey':
//         _openDetailSurvey(url: record.meta.url, id: record.meta.id);
//         break;
//       case 'news':
//         _openDetailNews(record.meta.id);
//         break;
//       case 'saber-hoax':
//         _openDetailSaberHoax(record.meta.id);
//         break;
//       case 'aspirasi':
//         _openDetailUsulan(record.meta.id);
//         break;
//       case 'news-important':
//         _openDetailImportantInfo(record.meta.id);
//         break;
//       case 'user-post':
//         _openDetailRwActivities(record.meta.id, record.title);
//         break;
//       case 'url':
//         _launchURL(record.meta.url);
//         break;
//     }
//   }

//   _openDetailPolling(int id) async {
//     PollingRepository _pollingRepository = PollingRepository();

//     try {
//       if (id != null) {
//         bool isVoted = await _pollingRepository.getVoteStatus(pollingId: id);

//         if (!isVoted) {
//           PollingModel record = await _pollingRepository.getDetail(id);
//           await Navigator.pushNamed(context, NavigationConstrants.PollingDetail,
//               arguments: record);
//         } else {
//           unawaited(Fluttertoast.showToast(
//               msg: Dictionary.pollingHasVotedMessage,
//               toastLength: Toast.LENGTH_LONG,
//               gravity: ToastGravity.TOP,
//               backgroundColor: Colors.blue,
//               textColor: Colors.white));
//         }
//       } else {
//         await Navigator.pushNamed(context, NavigationConstrants.Polling);
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//     }
//   }

//   _openDetailSurvey({String url, int id}) async {
//     try {
//       if (url != null) {
//         await Navigator.pushNamed(context, NavigationConstrants.Browser,
//             arguments: url);
//       } else {
//         if (id != null) {
//           String externalUrl = await SurveyRepository().getUrl(id);
//           await Navigator.pushNamed(context, NavigationConstrants.Browser,
//               arguments: externalUrl);
//         } else {
//           await Navigator.pushNamed(context, NavigationConstrants.Survey);
//         }
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//     }
//   }

//   _openDetailNews(int id) {
//     if (id != null) {
//       NewsDetailArgumentsModel argumentsModel =
//           NewsDetailArgumentsModel(id: id, isIdKota: false);
//       Navigator.pushNamed(context, NavigationConstrants.NewsDetail,
//           arguments: argumentsModel);
//     } else {
//       Navigator.pushNamed(context, NavigationConstrants.NewsIndex,
//           arguments: false);
//     }
//   }

//   _openDetailSaberHoax(int id) async {
//     try {
//       if (id != null) {
//         CounterHoaxModel record = await CounterHoaxRepository().getDetail(id);
//         await Navigator.pushNamed(context, NavigationConstrants.SaberHoaxDetail,
//             arguments: record);
//       } else {
//         await Navigator.pushNamed(context, NavigationConstrants.SaberHoax);
//       }
//     } catch (e) {
//       unawaited(Fluttertoast.showToast(
//           msg: CustomException.onConnectionException(e.toString()),
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.TOP,
//           backgroundColor: Colors.red,
//           textColor: Colors.white));
//     }
//   }

//   _openDetailUsulan(int id) async {
//     try {
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => DetailUsulanScreen(
//                     idUsulan: id,
//                     isUsulanSaya: true,
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

//   _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   @override
//   void deactivate() {
//     _notificationListBloc.add(NotificationListReloadLocal());
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _notificationListBloc.close();
//     _mainRefreshController.dispose();
//     super.dispose();
//   }
// }
