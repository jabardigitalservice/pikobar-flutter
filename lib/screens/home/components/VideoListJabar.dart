// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sapawarga/blocs/video_list/Bloc.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Dimens.dart';
// import 'package:sapawarga/constants/FontsFamily.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VideoListJabar extends StatefulWidget {
//   @override
//   _VideoListJabarState createState() => _VideoListJabarState();
// }

// class _VideoListJabarState extends State<VideoListJabar> {

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<VideoListJabarBloc, VideoListJabarState>(
//       builder: (context, state) => state is VideoListJabarLoading
//           ? _buildLoading()
//           : state is VideoListJabarLoaded
//               ? _buildContent(state)
//               : Container(),
//     );
//   }

//   Widget _buildLoading() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
//           child: Text(
//             Dictionary.videoPostJabar,
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: FontsFamily.productSans,
//                 fontSize: 16.0),
//           ),
//         ),
//         CarouselSlider(
//             initialPage: 0,
//             enableInfiniteScroll: false,
//             height: 260.0,
//             viewportFraction: 0.9,
//             items: [1, 2, 3].map((record) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return Container(
//                       width: MediaQuery.of(context).size.width,
//                       margin: EdgeInsets.symmetric(horizontal: 8.0),
//                       child: Card(
//                         elevation: 5.0,
//                         margin: EdgeInsets.symmetric(vertical: 15.0),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Skeleton(
//                               height: 180.0,
//                               width: MediaQuery.of(context).size.width,
//                             ),
//                             Skeleton(
//                               height: 20.0,
//                               margin: 10.0,
//                               width: MediaQuery.of(context).size.width,
//                             ),
//                           ],
//                         ),
//                       ));
//                 },
//               );
//             }).toList()),
//       ],
//     );
//   }

//   Widget _buildContent(VideoListJabarLoaded state) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
//           child: Text(
//             Dictionary.videoPostJabar,
//             style: TextStyle(
//                 color: Color.fromRGBO(0, 0, 0, 0.73),
//                 fontWeight: FontWeight.bold,
//                 fontFamily: FontsFamily.productSans,
//                 fontSize: 18.0),
//           ),
//         ),
//         Container(
//           height: 280.0,
//           child: ListView.builder(
//               padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
//               scrollDirection: Axis.horizontal,
//               itemCount: state.records.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   margin: EdgeInsets.only(right: 8.0),
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   decoration: BoxDecoration(shape: BoxShape.circle),
//                   child: Card(
//                     elevation: 5.0,
//                     margin: EdgeInsets.symmetric(vertical: 15.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         GestureDetector(
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 180.0,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: <Widget>[
//                                 CachedNetworkImage(
//                                   imageUrl: _youtubeThumbnail(
//                                       youtubeUrl: state.records[index].videoUrl,
//                                       error: false),
//                                   imageBuilder: (context, imageProvider) =>
//                                       Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.only(
//                                           topLeft: Radius.circular(5.0),
//                                           topRight: Radius.circular(5.0)),
//                                       image: DecorationImage(
//                                         image: imageProvider,
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ),
//                                   placeholder: (context, url) => Center(
//                                       heightFactor: 10.2,
//                                       child: CupertinoActivityIndicator()),
//                                   errorWidget: (context, url, error) =>
//                                       CachedNetworkImage(
//                                     imageUrl: _youtubeThumbnail(
//                                         youtubeUrl:
//                                             state.records[index].videoUrl,
//                                         error: true),
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.only(
//                                             topLeft: Radius.circular(5.0),
//                                             topRight: Radius.circular(5.0)),
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                     ),
//                                     placeholder: (context, url) => Center(
//                                         heightFactor: 10.2,
//                                         child: CupertinoActivityIndicator()),
//                                     errorWidget: (context, url, error) =>
//                                         Center(
//                                             heightFactor: 10.2,
//                                             child: Icon(Icons.error)),
//                                   ),
//                                 ),
//                                 Image.asset(
//                                   'assets/icons/play_button.png',
//                                   scale: 1.5,
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                             _launchURL(state.records[index].videoUrl);

//                             AnalyticsHelper.setLogEvent(
//                                 Analytics.EVENT_VIEW_DETAIL_JABAR_VIDEO_POST);
//                           },
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           margin: EdgeInsets.all(15.0),
//                           child: Text(
//                             state.records[index].title,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 fontSize: 13.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//         ),
//       ],
//     );
//   }

//   _launchURL(String youtubeUrl) async {
//     if (await canLaunch(youtubeUrl)) {
//       await launch(youtubeUrl);
//     } else {
//       throw 'Could not launch $youtubeUrl';
//     }
//   }

//   // _playVideo(String url) {
//   //   FlutterYoutube.playYoutubeVideoByUrl(
//   //     apiKey: Environment.googleApiKey,
//   //     videoUrl: url,
//   //     fullScreen: true,
//   //     autoPlay: true,
//   //   );
//   // }

//   String _youtubeThumbnail({String youtubeUrl, bool error}) {
//     Uri uri = Uri.parse(youtubeUrl);
//     String thumbnailUrl = "";
//     if (!error) {
//       thumbnailUrl =
//           'https://img.youtube.com/vi/${uri.queryParameters['v']}/maxresdefault.jpg';
//     } else {
//       thumbnailUrl =
//           'https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg';
//     }
//     return thumbnailUrl;
//   }

// }
