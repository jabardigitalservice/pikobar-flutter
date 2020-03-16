// import 'package:device_apps/device_apps.dart';
// import 'package:fancy_on_boarding/fancy_on_boarding.dart';
// import 'package:flutter/material.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Colors.dart' as clr;
// import 'package:sapawarga/constants/Dimens.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class OnBoardingData {
//   static List<PageModel> onboardingList = [
//     PageModel(
//         color: Colors.indigo,
//         heroAssetPath: 'assets/images/onboarding/onboarding1.png',
//         title: Text(Dictionary.titleOnboarding1,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               fontSize: 25.0,
//             )),
//         body: Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Text(Dictionary.textOnboarding1,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20.0,
//               )),
//         ),
//         iconAssetPath: 'assets/logo/logo-small.png'),
//     PageModel(
//         color: Colors.green,
//         heroAssetPath: 'assets/images/onboarding/onboarding2.png',
//         title: Text(Dictionary.titleOnboarding2,
//             style: TextStyle(
//               fontWeight: FontWeight.w800,
//               color: Colors.white,
//               fontSize: 25.0,
//             )),
//         body: Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Text(Dictionary.textOnboarding2,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18.0,
//               )),
//         ),
//         iconAssetPath: 'assets/logo/logo-small.png'),
//     PageModel(
//       color: Colors.blue,
//       heroAssetPath: 'assets/images/onboarding/onboarding3.png',
//       title: Text(Dictionary.titleOnboarding3,
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//             fontSize: 25.0,
//           )),
//       body: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: Text(Dictionary.textOnboarding3,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18.0,
//             )),
//       ),
//       iconAssetPath: 'assets/logo/logo-small.png',
//     ),
//     PageModel(
//       color: Colors.grey[800],
//       heroAssetPath: 'assets/images/onboarding/onboarding4.png',
//       title: Text(Dictionary.titleOnboarding4,
//           style: TextStyle(
//             fontWeight: FontWeight.w800,
//             color: Colors.white,
//             fontSize: 25.0,
//           )),
//       body: Padding(
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           children: <Widget>[
//             Text(Dictionary.textOnboarding4,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                 )),
//             SizedBox(height: Dimens.padding),
//             RaisedButton(
//                 color: clr.Colors.blue,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//                 child: Text(Dictionary.tapHelp, style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)),
//                 onPressed: () async {
//                   try {
//                     bool isInstalled = await DeviceApps.isAppInstalled('com.whatsapp');
//                     if (isInstalled) {
//                       String urlWhatsApp = 'https://wa.me/${Environment.csPhone}?text=${Uri.encodeFull(Dictionary.helpAdminWA)}%0A%0A';
//                       if (await canLaunch(urlWhatsApp)) {
//                         await AnalyticsHelper.setLogEvent(
//                             Analytics.EVENT_OPEN_WA_ADMIN_LOGIN);
//                         await launch(urlWhatsApp);
//                       } else {
//                         await AnalyticsHelper.setLogEvent(
//                             Analytics.EVENT_OPEN_TELP_ADMIN_LOGIN);
//                         await launch('tel://${Environment.csPhone}');
//                       }
//                     } else {
//                       await AnalyticsHelper.setLogEvent(
//                           Analytics.EVENT_OPEN_TELP_ADMIN_LOGIN);
//                       await launch('tel://${Environment.csPhone}');
//                     }
//                   } catch (_) {
//                     await AnalyticsHelper.setLogEvent(Analytics.EVENT_OPEN_TELP_ADMIN_LOGIN);
//                     await launch('tel://${Environment.csPhone}');
//                   }
//                 }),
//           ],
//         )
//       ),
//       iconAssetPath: 'assets/logo/logo-small.png',
//     ),
//   ];
// }
