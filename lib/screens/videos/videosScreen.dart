import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/components/ThumbnailCard.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';

class VideosScreen extends StatelessWidget {
  final CovidInformationScreenState covidInformationScreenState;
  final String title;

  const VideosScreen({Key key, this.covidInformationScreenState, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoListBloc>(
      create: (context) => VideoListBloc(),
      child: VideosList(
        covidInformationScreenState: covidInformationScreenState,
        title: title,
      ),
    );
  }
}

class VideosList extends StatefulWidget {
  final CovidInformationScreenState covidInformationScreenState;
  final String title;

  const VideosList({Key key, this.covidInformationScreenState, this.title})
      : super(key: key);

  @override
  _VideosListState createState() => _VideosListState();
}

class _VideosListState extends State<VideosList> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  final int _limitMax = 500;
  final int _limitPerPage = 10;
  final int _limitPerSearch = 25;

  List<LabelNewModel> _dataLabel = [];
  List<VideoModel> _allVideos;
  List<VideoModel> _limitedVideos = [];

  bool _isGetDataLabel = true;
  LabelNew _labelNew = LabelNew();
  VideoListBloc _videoListBloc;
  Timer _debounce;
  String _searchQuery;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.video);

    _videoListBloc = BlocProvider.of<VideoListBloc>(context);
    _videoListBloc.add(LoadVideos(limit: _limitMax));

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        await _getMoreData();
      }

      setState(() {});
    });

    _searchController.addListener((() {
      _onSearchChanged();
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: WillPopScope(
          child: CollapsingAppbar(
            searchBar: CustomAppBar.buildSearchField(context, _searchController,
                Dictionary.searchInformation, _updateSearchQuery),
            showTitle: _showTitle,
            titleAppbar: widget.title,
            scrollController: _scrollController,
            body: BlocListener<VideoListBloc, VideoListState>(
              listener: (_, state) {
                if (state is VideosLoaded) {
                  _allVideos = state.videos;

                  int limit = _allVideos.length > _limitPerPage
                      ? _limitPerPage
                      : _allVideos.length;

                  _limitedVideos.addAll(_allVideos.getRange(0, limit).toList());
                }
                _getDataLabel();
              },
              child: BlocBuilder<VideoListBloc, VideoListState>(
                builder: (context, state) {
                  return state is VideosLoading
                      ? _buildLoading()
                      : state is VideosLoaded
                          ? _buildContent(_limitedVideos)
                          : Container();
                },
              ),
            ),
          ),
          onWillPop: _onWillPop,
        ));
  }

  _buildLoading() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 6,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            height: 300.0,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                  child:
                      Skeleton(width: MediaQuery.of(context).size.width - 40),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildContent(List<VideoModel> listVideos) {
    if (_searchQuery != null) {
      listVideos = _allVideos
          .where((test) =>
              test.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .take(_limitPerSearch)
          .toList();
    }

    int itemCount =
        _searchQuery == null && listVideos.length != _allVideos.length
            ? listVideos.length + 1
            : listVideos.length;

    return listVideos.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.only(bottom: 16.0, top: 10.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == listVideos.length) {
                return CupertinoActivityIndicator();
              }

              return _cardContent(listVideos[index]);
            })
        : EmptyData(
            message: Dictionary.emptyData,
            desc: Dictionary.descEmptyData,
            isFlare: false,
            image: "${Environment.imageAssets}not_found.png",
          );
  }

  Widget _cardContent(VideoModel data) {
    return ThumbnailCard(
      imageUrl: getYtThumbnail(youtubeUrl: data.url, error: false),
      title: data.title,
      date: unixTimeStampToDateTime(data.publishedAt),
      label: _labelNew.isLabelNew(data.id.toString(), _dataLabel)
          ? LabelNewScreen()
          : Container(),
      onTap: () {
        setState(() {
          _labelNew.readNewInfo(data.id, data.publishedAt.toString(),
              _dataLabel, Dictionary.labelVideos);
          if (widget.covidInformationScreenState != null) {
            widget.covidInformationScreenState.widget.homeScreenState
                .getAllUnreadData();
          }
        });
        launchExternal(data.url);

        AnalyticsHelper.setLogEvent(
            Analytics.tappedVideo, <String, dynamic>{'title': data.title});
      },
    );
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  Future<void> _getMoreData() async {
    if (_searchQuery == null) {
      final nextPage = _limitedVideos.length + _limitPerPage;
      final limit =
          _allVideos.length > nextPage ? nextPage : _limitedVideos.length;

      _limitedVideos
          .addAll(_allVideos.getRange(_limitedVideos.length, limit).toList());
      await Future.delayed(Duration(milliseconds: 500));
    }
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  void _getDataLabel() {
    if (_isGetDataLabel) {
      _labelNew.getDataLabel(Dictionary.labelVideos).then((value) {
        if (!mounted) return;
        setState(() {
          _dataLabel = value;
        });
      });
      _isGetDataLabel = false;
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        if (mounted) {
          setState(() {
            _searchQuery = _searchController.text;
          });
        }
      } else {
        _clearSearchQuery();
      }
    });

    AnalyticsHelper.analyticSearch(
        searchController: _searchController,
        event: Analytics.tappedSearchVideo);
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      _updateSearchQuery(null);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
