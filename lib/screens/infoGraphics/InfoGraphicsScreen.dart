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

  final List<String> listItemTitleTab = [
    Dictionary.all,
    Dictionary.titleLatestNews,
    Dictionary.center,
    Dictionary.who,
  ];

  final List<String> listCollectionData = [
    kAllInfographics,
    kInfographics,
    kInfographicsCenter,
    kInfographicsWho,
  ];

  final List<String> analyticsData = [
    Analytics.tappedInfographicall,
    Analytics.tappedInfographicJabar,
    Analytics.tappedInfographicCenter,
    Analytics.tappedInfographicWho,
  ];

  ScrollController _scrollController;
  Timer _debounce;
  String searchQuery;
  bool isGetDataLabel = true;
  LabelNew labelNew;
  List<LabelNewModel> dataLabel = [];

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.infoGraphics);
    labelNew = LabelNew();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.8);
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelInfoGraphic).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      onWillPop: _onWillPop,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InfoGraphicsListBloc>(
            create: (context) => _infoGraphicsListBloc
              ..add(InfoGraphicsListLoad(
                  infoGraphicsCollection: kAllInfographics)),
          ),
        ],
        child: Container(
            child: CustomBubbleTab(
          isStickyHeader: true,
          titleHeader: Dictionary.infoGraphics,
          listItemTitleTab: listItemTitleTab,
          indicatorColor: ColorBase.green,
          labelColor: Colors.white,
          showTitle: _showTitle,
          isScrollable: false,
          searchBar: CustomAppBar.buildSearchField(_searchController,
              Dictionary.searchInformation, updateSearchQuery,
              margin: const EdgeInsets.only(
                  left: Dimens.contentPadding,
                  right: Dimens.contentPadding,
                  bottom: 20.0)),
          unselectedLabelColor: Colors.grey,
          scrollController: _scrollController,
          onTap: (index) {
            setState(() {});
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
            if (index == 0) {
              _infoGraphicsListBloc.add(InfoGraphicsListLoad(
                  infoGraphicsCollection: listCollectionData[index]));
              AnalyticsHelper.setLogEvent(analyticsData[index]);
            } else if (index == 1) {
              _infoGraphicsListBloc.add(InfoGraphicsListJabarLoad(
                  infoGraphicsCollection: listCollectionData[index]));
              AnalyticsHelper.setLogEvent(analyticsData[index]);
            } else if (index == 2) {
              _infoGraphicsListBloc.add(InfoGraphicsListPusatLoad(
                  infoGraphicsCollection: listCollectionData[index]));
              AnalyticsHelper.setLogEvent(analyticsData[index]);
            } else if (index == 3) {
              _infoGraphicsListBloc.add(InfoGraphicsListWHOLoad(
                  infoGraphicsCollection: listCollectionData[index]));
              AnalyticsHelper.setLogEvent(analyticsData[index]);
            }
          },
          tabBarView: <Widget>[
            _buildInfoGraphic(),
            _buildInfoGraphicJabar(),
            _buildInfoGraphicPusat(),
            _buildInfoGraphicWHO(),
          ],
          heightTabBarView: MediaQuery.of(context).size.height - 148,
        )),
      ),
    ));
  }

  Future<bool> _onWillPop() {
    Navigator.pop(context, true);
    return Future.value();
  }

  Widget _buildInfoGraphic() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListLoaded
            ? _buildContent(state.infoGraphicsList)
            : _buildLoading();
      },
    );
  }

  Widget _buildInfoGraphicJabar() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListJabarLoaded
            ? _buildContent(state.infoGraphicsListJabar)
            : _buildLoading();
      },
    );
  }

  Widget _buildInfoGraphicPusat() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListPusatLoaded
            ? _buildContent(state.infoGraphicsListPusat)
            : _buildLoading();
      },
    );
  }

  Widget _buildInfoGraphicWHO() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListWHOLoaded
            ? _buildContent(state.infoGraphicsListWHO)
            : _buildLoading();
      },
    );
  }

  Widget _buildContent(List<DocumentSnapshot> listData) {
    if (searchQuery != null) {
      listData = listData
          .where((test) =>
              test['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    getDataLabel();

    return listData.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: listData.length,
            padding: const EdgeInsets.only(bottom: 20.0),
            itemBuilder: (_, int index) {
              return _cardContent(listData[index], index);
            },
          )
        : ListView(
            children: [
              EmptyData(
                message: Dictionary.emptyData,
                desc: Dictionary.descEmptyData,
                isFlare: false,
                image: "${Environment.imageAssets}not_found.png",
              )
            ],
          );
  }

  _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
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
                      labelNew.isLabelNew(data.id.toString(), dataLabel)
                          ? LabelNewScreen()
                          : Container(),
                      Expanded(
                        child: Text(
                          unixTimeStampToDateTime(
                              data['published_date'].seconds),
                          style: TextStyle(
                              fontSize: 16.0,
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
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: FontsFamily.roboto),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.5),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Dimens.dialogRadius),
                ),
                child: Text(
                  '1/${data['images'].length}',
                  style: TextStyle(
                      fontSize: 14.0,
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
          labelNew.readNewInfo(
              data.id,
              data['published_date'].seconds.toString(),
              dataLabel,
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        setState(() {
          searchQuery = _searchController.text;
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
