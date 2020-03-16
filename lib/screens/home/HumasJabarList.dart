// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sapawarga/blocs/humasjabar_list/Bloc.dart';
// import 'package:sapawarga/blocs/humasjabar_list/HumasJabarListBloc.dart';
// import 'package:sapawarga/components/BrowserScreen.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:sapawarga/repositories/HumasJabarRepository.dart';
// import 'package:sapawarga/constants/Colors.dart' as color;
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';

// class HumasJabarListScreen extends StatelessWidget {
//   final HumasJabarRepository humasJabarRepository = HumasJabarRepository();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<HumasJabarListBloc>(
//       create: (BuildContext context) =>
//           HumasJabarListBloc(humasJabarRepository: humasJabarRepository),
//       child: HumasJabarList(),
//     );
//   }
// }

// class HumasJabarList extends StatefulWidget {
//   @override
//   _HumasJabarList createState() => _HumasJabarList();
// }

// class _HumasJabarList extends State<HumasJabarList> {
//   HumasJabarListBloc _humasJabarListBloc;

//   @override
//   void initState() {
//     super.initState();
//     _humasJabarListBloc = BlocProvider.of<HumasJabarListBloc>(context);
//     _humasJabarListBloc.add(HumasJabarLoad());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HumasJabarListBloc, HumasJabarListState>(
//       bloc: _humasJabarListBloc,
//       builder: (context, state) {
//         return Container(
//             child: state is HumasJabarLoading
//                 ? _buildLoading()
//                 : state is HumasJabarLoaded
//                     ? _buildContent(state)
//                     : state is HumasJabarFailure
//                         ? _buildFailure(state)
//                         : Container());
//       },
//     );
//   }

//   _buildLoading() {
//     return CarouselSlider(
//         initialPage: 0,
//         enableInfiniteScroll: false,
//         height: 260.0,
//         viewportFraction: 0.9,
//         items: [1, 2, 3].map((record) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Card(
//                     elevation: 5.0,
//                     margin: EdgeInsets.symmetric(vertical: 15.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 180.0,
//                           child: Skeleton(
//                             height: 170.0,
//                             width: MediaQuery.of(context).size.width,
//                           ),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           margin: EdgeInsets.all(15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Skeleton(
//                                 height: 20.0,
//                                 width: MediaQuery.of(context).size.width / 2,
//                               ),
//                               Skeleton(
//                                 height: 20.0,
//                                 width: 40.0,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ));
//             },
//           );
//         }).toList());
//   }

//   _buildFailure(HumasJabarFailure state) {
//     return Container(child: Text(state.error));
//   }

//   _buildContent(HumasJabarLoaded state) {
//     return CarouselSlider(
//         initialPage: 0,
//         height: MediaQuery.of(context).size.height * 0.38,
//         enableInfiniteScroll: false,
//         viewportFraction: 0.9,
//         items: state.records.map((humasJabar) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 5.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Container(
//                         height: MediaQuery.of(context).size.height * 0.28,
//                         width: MediaQuery.of(context).size.width,
//                         child: CachedNetworkImage(
//                           imageUrl: humasJabar.thumbnail,
//                           imageBuilder: (context, imageProvider) => Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8.0),
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.fill,
//                               ),
//                             ),
//                           ),
//                           placeholder: (context, url) => Center(
//                               heightFactor: 10.2,
//                               child: CupertinoActivityIndicator()),
//                           errorWidget: (context, url, error) => Center(
//                               heightFactor: 10.2, child: Icon(Icons.error)),
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         margin: EdgeInsets.only(top: 10.0),
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Text(
//                                 humasJabar.postTitle,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 maxLines: 1,
//                                 style: TextStyle(
//                                     color: Color.fromRGBO(0, 0, 0, 0.53),
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 8.0,
//                             ),
//                             RaisedButton(
//                               onPressed: () {
//                                 AnalyticsHelper.setLogEvent(
//                                     Analytics.EVENT_VIEW_DETAIL_HUMAS,
//                                     <String, dynamic>{
//                                       'id': humasJabar.id,
//                                       'title': humasJabar.postTitle
//                                     });

//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => BrowserScreen(
//                                       url: humasJabar.slug,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               color: color.Colors.blue,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(7.0)),
//                               child: Text(
//                                 'Baca',
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ));
//             },
//           );
//         }).toList());
//   }

// }
