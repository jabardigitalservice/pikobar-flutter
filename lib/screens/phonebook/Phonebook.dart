import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/screens/phonebook/ListViewPhoneBooks.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class Phonebook extends StatefulWidget {
  @override
  _PhonebookState createState() => _PhonebookState();
}

class _PhonebookState extends State<Phonebook> {
  bool _isSearch = false;
  var containerWidth = 40.0;
  TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  String searchQuery;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.phoneBookEmergency);

    _searchController.addListener((() {
      _onSearchChanged();
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar.animatedAppBar(
            showTitle: false, title: Dictionary.phoneBookEmergency),
        // CustomAppBar.bottomSearchAppBar(
        //     searchController: _searchController,
        //     title: Dictionary.phoneBookEmergency,
        //     hintText: Dictionary.findEmergencyPhone,
        //     onChanged: updateSearchQuery),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(),
            Expanded(
              child: ListViewPhoneBooks(
                searchQuery: searchQuery,
              ),
            ),
          ],
        ));
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            Dictionary.phoneBookEmergency,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 20.0,
                fontWeight: FontWeight.w900),
          ),
        ),
        CustomAppBar.buildSearchField(
            _searchController, Dictionary.findEmergencyPhone, updateSearchQuery)
      ],
    );
  }

  List<Widget> _buildActions() {
    if (_isSearch) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null || _searchController.text.isEmpty) {
              _stopSearching();
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    setState(() {
      _isSearch = true;
    });

    AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergencySearch);
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

  void _clearSearchQuery() {
    setState(() {
      _searchController.clear();
      updateSearchQuery(null);
    });
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
