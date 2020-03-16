// import 'package:device_apps/device_apps.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:sapawarga/components/BrowserScreen.dart';
// import 'package:sapawarga/components/Expandable.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/UrlThirdParty.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/models/HelpModel.dart';
// import 'package:sapawarga/repositories/HelpRepository.dart';
// import 'package:html/dom.dart' as dom;
// import 'package:sapawarga/constants/Colors.dart' as clr;
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HelpScreen extends StatefulWidget {
//   @override
//   _HelpScreenState createState() => _HelpScreenState();
// }

// class _HelpScreenState extends State<HelpScreen> {
//   HelpRepository _helpRepository = HelpRepository();

//   @override
//   void initState() {
//     AnalyticsHelper.setCurrentScreen(Analytics.HELP);
//     AnalyticsHelper.setLogEvent(Analytics.EVENT_VIEW_LIST_HELP);

//     super.initState();
//   }

//   _initialize() async {
//     List<HelpModel> data = await _helpRepository.fetchRecords();
//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bantuan'),
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.info),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BrowserScreen(
//                     url: UrlThirdParty.urlCommunityGuideLine,
//                   ),
//                   ),
//                 );

//                 AnalyticsHelper.setLogEvent(
//                     Analytics.EVENT_OPEN_GUIDELINES_HELP);
//               })
//         ],
//       ),
//       body: FutureBuilder(
//         future: _initialize(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               padding: EdgeInsets.only(bottom: 80.0),
//               itemCount: snapshot.data.length,
//               itemBuilder: (context, index) =>
//                   _cardContent(snapshot.data[index]),
//             );
//           } else {
//             return Center(
//               child: _buildLoading(),
//             );
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: clr.Colors.blue,
//         onPressed: _launchWhatsApp,
//         label: Text(Dictionary.contactAdmin),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   _launchWhatsApp() async {
//     try {
//       bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
//       if (isInstalled) {
//         String urlWhatsApp = 'https://wa.me/${Environment.csPhone}';
//         if (await canLaunch(urlWhatsApp)) {
//           await launch(urlWhatsApp);

//           await AnalyticsHelper.setLogEvent(Analytics.EVENT_OPEN_WA_ADMIN_HELP);
//         } else {
//           await launch('tel://${Environment.csPhone}');
//         }
//       } else {
//         await launch('tel://${Environment.csPhone}');

//         await AnalyticsHelper.setLogEvent(Analytics.EVENT_OPEN_TELP_ADMIN_HELP);
//       }
//     } catch (_) {
//       await launch('tel://${Environment.csPhone}');
//     }
//   }
// }

// Widget _buildLoading() {
//   return ListView.builder(
//     itemCount: 5,
//     itemBuilder: (context, index) => Card(
//       margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//       child: ListTile(
//         title: Skeleton(
//           width: MediaQuery.of(context).size.width - 140,
//           height: 20.0,
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Skeleton(
//             width: MediaQuery.of(context).size.width - 190,
//             height: 20.0,
//           ),
//         ),
//         trailing: Skeleton(
//           width: 20.0,
//           height: 20.0,
//         ),
//       ),
//     ),
//   );
// }

// Widget _cardContent(HelpModel dataHelp) {
//   return ExpandableNotifier(
//     child: ScrollOnExpand(
//       scrollOnExpand: false,
//       scrollOnCollapse: true,
//       child: Card(
//         margin: EdgeInsets.only(top: 10, left: 10, right: 10),
//         clipBehavior: Clip.antiAlias,
//         child: ScrollOnExpand(
//           scrollOnExpand: true,
//           scrollOnCollapse: false,
//           child: ExpandablePanel(
//             tapHeaderToExpand: true,
//             tapBodyToCollapse: true,
//             headerAlignment: ExpandablePanelHeaderAlignment.center,
//             header: Padding(
//               padding: EdgeInsets.all(10),
//               child: Text(
//                 dataHelp.title,
//                 style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
//               ),
//             ),
//             expanded: Padding(
//               padding: EdgeInsets.only(bottom: 10),
//               child: Html(
//                   data: dataHelp.description.replaceAll('\n', '</br>'),
//                   defaultTextStyle:
//                       TextStyle(color: Colors.black, fontSize: 14.0),
//                   customTextAlign: (dom.Node node) {
//                     return TextAlign.justify;
//                   }),
//             ),
//             builder: (_, collapsed, expanded) {
//               return Padding(
//                 padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                 child: Expandable(
//                   collapsed: collapsed,
//                   expanded: expanded,
//                   crossFadePoint: 0,
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     ),
//   );
// }
