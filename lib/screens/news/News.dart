import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';

class News extends StatefulWidget {
  final String news;

  News({this.news});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: Text(
        Dictionary.latestNews,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans,
            fontSize: 13.0),
      ),
    ),
    new Tab(
        child: Text(
      Dictionary.nationalNews,
          textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.productSans,
          fontSize: 13.0),
    )),
    new Tab(
        child: Text(
      Dictionary.worldNews,
          textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.productSans,
          fontSize: 13.0),
    )),
  ];
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this, length: myTabs.length);
    if (widget.news == Dictionary.latestNews) {
      tabController.animateTo(0);
    } else if (widget.news == Dictionary.nationalNews) {
      tabController.animateTo(1);
    } else {
      tabController.animateTo(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Dictionary.news,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: FontsFamily.productSans,
                fontSize: 17.0),
          ),
          bottom: TabBar(
            indicatorColor: ColorBase.orange,
            indicatorWeight: 2.8,
            tabs: myTabs,
            controller: tabController,
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              NewsScreen(news: Dictionary.latestNews),
              NewsScreen(news: Dictionary.nationalNews),
              NewsScreen(news: Dictionary.worldNews),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
