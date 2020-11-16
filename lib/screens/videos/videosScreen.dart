import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/ShareButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class VideosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoListBloc>(
      create: (context) => VideoListBloc()..add(LoadVideos()),
      child: VideosList(),
    );
  }
}

class VideosList extends StatefulWidget {
  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  // ignore: close_sinks
  VideoListBloc _videoListBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.video);

    _videoListBloc = BlocProvider.of<VideoListBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: Dictionary.videoUpToDate,
      ),
      body: BlocBuilder<VideoListBloc, VideoListState>(
        builder: (context, state) {
          return state is VideosLoading
              ? _buildLoading()
              : state is VideosLoaded ? _buildContent(state) : Container();
        },
      ),
    );
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey[300]),
                Container(
                  padding: EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          color: Colors.grey[300]),
                      SizedBox(height: 5.0),
                      Container(
                          width: MediaQuery.of(context).size.width - 160,
                          height: 20.0,
                          color: Colors.grey[300]),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildContent(VideosLoaded state) {
    return Container(
      child: state.videos.isNotEmpty
          ? ListView.builder(
              itemCount: state.videos.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: getYtThumbnail(
                                  youtubeUrl: state.videos[index].url,
                                  error: false),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                heightFactor: 4.2,
                                child: CupertinoActivityIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                  height: 200, color: Colors.grey[200]),
                            ),
                            Image.asset(
                              '${Environment.iconAssets}play_button.png',
                              scale: 1.5,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        launchExternal(state.videos[index].url);

                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedVideo, <String, dynamic>{
                          'title': state.videos[index].title
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          Dimens.padding, 10.0, Dimens.padding, 0),
                      child: Text(
                        unixTimeStampToDateTime(
                            state.videos[index].publishedAt),
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: FontsFamily.lato,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            Dimens.padding, 10.0, Dimens.padding, 30.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                state.videos[index].title,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontsFamily.lato),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            ShareButton(
                              height: 40.0,
                              paddingLeft: 20,
                              paddingRight: 10,
                              onPressed: () {
                                _shareApp(state.videos[index].title,
                                    state.videos[index].url);
                              },
                            ),
                          ],
                        )),
                  ],
                );
              })
          : EmptyData(
              message: Dictionary.emptyData,
              desc: '',
              isFlare: false,
              image: "${Environment.imageAssets}not_found.png",
            ),
    );
  }

  _shareApp(String title, String sourceUrl) {
    Share.share(
        '$title \n\nTonton video lengkapnya:\n$sourceUrl \n\n${Dictionary.sharedFrom}');

    AnalyticsHelper.setLogEvent(
        Analytics.tappedVideoShare, <String, dynamic>{'title': title});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
