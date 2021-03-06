import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
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

// ignore: must_be_immutable
class InfoGraphicsScreen extends StatefulWidget {
  CovidInformationScreenState covidInformationScreenState;

  InfoGraphicsScreen({Key key, this.covidInformationScreenState})
      : super(key: key);

  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  InfoGraphicsListBloc _infoGraphicsListBloc = InfoGraphicsListBloc();
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController;
  Timer _debounce;
  String searchQuery;
  List<int> _current = [];
  bool isSetDataCurrent = false;
  bool isGetDataLabel = true;
  LabelNew labelNew;
  List<LabelNewModel> dataLabel = [];

  List<String> listItemTitleTab = [
    Dictionary.all,
    Dictionary.titleLatestNews,
    Dictionary.center,
    Dictionary.who,
  ];

  List<String> listCollectionData = [
    kAllInfographics,
    kInfographics,
    kInfographicsCenter,
    kInfographicsWho,
  ];

  List<String> analyticsData = [
    Analytics.tappedInfographicall,
    Analytics.tappedInfographicJabar,
    Analytics.tappedInfographicCenter,
    Analytics.tappedInfographicWho,
  ];

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
          sizeLabel: 13.0,
          isScrollable: false,
          searchBar: CustomAppBar.buildSearchField(_searchController,
              Dictionary.searchInformation, updateSearchQuery,
              margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0)),
          unselectedLabelColor: Colors.grey,
          scrollController: _scrollController,
          onTap: (index) {
            setState(() {});
            isSetDataCurrent = false;
            _infoGraphicsListBloc.add(InfoGraphicsListLoad(
                infoGraphicsCollection: listCollectionData[index]));
            AnalyticsHelper.setLogEvent(analyticsData[index]);
          },
          tabBarView: <Widget>[
            _buildInfoGraphic(),
            _buildInfoGraphic(),
            _buildInfoGraphic(),
            _buildInfoGraphic(),
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

  Widget _buildContent(List<DocumentSnapshot> listData) {
    if (searchQuery != null) {
      listData = listData
          .where((test) =>
              test['title'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    if (!isSetDataCurrent) {
      _current.clear();
      listData.forEach((element) {
        _current.add(0);
      });
      isSetDataCurrent = true;
    }

    getDataLabel();

    return listData.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: listData.length,
            padding: EdgeInsets.only(bottom: 20.0),
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

  Widget _cardContent(DocumentSnapshot data, int indexListData) {
    var dataListImage =
        (data['images'] as List)?.map((item) => item as String)?.toList();
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
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
                        child: CarouselSlider(
                          options: CarouselOptions(
                            initialPage: 0,
                            enableInfiniteScroll:
                                dataListImage.length > 1 ? true : false,
                            aspectRatio: 9 / 9,
                            viewportFraction: 1.0,
                            autoPlay: dataListImage.length > 1 ? true : false,
                            autoPlayInterval: Duration(seconds: 5),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current[indexListData] = index;
                              });
                            },
                          ),
                          items: dataListImage.map((dynamic data) {
                            return Builder(builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                      Dimens.dialogRadius),
                                ),
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                      imageUrl: data.toString() ?? '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      placeholder: (context, url) => Center(
                                          heightFactor: 10.2,
                                          child: CupertinoActivityIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    topRight:
                                                        Radius.circular(5.0)),
                                              ),
                                              child: PikobarPlaceholder())),
                                ),
                              );
                            });
                          }).toList(),
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
                        top: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                labelNew.isLabelNew(
                                        data.id.toString(), dataLabel)
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
                            SizedBox(
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0.0),
                              child: Row(
                                children: dataListImage.map((String data) {
                                  int index = dataListImage.indexOf(data);
                                  return _current[indexListData] == index
                                      ? Expanded(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  dataListImage.length,
                                              height: 6.0,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 2.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  color: Colors.white)),
                                        )
                                      : Expanded(
                                          child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              dataListImage.length,
                                          height: 6.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.4)),
                                        ));
                                }).toList(),
                              ),
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
        AnalyticsHelper.setLogEvent(Analytics.tappedSearchInfoGraphic);
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
