import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';

class News extends StatefulWidget {
 final bool isLiveUpdate;

  News({this.isLiveUpdate});

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News>  with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(text: Dictionary.liveUpdate),
    new Tab(text: Dictionary.persRilis),
  ];
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(vsync: this,length: 2);
    if(!widget.isLiveUpdate){
      tabController.animateTo((tabController.index + 1) % 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Dictionary.news),
          bottom: TabBar(
            tabs:myTabs,
            controller: tabController,
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabController,
            children: <Widget>[
              NewsScreen(isLiveUpdate: true),
              NewsScreen(isLiveUpdate: false),
            ],
          ),
        )
    );
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
