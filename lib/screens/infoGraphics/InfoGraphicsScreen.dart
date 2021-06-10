import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/infographicslist/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

class InfoGraphicsScreen extends StatefulWidget {
  final CovidInformationScreenState covidInformationScreenState;

  const InfoGraphicsScreen({Key key, this.covidInformationScreenState})
      : super(key: key);

  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  final InfoGraphicsListBloc _infoGraphicsListBloc = InfoGraphicsListBloc();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _listItemTitleTab = [
    Dictionary.all,
    Dictionary.titleLatestNews,
    Dictionary.center,
    Dictionary.who,
  ];

  final List<String> _listCollectionData = [
    kAllInfographics,
    kInfographics,
    kInfographicsCenter,
    kInfographicsWho,
  ];

  final List<String> _analyticsData = [
    Analytics.tappedInfographicall,
    Analytics.tappedInfographicJabar,
    Analytics.tappedInfographicCenter,
    Analytics.tappedInfographicWho,
  ];

  final int _limitMax = 500;
  final int _limitPerPage = 10;
  final int _limitPerSearch = 25;

  List<DocumentSnapshot> _allDocs = [];
  List<DocumentSnapshot> _limitedDocs = [];
  List<LabelNewModel> _dataLabel = [];

  bool _isGetDataLabel = true;
  LabelNew _labelNew = LabelNew();
  Timer _debounce;
  String _searchQuery;


