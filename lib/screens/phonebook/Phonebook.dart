import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/phonebook/ListViewPhoneBooks.dart';

class Phonebook extends StatefulWidget {
  @override
  _PhonebookState createState() => _PhonebookState();
}

class _PhonebookState extends State<Phonebook> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  bool _isSearch = false;
  AnimationController _animationController;
  bool _hasChange = false;
  var containerWidth = 40.0;
  final _nodeOne = FocusNode();
  final _searchController = TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
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
          stream:
              Firestore.instance.collection('emergency_numbers').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return ErrorContent(error: snapshot.error);
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: _buildLoading());
              default:
                return snapshot.data.documents.isEmpty
                    ? EmptyData(message: Dictionary.emptyDataPhoneBook)
                    : ListViewPhoneBooks(
                        snapshot: snapshot,
                        scrollController: _scrollController,
                        // maxDataLength: maxDatalength,
                      );
            }
          },
          // )
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(title: _titleBar(), actions: <Widget>[
      // action button
      // Visibility(
      //   visible: !_isSearch,
      //   child: IconButton(
      //       icon: Icon(Icons.map),
      //       onPressed: () {
      //         // _openMaps();
      //       }),
      // ),

      // RotationTransition(
      //   turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
      //   child: IconButton(
      //     icon: _isSearch ? Icon(Icons.close) : Icon(Icons.search),
      //     onPressed: () {
      //       _searchPressed();
      //     },
      //   ),
      // ),
      // action button
    ]);
  }

  void _searchPressed() {
    return setState(() {
      _isSearch = !_isSearch;
      _animationController.forward(from: 0.0);
      _showSearch();
    });
  }

  void _showSearch() {
    if (!_isSearch) {
      if (_hasChange) {
        _hasChange = false;
        // _refresh();
      }
      containerWidth = 50.0;
      FocusScope.of(context).unfocus();
    } else {
      containerWidth = MediaQuery.of(context).size.width;
      FocusScope.of(context).requestFocus(_nodeOne);
    }
    _searchController.clear();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        _hasChange = true;
        //  snaps
      }
    });
  }

  Widget _titleBar() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedOpacity(
            opacity: _isSearch ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: containerWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                focusNode: _nodeOne,
                textInputAction: TextInputAction.go,
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0)),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 13,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Visibility(
              visible: !_isSearch,
              child: Text(Dictionary.phoneBookEmergency),
            ),
          ),
        ),
      ],
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
}
