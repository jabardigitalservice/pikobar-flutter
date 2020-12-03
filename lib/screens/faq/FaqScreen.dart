import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Connection.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class FaqScreen extends StatefulWidget {
  final bool isNewPage;

  FaqScreen({this.isNewPage = true});

  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Timer _debounce;
  bool isConnected = false;
  bool _isSearch = false;
  final containerWidth = 40.0;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.faq);

    _searchController.addListener((() {
      _onSearchChanged();
    }));
    checkConnection();
    super.initState();
  }

  checkConnection() async {
    isConnected = await Connection().checkConnection(kUrlGoogle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.bottomSearchAppBar(
          searchController: _searchController,
          title: Dictionary.faq,
          hintText: Dictionary.findFaq,
          onChanged: updateSearchQuery),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(kFaq)
            .orderBy('sequence_number')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List dataFaq;

            // if search active
            if (searchQuery.isNotEmpty) {
              dataFaq = snapshot.data.docs
                  .where((test) => test['title']
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))
                  .toList();
            } else {
              dataFaq = snapshot.data.docs;
            }

            final int messageCount = dataFaq.length;

            // check if data is empty
            if (dataFaq.length == 0) {
              if (isConnected) {
                return EmptyData(
                    message: '${Dictionary.emptyData} ${Dictionary.faq}');
              } else {
                return EmptyData(message: Dictionary.errorConnection);
              }
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
      itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              ListTile(
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
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                color: Colors.grey[300],
                height: 1,
              )
            ],
          )),
    );
  }

  Widget _cardContent(dataHelp) {
    return Container(
      color:Colors.white,
      child: Column(
        children: <Widget>[
          ExpandableNotifier(
            child: ScrollOnExpand(
              scrollOnExpand: false,
              scrollOnCollapse: true,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    expanded: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Html(
                        data: dataHelp['content'].replaceAll('\n', '</br>'),
                        style: {
                          'body': Style(
                              margin: EdgeInsets.zero,
                              color: Colors.grey[600],
                              fontSize: FontSize(14.0),
                              textAlign: TextAlign.start),
                          'li': Style(
                            margin: EdgeInsets.only(bottom: 10.0)
                          )
                        },
                        onLinkTap: (url) {
                          launchExternal(url);
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
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            color: Colors.grey[300],
            height: 1,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
