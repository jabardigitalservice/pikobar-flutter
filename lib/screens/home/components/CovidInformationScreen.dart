import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/Documents.dart';
import 'package:pikobar_flutter/screens/home/components/HomeScreen.dart';
import 'package:pikobar_flutter/screens/home/components/InfoGraphics.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

class CovidInformationScreen extends StatefulWidget {
  final HomeScreenState homeScreenState;

  const CovidInformationScreen({Key key, this.homeScreenState}) : super(key: key);

  @override
  CovidInformationScreenState createState() => CovidInformationScreenState();
}

class CovidInformationScreenState extends State<CovidInformationScreen> {
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  String searchQuery;
  bool isEmptyDataInfoGraphic = false;
  bool isEmptyDataNews = false;
  bool isEmptyDataVideoList = false;
  bool isEmptyDataDocument = false;

  @override
  void initState() {
    _searchController.addListener((() {
      _onSearchChanged();
    }));

    getAllUnreadData();

    super.initState();
  }

  bool getIsEmptyData() {
    return isEmptyDataDocument &&
        isEmptyDataInfoGraphic &&
        isEmptyDataNews &&
        isEmptyDataVideoList;
  }

  Future<void> getAllUnreadData() async {
    widget.homeScreenState.totalUnreadInfo =
        await LabelNew().getAllUnreadDataLabel();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: Dimens.sizedBoxHeight),
        CustomAppBar.buildSearchField(context,
            _searchController, Dictionary.searchInformation, updateSearchQuery,
            margin: EdgeInsets.symmetric(horizontal: Dimens.padding)),
        SizedBox(height: Dimens.verticalPadding * 1.5),
        !getIsEmptyData()
            ? Column(
                children: [
                  InfoGraphics(
                      searchQuery: searchQuery,
                      covidInformationScreenState: this),
                  NewsScreen(
                      news: Dictionary.allNews,
                      maxLength: 5,
                      searchQuery: searchQuery,
                      covidInformationScreenState: this),
                  VideoList(
                      searchQuery: searchQuery,
                      covidInformationScreenState: this),
                  Documents(
                      searchQuery: searchQuery,
                      covidInformationScreenState: this),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: SocialMedia(),
                  )
                ],
              )
            : EmptyData(
                message: Dictionary.emptyData,
                desc: Dictionary.descEmptyData,
                isFlare: false,
                image: "${Environment.imageAssets}not_found.png",
              ),
      ],
    );
  }

  void _onSearchChanged() {
    if (getIsEmptyData()) {
      resetEmptyData();
    }

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

    AnalyticsHelper.analyticSearch(searchController: _searchController, event: Analytics.tappedSearchCovidInformation);
  }

  void _clearSearchQuery() {
    setState(() {
      resetEmptyData();
      _searchController.clear();
      updateSearchQuery(null);
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void resetEmptyData() {
    isEmptyDataInfoGraphic = false;
    isEmptyDataNews = false;
    isEmptyDataVideoList = false;
    isEmptyDataDocument = false;
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
