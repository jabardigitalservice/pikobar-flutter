import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/VideoListBloc.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';

// ignore: must_be_immutable
class VideoList extends StatefulWidget {
  final String searchQuery;
  CovidInformationScreenState covidInformationScreenState;

  VideoList({Key key, this.searchQuery, this.covidInformationScreenState})
      : super(key: key);

  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew = LabelNew();

  @override
  Widget build(BuildContext context) {
    return BlocListener<VideoListBloc, VideoListState>(
      listener: (context, state) {
        if (state is VideosLoaded) {
          isGetDataLabel = true;
          getDataLabel();
        }
      },
      child:
          BlocBuilder<VideoListBloc, VideoListState>(builder: (context, state) {
        return state is VideosLoaded
            ? BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                builder: (context, remoteState) {
                return remoteState is RemoteConfigLoaded
                    ? _buildContent(state.videos, remoteState.remoteConfig)
                    : _buildLoading();
              })
            : _buildLoading();
      }),
    );
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelVideos).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
    }
  }

  Widget _buildLoading() {
    return Container(
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          padding: const EdgeInsets.only(
              right: Dimens.padding,
              top: Dimens.padding,
              bottom: Dimens.padding),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                width: 150.0,
                height: 150.0,
                padding: const EdgeInsets.only(left: Dimens.padding),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 140,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Skeleton(
                          width: MediaQuery.of(context).size.width / 1.4,
                          padding: 10.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Skeleton(
                                  height: 20.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
                                  padding: 10.0,
                                ),
                                SizedBox(height: 8),
                                Skeleton(
                                  height: 20.0,
                                  width: MediaQuery.of(context).size.width / 2,
                                  padding: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget _buildContent(List<VideoModel> data, RemoteConfig remoteConfig) {
    Map<String, dynamic> getLabel = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.labels,
        defaultValue: FirebaseConfig.labelsDefaultValue);

    if (widget.searchQuery != null) {
      data = data
          .where((test) => test.title
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();

      if (data.isEmpty) {
        widget.covidInformationScreenState.isEmptyDataVideoList = true;
      }
    }

    getDataLabel();

    return data.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      getLabel['video']['title'],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsFamily.roboto,
                          fontSize: Dimens.textTitleSize),
                    ),
                    InkWell(
                      child: Text(
                        Dictionary.more,
                        style: TextStyle(
                            color: Color(0xFF27AE60),
                            fontWeight: FontWeight.w600,
                            fontFamily: FontsFamily.roboto,
                            fontSize: Dimens.textSubtitleSize),
                      ),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                                context, NavigationConstrants.VideoList,
                                arguments: widget.covidInformationScreenState)
                            as bool;

                        if (result) {
                          isGetDataLabel = result;
                          getDataLabel();
                        }

                        AnalyticsHelper.setLogEvent(Analytics.tappedVideoMore);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 265.0,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    padding: const EdgeInsets.only(
                        right: Dimens.padding, bottom: Dimens.padding),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.searchQuery != null ? data.length : 5,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(left: Dimens.padding),
                        width: 150.0,
                        height: 150.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Container(
                                width: 140.0,
                                height: 150.0,
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                            child:
                                                CupertinoActivityIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                heightFactor: 10.2,
                                                child: Icon(Icons.error)),
                                      ),
                                    ),
                                    Image.asset(
                                      '${Environment.iconAssets}play_button.png',
                                      scale: 2.3,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  labelNew.readNewInfo(
                                      data[index].id,
                                      data[index].publishedAt.toString(),
                                      dataLabel,
                                      Dictionary.labelVideos);
                                  widget.covidInformationScreenState.widget
                                      .homeScreenState
                                      .getAllUnreadData();
                                });
                                launchExternal(data[index].url);

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedVideo, <String, dynamic>{
                                  'title': data[index].title
                                });
                              },
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
                                            fontSize: 14.0,
                                            fontFamily: FontsFamily.roboto,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                labelNew.isLabelNew(
                                        data[index].id.toString(), dataLabel)
                                    ? LabelNewScreen()
                                    : Container(),
                                Expanded(
                                  child: Text(
                                    unixTimeStampToCustomDateFormat(
                                        data[index].publishedAt,
                                        'EEEE, dd MMM yyyy'),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: FontsFamily.roboto,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20)
                          ],
                        ),
                      );
                    }),
              ),
            ],
          )
        : Container();
  }
}
