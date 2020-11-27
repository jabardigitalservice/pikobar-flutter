import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class InfoGraphicsScreen extends StatefulWidget {
  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  InfoGraphicsListBloc _infoGraphicsListBloc = InfoGraphicsListBloc();
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController;
  Timer _debounce;
  String searchQuery;

  List<String> listItemTitleTab = [
    Dictionary.titleLatestNews,
    Dictionary.center,
    Dictionary.who,
  ];

  List<String> listCollectionData = [
    kInfographics,
    kInfographicsCenter,
    kInfographicsWho,
  ];

  List<String> analyticsData = [
    Analytics.tappedInfographicJabar,
    Analytics.tappedInfographicCenter,
    Analytics.tappedInfographicWho,
  ];

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.infoGraphics);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider<InfoGraphicsListBloc>(
          create: (context) => _infoGraphicsListBloc
            ..add(InfoGraphicsListLoad(infoGraphicsCollection: kInfographics)),
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
        searchBar: CustomAppBar.buildSearchField(
            _searchController, Dictionary.searchInformation, updateSearchQuery),
        unselectedLabelColor: Colors.grey,
        scrollController: _scrollController,
        onTap: (index) {
          setState(() {});
          _infoGraphicsListBloc.add(InfoGraphicsListLoad(
              infoGraphicsCollection: listCollectionData[index]));
          AnalyticsHelper.setLogEvent(analyticsData[index]);
        },
        tabBarView: <Widget>[
          _buildInfoGraphic(),
          _buildInfoGraphic(),
          _buildInfoGraphic(),
        ],
        heightTabBarView: MediaQuery.of(context).size.height - 148,
      )),
    ));
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

  Widget _buildContent(List<DocumentSnapshot> listData) {
    if (searchQuery != null) {
      listData = listData
          .where((test) =>
              test['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return listData.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: listData.length,
            padding: EdgeInsets.only(bottom: 20.0),
            itemBuilder: (_, int index) {
              return _cardContent(listData[index]);
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

  Widget _cardContent(DocumentSnapshot data) {
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            elevation: 0,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: data['images'][0] ?? '',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                heightFactor: 4.2,
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                color: Colors.grey[200],
                                child: Image.asset(
                                    '${Environment.iconAssets}pikobar.png',
                                    fit: BoxFit.fitWidth)),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.2),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.circular(Dimens.dialogRadius),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 0,
                        top: 215,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              unixTimeStampToDateTime(
                                  data['published_date'].seconds),
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              data['title'],
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailInfoGraphicScreen(dataInfoGraphic: data)));

              AnalyticsHelper.setLogEvent(Analytics.tappedInfoGraphicsDetail,
                  <String, dynamic>{'title': data['title']});
            },
          ),
        ),
      ],
    ));
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
