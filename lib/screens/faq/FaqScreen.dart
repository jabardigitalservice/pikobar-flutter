import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  AnimationController _animationController;
  final _searchController = TextEditingController();
  Timer _debounce;

  bool _isSearch = false;
  final containerWidth = 40.0;

  final _nodeOne = FocusNode();

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
      appBar: AppBar(title: Text(Dictionary.faq), actions: [
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('masuk');
              // Navigator.of(context).push(PageTransition(
              //     child: ImportantInfoSearchScreen(),
              //     type: PageTransitionType.fade));
            }),
      ]),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(Collections.faq).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final int messageCount = snapshot.data.documents.length;
            return ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.only(bottom: 30.0),
              itemBuilder: (_, int index) {
                return _cardContent(snapshot.data.documents[index]);
              },
            );
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(title: _titleBar(), actions: <Widget>[
      RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
        child: IconButton(
          icon: _isSearch ? Icon(Icons.close) : Icon(Icons.search),
          onPressed: () {
            // _searchPressed();
          },
        ),
      ),
      // action button
    ]);
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
        Align(
            alignment: Alignment.centerLeft,
            child:
                Visibility(visible: !_isSearch, child: Text(Dictionary.faq))),
      ],
    );
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.trim().isNotEmpty) {
        print(_searchController.text);
        // _resultList.clear();
        // _page = 1;
        // _importantInfoSearchBloc
        //     .add(ImportantInfoSearch(_searchController.text, _page));

      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
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
