 import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
 import 'package:pull_to_refresh/pull_to_refresh.dart';


 class HomeScreen extends StatefulWidget {
   HomeScreen();

   @override
   _HomeScreenState createState() => _HomeScreenState();
 }

 class _HomeScreenState extends State<HomeScreen> {
   /*BannerListBloc _bannerListBloc;
   ImportantInfoHomeBloc _importantInfoHomeBloc;
   HumasJabarListBloc _humasJabarListBloc;
   VideoListJabarBloc _videoListJabarBloc;
   VideoListKokabBloc _videoListKokabBloc;
   */
   final RefreshController _mainRefreshController = RefreshController();

   @override
   void initState() {
     /*AnalyticsHelper.setCurrentScreen(Analytics.HOME,
         screenClassOverride: 'BerandaScreen');
     _notificationBadgeBloc = BlocProvider.of<NotificationBadgeBloc>(context);
     _notificationBadgeBloc.add(CheckNotificationBadge());*/

     super.initState();
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
           SizedBox(height: 5.0),
           Text(label,
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 13,
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
         SizedBox(height: 5.0),
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
           _buildButtonColumn('${Environment.iconAssets}survey.png',
               Dictionary.survey, NavigationConstrants.Survey),
           _buildButtonColumn('${Environment.iconAssets}survey.png',
               Dictionary.survey, NavigationConstrants.Survey),
           _buildButtonColumn('${Environment.iconAssets}polling.png',
               Dictionary.polling, NavigationConstrants.Polling),
           _buildButtonColumn('${Environment.iconAssets}survey.png',
               Dictionary.survey, NavigationConstrants.Survey),
         ],
       ),
     );

     Widget secondRowShortcuts = Container(
       padding: EdgeInsets.symmetric(vertical: 8),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildButtonColumn('${Environment.iconAssets}aspirasi.png',
               Dictionary.aspiration, NavigationConstrants.Aspirasi),
           _buildButtonColumn('${Environment.iconAssets}aspirasi.png',
               Dictionary.aspiration, NavigationConstrants.Aspirasi),
           _buildButtonColumn('${Environment.iconAssets}nomorpenting.png',
               Dictionary.phoneBook, NavigationConstrants.Phonebook),
           _buildButtonColumnLayananLain(
               '${Environment.iconAssets}other.png', Dictionary.otherMenus),
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
                 backgroundColor: Colors.white,
                 appBar: AppBar(
                   elevation: 0.0,
                   backgroundColor: Colors.blue,
                   title: Row(
                     children: <Widget>[
                       Container(
                           padding: const EdgeInsets.all(5.0),
                           child: Text(
                             Dictionary.appName,
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 25,
                               fontWeight: FontWeight.bold,
                               fontFamily: FontsFamily.intro,
                             ),
                           ))
                     ],
                   ),
                   ),
                 body: Stack(
                   children: <Widget>[
                     Container(
                       height: MediaQuery.of(context).size.height * 0.16,
                       color: Colors.blue,
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
                                   margin:
                                       EdgeInsets.fromLTRB(0.0, 21.0, 0.0, 10.0),
                                   //child: BannerListSlider()
                                ),
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
                                     /*Container(
                                       padding: EdgeInsets.all(15.0),
                                       child: Row(
                                         mainAxisAlignment:
                                             MainAxisAlignment.spaceBetween,
                                         children: <Widget>[
                                           Text(
                                             Dictionary.titleHumasJabar,
                                             style: TextStyle(
                                                 color:
                                                     Color.fromRGBO(0, 0, 0, 0.73),
                                                 fontWeight: FontWeight.bold,
                                                 fontFamily:
                                                     FontsFamily.productSans,
                                                 fontSize: 18.0),
                                           ),
                                           TextButton(
                                             title: Dictionary.viewAll,
                                             textStyle: TextStyle(
                                                 color: Colors.green,
                                                 fontWeight: FontWeight.w600,
                                                 fontSize: 13.0),
                                             onTap: () {
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(
                                                   builder: (context) =>
                                                       BrowserScreen(
                                                     url: UrlThirdParty
                                                         .newsHumasJabarTerkini,
                                                   ),
                                                 ),
                                               );

                                               AnalyticsHelper.setLogEvent(
                                                 Analytics.EVENT_VIEW_LIST_HUMAS,
                                               );
                                             },
                                           ),
                                         ],
                                       ),
                                     ),
                                     HumasJabarListScreen(),
                                     Container(
                                       child: Column(
                                         crossAxisAlignment:
                                             CrossAxisAlignment.start,
                                         children: <Widget>[
                                           ListTile(
                                             leading: Text(
                                               Dictionary.news,
                                               style: TextStyle(
                                                   color: Color.fromRGBO(
                                                       0, 0, 0, 0.73),
                                                   fontWeight: FontWeight.bold,
                                                   fontFamily:
                                                       FontsFamily.productSans,
                                                   fontSize: 18.0),
                                             ),
                                           ),
                                           SingleChildScrollView(
                                             scrollDirection: Axis.horizontal,
                                             child: Row(
                                               crossAxisAlignment:
                                                   CrossAxisAlignment.start,
                                               children: <Widget>[
                                                 NewsListScreen(isIdKota: false),
                                                 NewsListScreen(isIdKota: true)
                                               ],
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                     Container(
                                       padding: EdgeInsets.only(top: 16.0),
                                       child: VideoListJabar(),
                                     ),
                                     Container(
                                       padding:
                                           EdgeInsets.symmetric(vertical: 16.0),
                                       child: VideoListKokab(),
                                     )*/
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
                                 '${Environment.iconAssets}icon_esamsat.png',
                                 Dictionary.infoPKB,
                                 NavigationConstrants.infoPKB),
                             _buildButtonColumn(
                                 '${Environment.iconAssets}saber_hoax.png',
                                 Dictionary.saberHoax,
                                 NavigationConstrants.SaberHoax),
                             _buildButtonColumn(
                                 '${Environment.iconAssets}administrasi-1.png',
                                 Dictionary.administration,
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
