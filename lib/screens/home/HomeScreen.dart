// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sapawarga/blocs/banner/Bloc.dart';
// import 'package:sapawarga/blocs/humasjabar_list/Bloc.dart';
// import 'package:sapawarga/blocs/important_info/improtant_info_home/Bloc.dart';
// import 'package:sapawarga/blocs/notification/Bloc.dart';
// import 'package:sapawarga/blocs/popup_information/Bloc.dart';
// import 'package:sapawarga/blocs/showcase_home/Bloc.dart';
// import 'package:sapawarga/blocs/video_list/Bloc.dart';
// import 'package:sapawarga/components/BaseShowCase.dart';
// import 'package:sapawarga/components/BrowserScreen.dart';
// import 'package:sapawarga/components/BubbleCustom.dart';
// import 'package:sapawarga/components/TextButton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Colors.dart' as color;
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Dimens.dart';
// import 'package:sapawarga/constants/FontsFamily.dart';
// import 'package:sapawarga/constants/Navigation.dart';
// import 'package:sapawarga/constants/UrlThirdParty.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/models/UserInfoModel.dart';
// import 'package:sapawarga/repositories/AuthProfileRepository.dart';
// import 'package:sapawarga/repositories/BannerRepository.dart';
// import 'package:sapawarga/repositories/HumasJabarRepository.dart';
// import 'package:sapawarga/repositories/ImportantInfoRepository.dart';
// import 'package:sapawarga/repositories/VideoRepository.dart';
// import 'package:sapawarga/screens/importantInformation/ImportantInfoListHome.dart';
// import 'package:sapawarga/screens/main/account/subeditprofile/SubEditProfileScreen.dart';
// import 'package:sapawarga/screens/main/home/BannerListSlider.dart';
// import 'package:sapawarga/screens/main/home/HumasJabarList.dart';
// import 'package:sapawarga/screens/main/home/VideoListJabar.dart';
// import 'package:sapawarga/screens/main/home/VideoListKokab.dart';
// import 'package:sapawarga/screens/news/NewsListScreen.dart';
// import 'package:sapawarga/screens/rwActivities/RWActivityScreen.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:sapawarga/utilities/RateAppHelper.dart';
// import 'package:sapawarga/utilities/SharedPreferences.dart';
// import 'package:showcaseview/showcaseview.dart';

// class HomeScreen extends StatefulWidget {
//   final ShowcaseHomeBloc showcaseHomeBloc;
//   final PopupInformationBloc popupInformationBloc;

//   HomeScreen(this.popupInformationBloc, this.showcaseHomeBloc);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   NotificationBadgeBloc _notificationBadgeBloc;

//   ShowcaseHomeBloc get _showcaseHomeBloc => widget.showcaseHomeBloc;
//   PopupInformationBloc get _popupBloc => widget.popupInformationBloc;

//   final GlobalKey _showcaseOne = GlobalKey();
//   final GlobalKey _showcaseTwo = GlobalKey();
//   final GlobalKey _showcaseThree = GlobalKey();
//   BuildContext showcaseContext;
//   bool showingShowcase = false;
//   BannerListBloc _bannerListBloc;
//   ImportantInfoHomeBloc _importantInfoHomeBloc;
//   HumasJabarListBloc _humasJabarListBloc;
//   VideoListJabarBloc _videoListJabarBloc;
//   VideoListKokabBloc _videoListKokabBloc;
//   final RefreshController _mainRefreshController = RefreshController();

//   @override
//   void initState() {
//     AnalyticsHelper.setCurrentScreen(Analytics.HOME,
//         screenClassOverride: 'BerandaScreen');
//     _notificationBadgeBloc = BlocProvider.of<NotificationBadgeBloc>(context);
//     _notificationBadgeBloc.add(CheckNotificationBadge());

//     super.initState();
//   }

//   _buildButtonColumn(String iconPath, String label, String route) {
//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(2.0),
//             decoration: BoxDecoration(boxShadow: [
//               BoxShadow(
//                 blurRadius: 6.0,
//                 color: Colors.black.withOpacity(.2),
//                 offset: Offset(2.0, 4.0),
//               ),
//             ], borderRadius: BorderRadius.circular(12.0), color: Colors.white),
//             child: IconButton(
//               color: Theme.of(context).textTheme.body1.color,
//               icon: Image.asset(iconPath),
//               onPressed: () {
//                 if (route != null) {
//                   Navigator.pushNamed(context, route);

