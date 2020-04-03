import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/blocs/video/videoList/video_list_bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/VideoRepository.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class VideosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoListBloc>(
      create: (context) => VideoListBloc(
        videoRepository: VideoRepository(),
      )..add(LoadVideos()),
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
      appBar: AppBar(
        title: CustomAppBar.setTitleAppBar(Dictionary.videoUpToDate),
      ),
      body: BlocBuilder<VideoListBloc, VideoListState>(
        bloc: _videoListBloc,
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
      child: ListView.builder(
          itemCount: state.videos.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
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
                          errorWidget: (context, url, error) =>
                              Container(height: 200, color: Colors.grey[200]),
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

                    AnalyticsHelper.setLogEvent(Analytics.tappedVideo,
                        <String, dynamic>{'title': state.videos[index].title});
                  },
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(Dimens.padding, 10.0, Dimens.padding, 30.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            state.videos[index].title,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            height: 40.0,
                            padding: EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Icon(FontAwesomeIcons.solidShareSquare, size: 17, color: ColorBase.green),
                          ),
                          onTap: () {
                            _shareApp(state.videos[index].title,
                                state.videos[index].url);
                          },
                        )
                      ],
                    )),
              ],
            );
          }),
    );
  }

  _shareApp(String title, String sourceUrl) {
    Share.share('$title \n\nTonton video lengkapnya:\n$sourceUrl \n\n_dibagikan dari Pikobar_');

    AnalyticsHelper.setLogEvent(
        Analytics.tappedVideoShare, <String, dynamic>{'title': title});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
