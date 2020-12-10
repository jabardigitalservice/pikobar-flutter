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
  bool isScrollable;
  double sizeLabel;
  bool isStickyHeader;
  bool showTitle;
  ScrollController scrollController;
  Widget searchBar;
  String titleHeader;
  String subTitle;

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
      this.isExpand,
      this.isScrollable,
      this.sizeLabel,
      this.isStickyHeader = false,
      this.showTitle,
      this.scrollController,
      this.searchBar,
      this.titleHeader,
      this.subTitle});

  @override
  _CustomBubbleTabState createState() => _CustomBubbleTabState();
}

class _CustomBubbleTabState extends State<CustomBubbleTab>
    with SingleTickerProviderStateMixin {
  List<Widget> listBubbleTabItem = [];
  TabController _basetabController;
  String dataSelected = "";
  bool isExpand;
  bool isSwipe = false;
  int indexTab = 0;

  @override
  void initState() {
    _basetabController = widget.tabController ??
        TabController(vsync: this, length: widget.listItemTitleTab.length);
    _basetabController.addListener(_handleTabSelection);
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
    return widget.isStickyHeader
        ? DefaultTabController(
            length: listBubbleTabItem.length,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: NestedScrollView(
                  controller: widget.scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return <Widget>[_buildSliverAppBar(context)];
                  },
                  body: TabBarView(
                    controller: widget.tabController != null
                        ? widget.tabController
                        : _basetabController,
                    children: widget.tabBarView,
                  )),
            ),
          )
        : DefaultTabController(
            length: listBubbleTabItem.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TabBar(
                    controller: widget.tabController != null
                        ? widget.tabController
                        : _basetabController,
                    isScrollable: widget.isScrollable != null
                        ? widget.isScrollable
                        : true,
                    onTap: (index) {
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
                              : _basetabController,
                          children: widget.tabBarView,
                        ),
                      )
                    : Container(
                        height: widget.heightTabBarView,
                        padding: EdgeInsets.only(
                            top: widget.paddingTopTabBarView != null
                                ? widget.paddingTopTabBarView
                                : 0.0),
                        child: TabBarView(
                          controller: widget.tabController != null
                              ? widget.tabController
                              : _basetabController,
                          children: widget.tabBarView,
                        ),
                      ),
              ],
            ),
          );
  }

  _handleTabSelection() {
    if (indexTab != _basetabController.index) {
      setState(() {
        widget.onTap(_basetabController.index);
        indexTab = _basetabController.index;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget bubbleTabItem(String title, String dataSelected) {
    return Tab(
      child: Container(
        padding: EdgeInsets.all(10),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(50),
        //     border: Border.all(
        //         color: widget.indicatorColor,
        //         width: 1)),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: FontsFamily.lato,
              fontSize: widget.sizeLabel ?? 10.0),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        pinned: true,
        expandedHeight: widget.showTitle
            ? 150
            : widget.searchBar != null
                ? 250.0
                : widget.subTitle != null ? 200 : 150,
        title: AnimatedOpacity(
          opacity: widget.showTitle ? 1.0 : 0.0,
          duration: Duration(milliseconds: 250),
          child: Text(
            widget.showTitle ? widget.titleHeader : '',
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        bottom: widget.showTitle
            ? TabBar(
                controller: widget.tabController != null
                    ? widget.tabController
                    : _basetabController,
                isScrollable:
                    widget.isScrollable != null ? widget.isScrollable : true,
                onTap: (index) {
                  // setState(() {
                  //   dataSelected = widget.listItemTitleTab[index];
                  //   listBubbleTabItem.clear();
                  //   for (int i = 0; i < widget.listItemTitleTab.length; i++) {
                  //     listBubbleTabItem.add(bubbleTabItem(
                  //         widget.listItemTitleTab[i], dataSelected));
                  //   }
                  // });
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
                tabs: listBubbleTabItem)
            : PreferredSize(
                preferredSize: Size.fromHeight(widget.showTitle ? 0 : 130.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedOpacity(
                      opacity: widget.showTitle ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 250),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.titleHeader,
                              style: TextStyle(
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900),
                            ),
                            widget.subTitle != null ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                widget.subTitle,
                                style: TextStyle(
                                  fontFamily: FontsFamily.roboto,
                                  fontSize: 12.0,
                                ),
                              ),
                            ) : Container(),
                          ],
                        ),
                      ),
                    ),
                    widget.showTitle
                        ? Container()
                        : widget.searchBar ?? Container(),
                    TabBar(
                        controller: widget.tabController != null
                            ? widget.tabController
                            : _basetabController,
                        isScrollable: widget.isScrollable != null
                            ? widget.isScrollable
                            : true,
                        onTap: (index) {
                          // setState(() {
                          //   dataSelected = widget.listItemTitleTab[index];
                          //   listBubbleTabItem.clear();
                          //   for (int i = 0; i < widget.listItemTitleTab.length; i++) {
                          //     listBubbleTabItem.add(bubbleTabItem(
                          //         widget.listItemTitleTab[i], dataSelected));
                          //   }
                          // });
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
                  ],
                ),
              ));
  }
}