//                   if (route == NavigationConstrants.infoPKB) {
//                     AnalyticsHelper.setCurrentScreen(Analytics.INFO_PKB,
//                         screenClassOverride: 'InfoPKB');
//                     AnalyticsHelper.setLogEvent(Analytics.EVENT_VIEW_INFO_PKB);
//                   }

//                   if (route == NavigationConstrants.Pikobar) {
//                     AnalyticsHelper.setCurrentScreen(Analytics.PIKOBAR,
//                         screenClassOverride: 'InfoCorona');
//                     AnalyticsHelper.setLogEvent(Analytics.EVENT_VIEW_INFO_CORONA);
//                   }
//                 }
//               },
//             ),
//           ),
//           SizedBox(height: 5.0),
//           Text(label,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Theme.of(context).textTheme.body1.color,
//               ))
//         ],
//       ),
//     );
//   }

//   _buildButtonColumnLayananLain(String iconPath, String label) {
//     return Expanded(
//         child: Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(2.0),
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//               blurRadius: 10.0,
//               color: Colors.black.withOpacity(.2),
//               offset: Offset(2.0, 2.0),
//             ),
//           ], borderRadius: BorderRadius.circular(12.0), color: Colors.white),
//           child: IconButton(
//             color: Theme.of(context).textTheme.body1.color,
//             icon: Image.asset(iconPath),
//             onPressed: () {
//               _mainHomeLayananBottomSheet(context);
//             },
//           ),
//         ),
//         SizedBox(height: 5.0),
//         Text(label,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 12,
//               color: Theme.of(context).textTheme.body1.color,
//             ))
//       ],
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget firstRowShortcuts = Container(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _showcaseRWActivity(),
//           _buildButtonColumn('${Environment.iconAssets}survey.png',
//               Dictionary.survey, NavigationConstrants.Survey),
//           _buildButtonColumn('${Environment.iconAssets}polling.png',
//               Dictionary.polling, NavigationConstrants.Polling),
//           _showcaseImportantInfo()
//         ],
//       ),
//     );

//     Widget secondRowShortcuts = Container(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _showcaseCorona(),
//           _buildButtonColumn('${Environment.iconAssets}aspirasi.png',
//               Dictionary.aspiration, NavigationConstrants.Aspirasi),
//           _buildButtonColumn('${Environment.iconAssets}nomorpenting.png',
//               Dictionary.phoneBook, NavigationConstrants.Phonebook),
//           _buildButtonColumnLayananLain(
//               '${Environment.iconAssets}other.png', Dictionary.otherMenus),
//         ],
//       ),
//     );

//     Widget topContainer = Container(
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//       decoration: BoxDecoration(color: Colors.white, boxShadow: [
//         BoxShadow(
//           color: Colors.white.withOpacity(0.05),
// //            blurRadius: 5,
//           offset: Offset(0.0, 0.05),
//         ),
//       ]),
//       child: Column(
//         children: <Widget>[
//           firstRowShortcuts,
//           SizedBox(
//             height: 8.0,
//           ),
//           secondRowShortcuts
//         ],
//       ),
//     );

//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<BannerListBloc>(
//           create: (BuildContext context) => _bannerListBloc =
//               BannerListBloc(bannerRepository: BannerRepository())
//                 ..add(BannerListLoad()),
//         ),
//         BlocProvider<ImportantInfoHomeBloc>(
//           create: (BuildContext context) =>
//               _importantInfoHomeBloc = ImportantInfoHomeBloc(
//                   importantInfoRepository: ImportantInfoRepository())
//                 ..add(ImportantInfoHomeLoad()),
//         ),
//         BlocProvider<HumasJabarListBloc>(
//             create: (BuildContext context) => _humasJabarListBloc =
//                 HumasJabarListBloc(humasJabarRepository: HumasJabarRepository())
//                   ..add(HumasJabarLoad())),
//         BlocProvider<VideoListKokabBloc>(
//           create: (BuildContext context) =>
//               _videoListKokabBloc = VideoListKokabBloc(
//                   videoRepository: VideoRepository(),
//                   authProfileRepository: AuthProfileRepository())
//                 ..add(VideoListKokabLoad()),
//         ),
//         BlocProvider<VideoListJabarBloc>(
//           create: (BuildContext context) => _videoListJabarBloc =
//               VideoListJabarBloc(videoRepository: VideoRepository())
//                 ..add(VideoListJabarLoad()),
//         ),
//       ],
//       child: MultiBlocListener(
//         listeners: [
//           BlocListener(
//               bloc: _popupBloc,
//               listener: (context, state) {
//                 if (state is PopupInformationHasShown) {
//                   _showProfile();
//                 }
//               }),
//           BlocListener(
//               bloc: _showcaseHomeBloc,
//               listener: (context, state) {
//                 if (state is ShowcaseHomeLoaded) {
//                   if (!showingShowcase) {
//                     _initializeShowcase();
//                     showingShowcase = true;
//                   }
//                 }
//               })
//         ],
//         child: ShowCaseWidget(
//           onFinish: () async {
//             await Preferences.setShowcaseHome(true);
//             Future.delayed(Duration(milliseconds: 500), () => _showProfile());
//           },
//           builder: Builder(
//             builder: (context) {
//               showcaseContext = context;
//               return Scaffold(
//                 backgroundColor: Colors.white,
//                 appBar: AppBar(
//                   elevation: 0.0,
//                   backgroundColor: color.Colors.blue,
//                   title: Row(
//                     children: <Widget>[
//                       Container(
//                           padding: const EdgeInsets.all(5.0),
//                           child: Text(
//                             Dictionary.appName,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: FontsFamily.intro,
//                             ),
//                           ))
//                     ],
//                   ),
//                   actions: <Widget>[
//                     BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
//                         bloc: _notificationBadgeBloc,
//                         builder: (context, state) {
//                           return state is NotificationBadgeShow
//                               ? Container(
//                                   width: MediaQuery.of(context).size.width / 3,
//                                   child: IconButton(
//                                     icon: Stack(children: <Widget>[
//                                       Positioned(
//                                           right: 5.0,
//                                           top: 5.0,
//                                           child: Icon(
//                                               Icons.notifications_active,
//                                               size: 25.0)),
//                                       Positioned(
//                                         right: 0.0,
//                                         top: 0.0,
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(25.0),
//                                               color: Colors.redAccent),
//                                           child: Padding(
//                                             padding: EdgeInsets.fromLTRB(
//                                                 5.0, 3.0, 5.0, 3.0),
//                                             child: Text(
//                                               state.count.toString(),
//                                               style: TextStyle(fontSize: 10.0),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ]),
//                                     onPressed: () {
//                                       Navigator.pushNamed(
//                                           context,
//                                           NavigationConstrants
//                                               .NotificationList);
//                                     },
//                                   ))
//                               : IconButton(
//                                   icon: Icon(Icons.notifications_active,
//                                       size: 25.0, color: Colors.white),
//                                   onPressed: () {
//                                     Navigator.pushNamed(context,
//                                         NavigationConstrants.NotificationList);
//                                   },
//                                 );
//                         }),
//                   ],
//                 ),
//                 body: Stack(
//                   children: <Widget>[
//                     Container(
//                       height: MediaQuery.of(context).size.height * 0.16,
//                       color: color.Colors.blue,
//                     ),
//                     Column(
//                       children: <Widget>[
//                         Expanded(
//                           child: SmartRefresher(
//                             controller: _mainRefreshController,
//                             enablePullDown: true,
//                             header: WaterDropMaterialHeader(),
//                             onRefresh: () async {
//                               _bannerListBloc.add(BannerListLoad());
//                               _importantInfoHomeBloc
//                                   .add(ImportantInfoHomeLoad());
//                               _humasJabarListBloc.add(HumasJabarLoad());
//                               _videoListJabarBloc.add(VideoListJabarLoad());
//                               _videoListKokabBloc.add(VideoListKokabLoad());
//                               _mainRefreshController.refreshCompleted();
//                             },
//                             child: ListView(children: [
//                               Container(
//                                   margin:
//                                       EdgeInsets.fromLTRB(0.0, 21.0, 0.0, 10.0),
//                                   child: BannerListSlider()),
//                               topContainer,
//                               SizedBox(
//                                 height: 8.0,
//                                 child: Container(
//                                   color: Color(0xFFE5E5E5),
//                                 ),
//                               ),
//                               Container(
//                                 color: Colors.white,
//                                 child: Column(
//                                   children: <Widget>[
//                                     ImportantInfoListHome(),
//                                     Container(
//                                       padding: EdgeInsets.all(15.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: <Widget>[
//                                           Text(
//                                             Dictionary.titleHumasJabar,
//                                             style: TextStyle(
//                                                 color:
//                                                     Color.fromRGBO(0, 0, 0, 0.73),
//                                                 fontWeight: FontWeight.bold,
//                                                 fontFamily:
//                                                     FontsFamily.productSans,
//                                                 fontSize: 18.0),
//                                           ),
//                                           TextButton(
//                                             title: Dictionary.viewAll,
//                                             textStyle: TextStyle(
//                                                 color: Colors.green,
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 13.0),
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       BrowserScreen(
//                                                     url: UrlThirdParty
//                                                         .newsHumasJabarTerkini,
//                                                   ),
//                                                 ),
//                                               );

//                                               AnalyticsHelper.setLogEvent(
//                                                 Analytics.EVENT_VIEW_LIST_HUMAS,
//                                               );
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     HumasJabarListScreen(),
//                                     Container(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           ListTile(
//                                             leading: Text(
//                                               Dictionary.news,
//                                               style: TextStyle(
//                                                   color: Color.fromRGBO(
//                                                       0, 0, 0, 0.73),
//                                                   fontWeight: FontWeight.bold,
//                                                   fontFamily:
//                                                       FontsFamily.productSans,
//                                                   fontSize: 18.0),
//                                             ),
//                                           ),
//                                           SingleChildScrollView(
//                                             scrollDirection: Axis.horizontal,
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 NewsListScreen(isIdKota: false),
//                                                 NewsListScreen(isIdKota: true)
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.only(top: 16.0),
//                                       child: VideoListJabar(),
//                                     ),
//                                     Container(
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 16.0),
//                                       child: VideoListKokab(),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ]),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   _initializeShowcase() async {
//     bool hasShown = await Preferences.hasShowcaseHome();