  @override
  void dispose() {
    _infoGraphicsListBloc.close();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.infoGraphics);
    _scrollController.addListener(() => setState(() {}));
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoGraphicsListBloc>(
      create: (context) => _infoGraphicsListBloc
        ..add(InfoGraphicsListLoad(
            infoGraphicsCollection: kAllInfographics, limit: _limitMax)),
      child: BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
        listener: (context, state) {
          if (state is InfoGraphicsListLoaded) {
            _allDocs = state.infoGraphicsList;
          } else if (state is InfoGraphicsListJabarLoaded) {
            _allDocs = state.infoGraphicsListJabar;
          } else if (state is InfoGraphicsListPusatLoaded) {
            _allDocs = state.infoGraphicsListPusat;
          } else if (state is InfoGraphicsListWHOLoaded) {
            _allDocs = state.infoGraphicsListWHO;
          }

          if (state is! InitialInfoGraphicsListState && state is! InfoGraphicsListLoading) {
            int limit = _allDocs.length > _limitPerPage ? _limitPerPage : _allDocs.length;
            _limitedDocs = _allDocs.getRange(0, limit).toList();
            _getDataLabel();
          }
        },
        child: _buildMain(),
      ),
    );
  }

  Widget _buildMain() {
    return CustomBubbleTab(
      isStickyHeader: true,
      titleHeader: Dictionary.infoGraphics,
      listItemTitleTab: _listItemTitleTab,
      indicatorColor: ColorBase.green,
      labelColor: Colors.white,
      showTitle: _showTitle,
      isScrollable: false,
      unselectedLabelColor: Colors.grey,
      scrollController: _scrollController,
      heightTabBarView: MediaQuery.of(context).size.height - 148,
      onWillPop: () {
        Navigator.pop(context, true);
        return Future.value();
      },
      searchBar: CustomAppBar.buildSearchField(context, _searchController,
          Dictionary.searchInformation, updateSearchQuery,
          margin: const EdgeInsets.only(
              left: Dimens.contentPadding,
              right: Dimens.contentPadding,
              bottom: Dimens.contentPadding)),
      onTap: (index) {
        setState(() {});
        _scrollController.jumpTo(_scrollController.position.minScrollExtent);

        switch (index) {
          case 1:
            _infoGraphicsListBloc.add(InfoGraphicsListJabarLoad(
                infoGraphicsCollection: _listCollectionData[index],
                limit: _limitMax));
            AnalyticsHelper.setLogEvent(_analyticsData[index]);
            break;
          case 2:
            _infoGraphicsListBloc.add(InfoGraphicsListPusatLoad(
                infoGraphicsCollection: _listCollectionData[index],
                limit: _limitMax));
            AnalyticsHelper.setLogEvent(_analyticsData[index]);
            break;
          case 3:
            _infoGraphicsListBloc.add(InfoGraphicsListWHOLoad(
                infoGraphicsCollection: _listCollectionData[index],
                limit: _limitMax));
            AnalyticsHelper.setLogEvent(_analyticsData[index]);
            break;
          default:
            _infoGraphicsListBloc.add(InfoGraphicsListLoad(
                infoGraphicsCollection: _listCollectionData[index],
                limit: _limitMax));
            AnalyticsHelper.setLogEvent(_analyticsData[index]);
        }
      },
      tabBarView: <Widget>[
        _buildInfoGraphic(),
        _buildInfoGraphicJabar(),
        _buildInfoGraphicPusat(),
        _buildInfoGraphicWHO(),
      ],
    );
  }

  Widget _buildInfoGraphic() {
    return BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
      listener: (context, state) {
        if (state is! InitialInfoGraphicsListState &&
            state is! InfoGraphicsListLoading) {
          _listenInnerScroll(context);
        }
      },
      child: BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
          builder: (context, state) {
        return SafeArea(
            top: false,
            bottom: false,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                SliverToBoxAdapter(
                  child: state is InfoGraphicsListLoaded
                      ? _buildContent(_limitedDocs)
                      : _buildLoading(),
                )
              ],
            ));
      }),
    );
  }

  Widget _buildInfoGraphicJabar() {
    return BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
      listener: (context, state) {
        if (state is! InitialInfoGraphicsListState &&
            state is! InfoGraphicsListLoading) {
          _listenInnerScroll(context);
        }
      },
      child: BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
          builder: (context, state) {
            return SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: state is InfoGraphicsListJabarLoaded
                          ? _buildContent(_limitedDocs)
                          : _buildLoading(),
                    )
                  ],
                ));
          }),
    );
  }

  Widget _buildInfoGraphicPusat() {
    return BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
      listener: (context, state) {
        if (state is! InitialInfoGraphicsListState &&
            state is! InfoGraphicsListLoading) {
          _listenInnerScroll(context);
        }
      },
      child: BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
          builder: (context, state) {
            return SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: state is InfoGraphicsListPusatLoaded
                          ? _buildContent(_limitedDocs)
                          : _buildLoading(),
                    )
                  ],
                ));
          }),
    );
  }

  Widget _buildInfoGraphicWHO() {
    return BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
      listener: (context, state) {
        if (state is! InitialInfoGraphicsListState &&
            state is! InfoGraphicsListLoading) {
          _listenInnerScroll(context);
        }
      },
      child: BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
          builder: (context, state) {
            return SafeArea(
                top: false,
                bottom: false,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    ),
                    SliverToBoxAdapter(
                      child: state is InfoGraphicsListWHOLoaded
                          ? _buildContent(_limitedDocs)
                          : _buildLoading(),
                    )
                  ],
                ));
          }),
    );
  }

  Widget _buildContent(List<DocumentSnapshot> listData) {

    if (_searchQuery != null) {
      listData = listData
          .where((test) =>
              test['title'].toLowerCase().contains(_searchQuery.toLowerCase()))
          .take(_limitPerSearch)
          .toList();
    }

    int itemCount = _searchQuery == null && listData.length != _allDocs.length ? listData.length + 1 : listData.length;

    return listData.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            padding: const EdgeInsets.only(bottom: Dimens.contentPadding),
            itemBuilder: (_, int index) {
              if (index == listData.length) {
                return Padding(
                  padding: const EdgeInsets.all(Dimens.padding),
                  child: CupertinoActivityIndicator(),
                );
              }

              return _cardContent(listData[index], index);
            },
          )
        : EmptyData(
            message: Dictionary.emptyData,
            desc: Dictionary.descEmptyData,
            isFlare: false,
            image: "${Environment.imageAssets}not_found.png",
          );
  }

  Widget _buildLoading() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        padding: const EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(bottom: Dimens.contentPadding, left: 10, right: 10),
            height: 300,
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

  Widget _cardContent(DocumentSnapshot data, int indexListData) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: Dimens.contentPadding),
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width - 35,
                height: 300,
                child: CachedNetworkImage(
                    imageUrl: data['images'][0].toString() ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.borderRadius),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: const CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                        ),
                        child: PikobarPlaceholder()))),
            Container(
              width: MediaQuery.of(context).size.width - 35,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      _labelNew.isLabelNew(data.id.toString(), _dataLabel)
                          ? LabelNewScreen()
                          : Container(),
                      Expanded(
                        child: Text(
                          unixTimeStampToDateTime(
                              data['published_date'].seconds),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: FontsFamily.roboto),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    data['title'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: FontsFamily.roboto),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: Dimens.sizedBoxHeight,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.5),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Dimens.dialogRadius),
                ),
                child: Text(
                  '1/${data['images'].length}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: FontsFamily.roboto),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _labelNew.readNewInfo(
              data.id,
              data['published_date'].seconds.toString(),
              _dataLabel,
              Dictionary.labelInfoGraphic);
          if (widget.covidInformationScreenState != null) {
            widget.covidInformationScreenState.widget.homeScreenState
                .getAllUnreadData();
          }
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                DetailInfoGraphicScreen(dataInfoGraphic: data)));

        AnalyticsHelper.setLogEvent(Analytics.tappedInfoGraphicsDetail,
            <String, dynamic>{'title': data['title']});
      },
    );
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  void _getDataLabel() {
    if (_isGetDataLabel) {
      _labelNew.getDataLabel(Dictionary.labelInfoGraphic).then((value) {
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
        setState(() {
          _searchQuery = _searchController.text;
        });
      } else {
        _clearSearchQuery();
      }
    });

    AnalyticsHelper.analyticSearch(
        searchController: _searchController,
        event: Analytics.tappedSearchInfoGraphic);
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery(null);
    });
  }

  void _listenInnerScroll(BuildContext context) {
    final innerScrollController = PrimaryScrollController.of(context);

    // ignore: invalid_use_of_protected_member
    if (!innerScrollController.hasListeners) {
      innerScrollController.addListener(() async {
        if (innerScrollController.offset >=
                innerScrollController.position.maxScrollExtent &&
            !innerScrollController.position.outOfRange) {
          await _getMoreData();
        }
      });
    }
  }

  Future<void> _getMoreData() async {
    if (_searchQuery == null) {
      final nextPage = _limitedDocs.length + _limitPerPage;
      final limit = _allDocs.length > nextPage ? nextPage : _limitedDocs.length;

      _limitedDocs.addAll(_allDocs
          .getRange(_limitedDocs.length, limit)
          .toList());
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {});
    }
  }
}
