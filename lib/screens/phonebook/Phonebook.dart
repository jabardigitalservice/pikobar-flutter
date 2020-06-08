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
    return Scaffold(backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: ListViewPhoneBooks(
          searchQuery: searchQuery,
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,bottom:  PreferredSize(
            preferredSize:  Size.fromHeight(60.0),
            child: _buildSearchField(),
          ),
        
        title:  CustomAppBar.setTitleAppBar(Dictionary.phoneBookEmergency));
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

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0,bottom: 20),
      height: 40.0,
      decoration: BoxDecoration(
          color: Color(0xffFAFAFA),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0)),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        decoration: InputDecoration(prefixIcon: Icon(Icons.search,color: Color(0xff828282),),
            hintText: Dictionary.findEmergencyPhone,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Color(0xff828282),fontFamily: FontsFamily.lato),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0)),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
