import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CustomBubbleTab extends StatefulWidget {
  final List<String> listItemTitleTab;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedlabelColor;
  final ValueChanged<int> onTap;
  final List<Widget> tabBarView;
  final double heightTabBarView;
  final double paddingTopTabBarView;

  CustomBubbleTab(
      {this.listItemTitleTab,
      this.labelColor,
      this.unselectedlabelColor,
      this.indicatorColor,
      this.onTap,
      this.tabBarView,
      this.heightTabBarView,
      this.paddingTopTabBarView});

  @override
  _CustomBubbleTabState createState() => _CustomBubbleTabState();
}

class _CustomBubbleTabState extends State<CustomBubbleTab> {
  List<Widget> listBubbleTabItem = [];
  String dataSelected = "";

  @override
  void initState() {
    listBubbleTabItem.clear();
    for (int i = 0; i < widget.listItemTitleTab.length; i++) {
      dataSelected = widget.listItemTitleTab[0];
      listBubbleTabItem
          .add(BubleTabItem(widget.listItemTitleTab[i], dataSelected));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listBubbleTabItem.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TabBar(
              isScrollable: true,
              onTap: (index) {
                setState(() {
                  dataSelected = widget.listItemTitleTab[index];
                  listBubbleTabItem.clear();
                  for (int i = 0; i < widget.listItemTitleTab.length; i++) {
                    listBubbleTabItem.add(
                        BubleTabItem(widget.listItemTitleTab[i], dataSelected));
                  }
                });
                widget.onTap(index);
              },
              labelColor: widget.labelColor,
              unselectedLabelColor: widget.unselectedlabelColor,
              indicator: BubbleTabIndicator(
                indicatorHeight: 37.0,
                indicatorColor: widget.indicatorColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              indicatorColor: widget.indicatorColor,
              indicatorWeight: 0.1,
              labelPadding: EdgeInsets.all(10),
              tabs: listBubbleTabItem),
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

  // ignore: non_constant_identifier_names
  Widget BubleTabItem(String title, String dataSelected) {
    return Tab(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
                color: dataSelected == title
                    ? widget.indicatorColor
                    : Color(0xffE0E0E0),
                width: 1)),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.lato,
              fontSize: 10.0),
        ),
      ),
    );
  }
}
