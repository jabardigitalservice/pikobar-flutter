import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/VideoListBloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';
import 'package:share/share.dart';

class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoListBloc, VideoListState>(
        builder: (context, state) {
      return state is VideosLoaded
          ? _buildContent(state.videos)
          : _buildLoading();
    });
  }

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
          child: Text(
            Dictionary.videoUpToDate,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: FontsFamily.productSans,
                fontSize: 16.0),
          ),
        ),
        CarouselSlider(
            initialPage: 0,
            enableInfiniteScroll: false,
            height: 260.0,
            viewportFraction: 0.9,
            items: [1, 2, 3].map((record) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 5.0,
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Skeleton(
                              height: 180.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                            Skeleton(
                              height: 20.0,
                              margin: 10.0,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ],
                        ),
                      ));
                },
              );
            }).toList()),
      ],
    );
  }

  Widget _buildContent(List<VideoModel> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Dictionary.videoUpToDate,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.productSans,
                    fontSize: 16.0),
              ),
              InkWell(
                child: Text(
                  Dictionary.more,
                  style: TextStyle(
                      color: Color(0xFF27AE60),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.productSans,
                      fontSize: 14.0),
                ),
                onTap: () {
                  Navigator.pushNamed(context, NavigationConstrants.VideoList);

                  AnalyticsHelper.setLogEvent(Analytics.tappedVideoMore);
                },
              ),
            ],
          ),
        ),
         Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0,bottom: 15),
          child: Text(
            Dictionary.videoUpToDateDesc,
            style: TextStyle(
                color: Color(0xff828282),
                fontSize: 12.0,),
            textAlign: TextAlign.left,
          ),
        ),

        Container(
          height: 280.0,
          child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                 
                  margin: EdgeInsets.only(right: 15.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  // decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180.0,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: getYtThumbnail(
                                      youtubeUrl: data[index].url,
                                      error: false),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                      heightFactor: 10.2,
                                      child: CupertinoActivityIndicator()),
                                  errorWidget: (context, url, error) =>
                                      CachedNetworkImage(
                                    imageUrl: getYtThumbnail(
                                        youtubeUrl: data[index].url,
                                        error: true),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(
                                        heightFactor: 10.2,
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                            heightFactor: 10.2,
                                            child: Icon(Icons.error)),
                                  ),
                                ),
                                Image.asset(
                                  '${Environment.iconAssets}play_button.png',
                                  scale: 1.5,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            launchExternal(data[index].url);

                            AnalyticsHelper.setLogEvent(Analytics.tappedVideo,
                                <String, dynamic>{'title': data[index].title});
                          },
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top:10),
                          child: Text(unixTimeStampToDateWithoutDay(
                                data[index].publishedAt),
                            style: TextStyle(
                                color: Color(0xffBDBDBD),
                                fontFamily: FontsFamily.productSans,
                                fontSize: 10.0),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  height: 40.0,
                                  margin: EdgeInsets.only(right: 5.0),
                                  child: Text(
                                    data[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.0,
                                child: GestureDetector(
                                  child: Icon(FontAwesomeIcons.share,
                                      size: 17, color: ColorBase.green),
                                  onTap: () {
                                    _shareVideo(
                                        data[index].title, data[index].url);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  _shareVideo(String title, String url) {
    Share.share(
        '$title \n\nTonton video lengkapnya:\n$url \n\n${Dictionary.sharedFrom}');

    AnalyticsHelper.setLogEvent(
        Analytics.tappedVideoShare, <String, dynamic>{'title': title});
  }
}