//     if (hasShown == null || hasShown == false) {
//       Future.delayed(
//           Duration(milliseconds: 200),
//           () => ShowCaseWidget.of(showcaseContext)
//               .startShowCase([_showcaseOne, _showcaseTwo, _showcaseThree]));
//     } else {
//       Future.delayed(Duration(milliseconds: 500), () => _showProfile());
//     }
//   }

//   //TODO: perlu di refactor kembali
//   void _mainHomeLayananBottomSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10.0),
//             topRight: Radius.circular(10.0),
//           ),
//         ),
//         elevation: 60.0,
//         builder: (BuildContext context) {
//           return Container(
//             margin: EdgeInsets.only(bottom: 20.0),
//             child: Wrap(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(top: 14.0),
//                       color: Colors.black,
//                       height: 1.5,
//                       width: 40.0,
//                     ),
//                   ],
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.only(left: Dimens.padding, top: 10.0),
//                   child: Text(
//                     Dictionary.otherMenus,
//                     style:
//                         TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.topCenter,
//                   padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                   decoration: BoxDecoration(boxShadow: [
//                     BoxShadow(
//                       color: Colors.white.withOpacity(0.05),
//                       offset: Offset(0.0, 0.05),
//                     ),
//                   ]),
//                   child: Column(
//                     children: <Widget>[
//                       Container(
//                         padding: EdgeInsets.symmetric(vertical: 8),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _buildButtonColumn(
//                                 '${Environment.iconAssets}icon_esamsat.png',
//                                 Dictionary.infoPKB,
//                                 NavigationConstrants.infoPKB),
//                             _buildButtonColumn(
//                                 '${Environment.iconAssets}saber_hoax.png',
//                                 Dictionary.saberHoax,
//                                 NavigationConstrants.SaberHoax),
//                             _buildButtonColumn(
//                                 '${Environment.iconAssets}administrasi-1.png',
//                                 Dictionary.administration,
//                                 NavigationConstrants.AdministrationList),
//                           ],
//                         ),
//                       ),

