import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class CustomBubbleTab extends StatefulWidget {
  final int lengthTab;
  final Color indicatorColor;
  final ValueChanged<int> onTap;
  final List<Widget> tabs;
  final List<Widget> tabBarView;
  final double heightTabBarView;
  final double paddingTopTabBarView;

  CustomBubbleTab(
      {this.lengthTab,
      this.indicatorColor,
      this.onTap,
      this.tabs,
      this.tabBarView,
      this.heightTabBarView,
      this.paddingTopTabBarView});

  @override
  _CustomBubbleTabState createState() => _CustomBubbleTabState();
}

class _CustomBubbleTabState extends State<CustomBubbleTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.lengthTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
              isScrollable: true,
              onTap: (index) {
                widget.onTap(index);
              },
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicator: BubbleTabIndicator(
                indicatorHeight: 37.0,
                indicatorColor: widget.indicatorColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              indicatorColor: widget.indicatorColor,
              indicatorWeight: 0.1,
              labelPadding: EdgeInsets.all(10),
              tabs: widget.tabs),
          Container(
            height: widget.heightTabBarView,
            padding: EdgeInsets.only(top: widget.paddingTopTabBarView),
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: widget.tabBarView,
            ),
          ),
        ],
      ),
    );
  }
}
