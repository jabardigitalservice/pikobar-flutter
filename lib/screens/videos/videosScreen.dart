import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';

// ignore: must_be_immutable
class VideosScreen extends StatelessWidget {
  CovidInformationScreenState covidInformationScreenState;

  VideosScreen({Key key, this.covidInformationScreenState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoListBloc>(
      create: (context) => VideoListBloc()..add(LoadVideos()),
      child:
          VideosList(covidInformationScreenState: covidInformationScreenState),
    );
  }
}

// ignore: must_be_immutable
class VideosList extends StatefulWidget {
  CovidInformationScreenState covidInformationScreenState;

  VideosList({Key key, this.covidInformationScreenState}) : super(key: key);

  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  // ignore: close_sinks
  ScrollController _scrollController;
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  List<VideoModel> listVideos;
  String searchQuery;
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew = LabelNew();

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.video);
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        setState(() {
          searchQuery = _searchController.text;
        });
        AnalyticsHelper.setLogEvent(Analytics.tappedSearchVideo);
      } else {
        _clearSearchQuery();
      }
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      child: CollapsingAppbar(
        searchBar: CustomAppBar.buildSearchField(
            _searchController, Dictionary.searchInformation, updateSearchQuery),
        showTitle: _showTitle,
        titleAppbar: Dictionary.videoUpToDate,
        scrollController: _scrollController,
        body: BlocBuilder<VideoListBloc, VideoListState>(
          builder: (context, state) {
            return state is VideosLoading
                ? _buildLoading()
                : state is VideosLoaded
                    ? _buildContent(state)
                    : Container();
          },
        ),
      ),
      onWillPop: _onWillPop,
    ));
  }

  _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 6,
            padding: const EdgeInsets.all(10.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                height: 300.0,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Skeleton(
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  _buildContent(VideosLoaded state) {
    if (searchQuery != null) {
      listVideos = state.videos
          .where((test) =>
              test.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      listVideos = state.videos;
    }

    getDataLabel();

    return Container(
        child: listVideos.isNotEmpty
            ? ListView.builder(
                itemCount: listVideos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: Dimens.padding,
                              right: Dimens.padding,
                              bottom: Dimens.padding),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: getYtThumbnail(
                                        youtubeUrl: listVideos[index].url,
                                        error: false),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                      heightFactor: 4.2,
                                      child: CupertinoActivityIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            height: 200,
                                            color: Colors.grey[200]),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(0.2),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                      Dimens.dialogRadius),
                                ),
                              ),
                              Image.asset(
                                '${Environment.iconAssets}play_button_black.png',
                                scale: 3,
                              ),
                              Positioned(
                                left: 10,
                                right: 10,
                                bottom: 0,
                                top: 215,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        labelNew.isLabelNew(
                                                listVideos[index].id.toString(),
                                                dataLabel)
                                            ? LabelNewScreen()
                                            : Container(),
                                        Expanded(
                                          child: Text(
                                            unixTimeStampToDateTime(
                                                listVideos[index].publishedAt),
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontFamily: FontsFamily.roboto),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      listVideos[index].title,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: FontsFamily.roboto),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            labelNew.readNewInfo(
                                listVideos[index].id,
                                listVideos[index].publishedAt.toString(),
                                dataLabel,
                                Dictionary.labelVideos);
                            if (widget.covidInformationScreenState != null) {
                              widget.covidInformationScreenState.widget
                                  .homeScreenState
                                  .getAllUnreadData();
                            }
                          });
                          launchExternal(listVideos[index].url);

                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedVideo, <String, dynamic>{
                            'title': listVideos[index].title
                          });
                        },
                      ),
                    ],
                  );
                })
            : ListView(
                children: [
                  EmptyData(
                    message: Dictionary.emptyData,
                    desc: Dictionary.descEmptyData,
                    isFlare: false,
                    image: "${Environment.imageAssets}not_found.png",
                  ),
                ],
              ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
