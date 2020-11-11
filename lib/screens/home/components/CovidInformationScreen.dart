import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/home/components/Documents.dart';
import 'package:pikobar_flutter/screens/home/components/InfoGraphics.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/screens/home/components/VideoList.dart';

class CovidInformationScreen extends StatefulWidget {
  @override
  _CovidInformationScreenState createState() => _CovidInformationScreenState();
}

class _CovidInformationScreenState extends State<CovidInformationScreen> {
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  String searchQuery;
  bool _isSearch = false;

  @override
  void initState() {
    _searchController.addListener((() {
      _onSearchChanged();
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomAppBar.buildSearchField(
            _searchController, Dictionary.searchInformation, updateSearchQuery),
        Container(
          child: InfoGraphics(searchQuery: searchQuery),
        ),
        Container(
          child: NewsScreen(
              news: Dictionary.allNews, maxLength: 5, searchQuery: searchQuery),
        ),
        Container(
          child: VideoList(searchQuery: searchQuery),
        ),
        Container(
          child: Documents(searchQuery: searchQuery),
        ),
        Container(
          child: SocialMedia(),
        )
      ],
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
  }

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery(null);
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearch = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
