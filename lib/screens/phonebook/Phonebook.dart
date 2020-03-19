import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/phonebook/ListViewPhoneBooks.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class Phonebook extends StatefulWidget {
  @override
  _PhonebookState createState() => _PhonebookState();
}

class _PhonebookState extends State<Phonebook> {
  ScrollController _scrollController = ScrollController();
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
        appBar: _buildAppBar(),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(Collections.emergencyNumbers)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.documents.isEmpty
                  ? EmptyData(message: Dictionary.emptyDataPhoneBook)
                  : ListViewPhoneBooks(
                      snapshot: snapshot,
                      scrollController: _scrollController,
                      searchQuery: searchQuery,
                    );
            } else {
              return Center(child: _buildLoading());
            }
          },
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: _isSearch
            ? _buildSearchField()
            : Text(Dictionary.phoneBookEmergency),
        actions: _buildActions());
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
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      height: 40.0,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0)),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: Dictionary.findEmergencyPhone,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0)),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery,
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
        itemCount: 10,
        padding: EdgeInsets.all(6),
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Skeleton(
                child: Icon(FontAwesomeIcons.building),
              ),
              title: Skeleton(
                width: MediaQuery.of(context).size.width / 4,
                height: 20,
              ),
            ),
          ));
        });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
