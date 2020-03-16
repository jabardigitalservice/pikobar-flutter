// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:pedantic/pedantic.dart';
// import 'package:sapawarga/blocs/banner/Bloc.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Dimens.dart';
// import 'package:sapawarga/constants/Navigation.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/exceptions/CustomException.dart';
// import 'package:sapawarga/models/BannerModel.dart';
// import 'package:sapawarga/models/PollingModel.dart';
// import 'package:sapawarga/repositories/PollingRepository.dart';
// import 'package:sapawarga/repositories/SurveyRepository.dart';
// import 'package:sapawarga/screens/importantInformation/ImportantInfoDetailScreen.dart';
// import 'package:sapawarga/screens/news/NewsDetailScreen.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:math' as math;

// class BannerListSlider extends StatefulWidget {

//   @override
//   _BannerListSliderState createState() => _BannerListSliderState();
// }

// class _BannerListSliderState extends State<BannerListSlider> {
//   int _bannerPosition = 0;

//   @override
//   Widget build(BuildContext context) {
//     return

//     BlocBuilder<BannerListBloc, BannerListState>(
//       builder: (context, state) => state is BannerListLoading
//           ? _buildLoading()
//           : state is BannerListLoaded ? _buildSlider(state) : Container(),
//     );
//   }

//   Widget _buildLoading() {
//     return AspectRatio(
//       aspectRatio: 21 / 9,
//       child: ListView.builder(
//           padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
//           scrollDirection: Axis.horizontal,
//           itemCount: 3,
//           itemBuilder: (context, index) {
//             return Container(
//                 margin: EdgeInsets.symmetric(horizontal: 8.0),
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 decoration: BoxDecoration(shape: BoxShape.circle),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Skeleton(
//                     width: MediaQuery.of(context).size.width,
//                   ),
//                 ));
//           }),
//     );
//   }

//   _buildSlider(BannerListLoaded state) {
//     return CarouselSlider(
//         initialPage: 0,
//         enableInfiniteScroll: true,
//         aspectRatio: 21/9,
//         viewportFraction: 0.9,
//         autoPlay: true,
//         autoPlayInterval: Duration(seconds: 5),
//         items: state.records.map((data) {
//           return Builder(
//               builder: (BuildContext context) {
//                 return GestureDetector(
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 8.0),
//                     decoration: BoxDecoration(shape: BoxShape.circle),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.0),
//                       child: CachedNetworkImage(
//                           imageUrl: data.imagePathUrl,
//                           imageBuilder: (context, imageProvider) =>
//                               Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                       topLeft: Radius.circular(5.0),
//                                       topRight: Radius.circular(5.0)),
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.fill,
//                                   ),
//                                 ),
//                               ),
//                           placeholder: (context, url) =>
//                               Center(
//                                   heightFactor: 10.2,
//                                   child: CupertinoActivityIndicator()),
//                           errorWidget: (context, url, error) =>
//                               Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(5.0),
//                                         topRight: Radius.circular(5.0)),
//                                   ),
//                                   child: Image.asset(
//                                       '${Environment
//                                           .imageAssets}placeholder.png',
//                                       fit: BoxFit.fitWidth))),
//                     ),
//                   ),
//                   onTap: () {
//                     _clickAction(data);

//                     AnalyticsHelper.setLogEvent(
//                         '${Analytics.EVENT_TAPPED_BANNER}$_bannerPosition', <String, dynamic>{
//                       'id': data.id,
//                       'title': data.title.substring(0, math.min(data.title.length, 80))
//                     });

//                     AnalyticsHelper.setLogEvent(
//                         Analytics.EVENT_VIEW_DETAIL_BANNER, <String, dynamic>{
//                       'id': data.id,
//                       'title': data.title.substring(0, math.min(data.title.length, 80))
//                     });
//                   },
//                 );
//     });
//         }).toList(),
//     onPageChanged: (index) {
//           _bannerPosition = index;
//     },);
//   }

//   _clickAction(BannerModel record) {
//     if (record.type == 'internal') {
//       switch (record.internalCategory) {
//         case 'news':
//           _openDetailNews(record.internalEntityId);
//           break;

//         case 'polling':
//           _openDetailPolling(record.internalEntityId);
//           break;

//         case 'survey':
//           _openDetailSurvey(record.internalEntityId);
//           break;

//         case 'news-important':
//           _openDetailImportantInfo(record.internalEntityId);
//           break;
//       }
//     } else {
//       _openInAppBrowser(record.linkUrl);
//     }
//   }

//   _openDetailNews(int id) {
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => NewsDetailScreen(newsId: id, isIdKota: false)));
//   }

//   _openDetailSurvey(int id) async {
//     try {
//       String externalUrl = await SurveyRepository().getUrl(id);
//       await Navigator.pushNamed(context, NavigationConstrants.Browser,
//           arguments: externalUrl);
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

//   _openDetailPolling(int id) async {
//     PollingRepository _pollingRepository = PollingRepository();

//     try {
//       bool isVoted = await _pollingRepository.getVoteStatus(pollingId: id);

//       if (!isVoted) {
//         PollingModel record = await _pollingRepository.getDetail(id);
//         await Navigator.pushNamed(context, NavigationConstrants.PollingDetail,
//             arguments: record);
//       } else {
//         unawaited(Fluttertoast.showToast(
//             msg: Dictionary.pollingHasVotedMessage,
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.TOP,
//             backgroundColor: Colors.blue,
//             textColor: Colors.white));
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
//         await Navigator.pushNamed(context, NavigationConstrants.Browser,
//             arguments: externalUrl);
//       }
//     }
//   }

// }
