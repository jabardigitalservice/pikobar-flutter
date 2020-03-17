import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Dictionary.news),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: Dictionary.liveUpdate),
              Tab(text: Dictionary.persRilis),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            NewsScreen(isLiveUpdate: true),
            NewsScreen(isLiveUpdate: false),
          ],
        ),
      ),
    );
  }
}
