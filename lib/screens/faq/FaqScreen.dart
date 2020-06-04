import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer _debounce;

  bool _isSearch = false;
  final containerWidth = 40.0;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.faq);

    _searchController.addListener((() {
      _onSearchChanged();
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          title: _isSearch ? _buildSearchField() : CustomAppBar.setTitleAppBar(Dictionary.faq),
          actions: _buildActions()),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Collections.faq)
            .orderBy('sequence_number')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List dataFaq;

            // if search active
            if (searchQuery.isNotEmpty) {
              dataFaq = snapshot.data.documents
                  .where((test) => test['title']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();
            } else {
              dataFaq = snapshot.data.documents;
            }

            final int messageCount = dataFaq.length;

            // check if data is empty
            if (dataFaq.length == 0) {
              return EmptyData(
                  message: '${Dictionary.emptyData} ${Dictionary.faq}');
            }

            return ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.only(bottom: 30.0),
              itemBuilder: (_, int index) {
                return _cardContent(dataFaq[index]);
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
          color: Colors.grey[100],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0)),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
            hintText: Dictionary.findFaq,
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

    AnalyticsHelper.setLogEvent(Analytics.tappedFaqSearch);
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
      updateSearchQuery('');
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
                  onLinkTap: (url) {
                    launchExternal(url);
                  },
                  customTextAlign: (dom.Node node) {
                    return TextAlign.left;
                  },
                ),
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
