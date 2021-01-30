import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/screens/phonebook/ListViewPhoneBooks.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class Phonebook extends StatefulWidget {
  Phonebook({Key key}) : super(key: key);

  @override
  _PhonebookState createState() => _PhonebookState();
}

class _PhonebookState extends State<Phonebook> {
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
    return ListViewPhoneBooks(
      searchQuery: searchQuery,
      searchController: _searchController,
      onChanged: updateSearchQuery,
    );
    // Scaffold(
    //   backgroundColor: Colors.white,
    // appBar: CustomAppBar.animatedAppBar(
    //     showTitle: false, title: Dictionary.phoneBookEmergency),
    // CustomAppBar.bottomSearchAppBar(
    //     searchController: _searchController,
    //     title: Dictionary.phoneBookEmergency,
    //     hintText: Dictionary.findEmergencyPhone,
    //     onChanged: updateSearchQuery),
    // body:
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     buildHeader(),
    //     Expanded(
    //       child: ListViewPhoneBooks(
    //         searchQuery: searchQuery,
    //         searchController: _searchController,
    //         onChanged: updateSearchQuery,
    //       ),
    //     ),
    //   ],
    // )
    // );
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

  void updateSearchQuery(String newQuery) {
    AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergencySearch);
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
