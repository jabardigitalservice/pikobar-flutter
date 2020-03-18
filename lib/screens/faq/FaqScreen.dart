import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery;
  Timer _debounce;

  bool _isSearch = false;
  final containerWidth = 40.0;

  @override
  void initState() {
    _searchController.addListener((() {
      _onSearchChanged();
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: _isSearch ? _buildSearchField() : Text(Dictionary.faq),
          actions: _buildActions()),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(Collections.faq).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final int messageCount = snapshot.data.documents.length;
            return ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.only(bottom: 30.0),
              itemBuilder: (_, int index) {
                if (searchQuery != null) {
                  if (snapshot.data.documents[index]['title']
                      .toLowerCase()
                      .contains(searchQuery)) {
                    return _cardContent(snapshot.data.documents[index]);
                  }
                } else {
                  return _cardContent(snapshot.data.documents[index]);
                }
              },
            );
          } else {
            return _buildLoading();
          }
        },
      ),
    );
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
            hintText: "Cari FAQ",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.black54),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0)),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: (query) => updateSearchQuery,
      ),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearch) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null || _searchController.text.isEmpty) {
              Navigator.pop(context);
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
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

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
        print(_searchController.text);
        setState(() {
          searchQuery = _searchController.text;
        });
      } else {
        _clearSearchQuery();
      }
    });
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: ListTile(
          title: Skeleton(
            width: MediaQuery.of(context).size.width - 140,
            height: 20.0,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Skeleton(
              width: MediaQuery.of(context).size.width - 190,
              height: 20.0,
            ),
          ),
          trailing: Skeleton(
            width: 20.0,
            height: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _cardContent(dataHelp) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        scrollOnExpand: false,
        scrollOnCollapse: true,
        child: Card(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          clipBehavior: Clip.antiAlias,
          child: ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              tapHeaderToExpand: true,
              tapBodyToCollapse: true,
              headerAlignment: ExpandablePanelHeaderAlignment.center,
              header: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  dataHelp['title'],
                  style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                ),
              ),
              expanded: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Html(
                    data: dataHelp['content'].replaceAll('\n', '</br>'),
                    defaultTextStyle:
                        TextStyle(color: Colors.black, fontSize: 14.0),
                    customTextAlign: (dom.Node node) {
                      return TextAlign.justify;
                    }),
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    crossFadePoint: 0,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