//                       SizedBox(
//                         height: 8.0,
//                       ),
//                       // secondRowShortcuts
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }

//   _showcaseRWActivity() {
//     return Expanded(
//       child: BaseShowCase.showcaseWidget(
//         key: _showcaseOne,
//         context: context,
//         nipLocation: NipLocation.TOP_LEFT,
//         nipPaddingTopLeft: 35.0,
//         widgets: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(bottom: 5),
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   Dictionary.rwActivities,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 Dictionary.showcaseHome1,
//                 style: TextStyle(color: Colors.grey[800]),
//               ),
//             ],
//           )
//         ],
//         onOkTap: () {
//           ShowCaseWidget.of(showcaseContext).completed(_showcaseOne);
//         },
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(2.0),
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 6.0,
//                       color: Colors.black.withOpacity(.2),
//                       offset: Offset(2.0, 4.0),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(12.0),
//                   color: Colors.white),
//               child: IconButton(
//                 color: Theme.of(context).textTheme.body1.color,
//                 icon: Image.asset(
//                     '${Environment.iconAssets}icon_kegiatan_rw.png'),
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     // Create the SelectionScreen in the next step.
//                     MaterialPageRoute(builder: (context) => RWActivityScreen()),
//                   );
//                   if (result == null || result != null) {
//                     RateAppHelper.showRateApp(context);
//                   }
//                 },
//               ),
//             ),
//             SizedBox(height: 5.0),
//             Text(Dictionary.rwActivities,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Theme.of(context).textTheme.body1.color,
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   _showcaseImportantInfo() {
//     return Expanded(
//       child: BaseShowCase.showcaseWidget(
//         key: _showcaseTwo,
//         context: context,
//         nipLocation: NipLocation.TOP_RIGHT,
//         nipPaddingTopRight: 35.0,
//         margin: EdgeInsets.only(top: 10.0, left: 25.0),
//         widgets: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(bottom: 5),
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   Dictionary.importantInfo,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 Dictionary.showcaseHome2,
//                 style: TextStyle(color: Colors.grey[800]),
//               ),
//             ],
//           )
//         ],
//         onOkTap: () {
//           ShowCaseWidget.of(showcaseContext).completed(_showcaseTwo);
//         },
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(2.0),
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 6.0,
//                       color: Colors.black.withOpacity(.2),
//                       offset: Offset(2.0, 4.0),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(12.0),
//                   color: Colors.white),
//               child: IconButton(
//                 color: Theme.of(context).textTheme.body1.color,
//                 icon:
//                     Image.asset('${Environment.iconAssets}important_info.png'),
//                 onPressed: () {
//                   Navigator.pushNamed(
//                       context, NavigationConstrants.importanInformation);
//                 },
//               ),
//             ),
//             SizedBox(height: 5.0),
//             Text(Dictionary.importantInfo,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Theme.of(context).textTheme.body1.color,
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   _showcaseCorona() {
//     return Expanded(
//       child: BaseShowCase.showcaseWidget(
//         key: _showcaseThree,
//         context: context,
//         nipLocation: NipLocation.TOP_LEFT,
//         nipPaddingTopRight: 35.0,
//         widgets: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.only(bottom: 5),
//                 alignment: Alignment.topLeft,
//                 child: Text(
//                   Dictionary.pikobar,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18.0,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Text(
//                 Dictionary.showcaseHome3,
//                 style: TextStyle(color: Colors.grey[800]),
//               ),
//             ],
//           )
//         ],
//         onOkTap: () {
//           ShowCaseWidget.of(showcaseContext).completed(_showcaseThree);
//         },
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(2.0),
//               decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 6.0,
//                       color: Colors.black.withOpacity(.2),
//                       offset: Offset(2.0, 4.0),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(12.0),
//                   color: Colors.white),
//               child: IconButton(
//                 color: Theme.of(context).textTheme.body1.color,
//                 icon:
//                 Image.asset('${Environment.iconAssets}pikobar.png'),
//                 onPressed: () {
//                   Navigator.pushNamed(
//                       context, NavigationConstrants.Pikobar);
//                 },
//               ),
//             ),
//             SizedBox(height: 5.0),
//             Text(Dictionary.pikobar,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Theme.of(context).textTheme.body1.color,
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   _showProfile() async {
//     UserInfoModel userInfo = await AuthProfileRepository().getUserInfo();
//     int oldTime = await Preferences.getTimeEducationLater();

//       if (userInfo.educationLevelId == null || userInfo.jobTypeId == null) {

//         if (oldTime == null) {
//           await Preferences.setTimeEducationLater(DateTime
//               .now()
//               .millisecondsSinceEpoch);

//           await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   SubEditProfileScreen(authUserInfo: userInfo),
//             ),
//           );
//         } else {
//           int hours = DateTime
//               .now()
//               .difference(DateTime.fromMillisecondsSinceEpoch(oldTime))
//               .inHours;

//           if (hours >= 24) {
//             await Preferences.setTimeEducationLater(DateTime
//                 .now()
//                 .millisecondsSinceEpoch);

//             await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     SubEditProfileScreen(authUserInfo: userInfo),
//               ),
//             );
//           }
//         }
//       }
//   }

//   @override
//   void deactivate() {
//     _notificationBadgeBloc.add(CheckNotificationBadge());
//     super.deactivate();
//   }

//   @override
//   void dispose() {
//     _humasJabarListBloc.close();
//     _bannerListBloc.close();
//     _importantInfoHomeBloc.close();
//     _videoListJabarBloc.close();
//     _videoListKokabBloc.close();
//     super.dispose();
//   }
// }
