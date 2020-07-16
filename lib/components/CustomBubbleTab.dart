import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

// ignore: must_be_immutable
class CustomBubbleTab extends StatefulWidget {
  final List<String> listItemTitleTab;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final ValueChanged<int> onTap;
  final List<Widget> tabBarView;
  final double heightTabBarView;
  final double paddingTopTabBarView;
  final TabController tabController;
  final String typeTabSelected;
  bool isExpand;

  CustomBubbleTab(
      {this.listItemTitleTab,
      this.labelColor,
      this.unselectedLabelColor,
      this.indicatorColor,
      this.onTap,
      this.tabBarView,
      this.heightTabBarView,
      this.paddingTopTabBarView,
      this.tabController,
      this.typeTabSelected,
      this.isExpand});

  @override
  _CustomBubbleTabState createState() => _CustomBubbleTabState();
}

class _CustomBubbleTabState extends State<CustomBubbleTab> {
  List<Widget> listBubbleTabItem = [];
  String dataSelected = "";
  bool isExpand;
  @override
  void initState() {
    listBubbleTabItem.clear();
    for (int i = 0; i < widget.listItemTitleTab.length; i++) {
      if (widget.typeTabSelected != null) {
        dataSelected = widget.typeTabSelected;
      } else {
        dataSelected = widget.listItemTitleTab[0];
      }
      listBubbleTabItem
          .add(bubbleTabItem(widget.listItemTitleTab[i], dataSelected));
    }
    if (widget.isExpand != null) {
      isExpand = widget.isExpand;
    } else {
      isExpand = false;
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
              controller:
                  widget.tabController != null ? widget.tabController : null,
              isScrollable: true,
              onTap: (index) {
                setState(() {
                  dataSelected = widget.listItemTitleTab[index];
                  listBubbleTabItem.clear();
                  for (int i = 0; i < widget.listItemTitleTab.length; i++) {
                    listBubbleTabItem.add(bubbleTabItem(
                        widget.listItemTitleTab[i], dataSelected));
                  }
                });
                widget.onTap(index);
              },
              labelColor: widget.labelColor,
              unselectedLabelColor: widget.unselectedLabelColor,
              indicator: BubbleTabIndicator(
                indicatorHeight: 37.0,
                indicatorColor: widget.indicatorColor,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              indicatorColor: widget.indicatorColor,
              indicatorWeight: 0.1,
              labelPadding: EdgeInsets.all(10),
              tabs: listBubbleTabItem),
         isExpand
              ? Expanded(
                  child: TabBarView(
                    controller: widget.tabController != null
                        ? widget.tabController
                        : null,
                    physics: NeverScrollableScrollPhysics(),
                    children: widget.tabBarView,
                  ),
                )
              : Container(
                  height: widget.heightTabBarView,
                  padding: EdgeInsets.only(top: widget.paddingTopTabBarView),
                  child: TabBarView(
                    controller: widget.tabController != null
                        ? widget.tabController
                        : null,
                    physics: NeverScrollableScrollPhysics(),
                    children: widget.tabBarView,
                  ),
                ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget bubbleTabItem(String title, String dataSelected) {
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
