import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

// ignore: must_be_immutable
class CustomBubbleTab extends StatefulWidget {
  /// [listItemTitleTab] variable for set list each title in tabbar
  /// [indicatorColor] variable for set color when tab is selected
  /// [labelColor] variable for set color text inside tab is selected
  /// [unselectedLabelColor] variable for set color text inside tab is unselected
  /// [onTap] function for set condition when tab is clicked
  /// [tabBarView] for set widget layout inside tab
  /// [heightTabBarView] for set height tabbar
  /// [paddingTopTabBarView] for set padding top tabbar
  /// [tabController] for set controller in tab
  /// [typeTabSelected] for set selected tab
  /// [paddingBubbleTab] for set padding left & right each tab
  /// [isExpand] for set layout is expand or not
  /// [isScrollable] for tab is scrollable or not
  /// [sizeLabel] for set size label text inside tab
  /// [isStickyHeader] for tab is Sticky with header or not
  /// [showTitle] for set condition title is show or not when collapsing appbar
  /// [scrollController] for set controller inside NestedScrollView
  /// [searchBar] for set search inside appbar
  /// [titleHeader] for set title header in appbar

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
  final String titleNameLabelNew;
  int totalUnreadinfo;
  double paddingBubbleTab;
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
      this.subTitle,
      this.paddingBubbleTab,
      this.titleNameLabelNew,
      this.totalUnreadinfo});

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
  double paddingBubleTab;
  bool isScrollable;
  double paddingTopTabBarView;
  int totalUnreadlabelNew;
  bool isLoadLabelNew = true;

  @override
  void initState() {
    ///for set default each variable if get value null
    totalUnreadlabelNew = widget.totalUnreadinfo ?? 0;
    paddingBubleTab = widget.paddingBubbleTab ?? 0;
    paddingTopTabBarView = widget.paddingTopTabBarView ?? 0;
    isScrollable = widget.isScrollable ?? true;
    _basetabController = widget.tabController ??
        TabController(vsync: this, length: widget.listItemTitleTab.length);
    _basetabController.addListener(_handleTabSelection);
    listBubbleTabItem.clear();
    addItemDataBuble(false);
    if (widget.isExpand != null) {
      isExpand = widget.isExpand;
    } else {
      isExpand = false;
    }
    super.initState();
  }

  addItemDataBuble(bool isUpdateData) {
    for (int i = 0; i < widget.listItemTitleTab.length; i++) {
      if (widget.typeTabSelected != null) {
        dataSelected = widget.typeTabSelected;
      } else {
        dataSelected = widget.listItemTitleTab[0];
      }
      if (isUpdateData) {
        listBubbleTabItem[i] =
            bubbleTabItem(widget.listItemTitleTab[i], dataSelected);
      } else {
        listBubbleTabItem
            .add(bubbleTabItem(widget.listItemTitleTab[i], dataSelected));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ///condition for check is use collapsing appbar or not
    if (widget.titleNameLabelNew != null &&
        isLoadLabelNew &&
        widget.totalUnreadinfo > 0) {
      addItemDataBuble(true);
      isLoadLabelNew = false;
    }
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
                    controller: _basetabController,
                    children: widget.tabBarView,
                  )),
            ),
          )
        : DefaultTabController(
            length: listBubbleTabItem.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: paddingBubleTab, right: paddingBubleTab),
                  child: TabBar(
                      controller: _basetabController,
                      isScrollable: isScrollable,
                      onTap: (index) {
                        totalUnreadlabelNew = widget.totalUnreadinfo;
                        dataSelected = widget.listItemTitleTab[index];
                        for (int i = 0;
                            i < widget.listItemTitleTab.length;
                            i++) {
                          if (widget.listItemTitleTab[i] == dataSelected) {
                            listBubbleTabItem[index] = bubbleTabItem(
                                widget.listItemTitleTab[index], dataSelected);
                          } else {
                            listBubbleTabItem[i] = bubbleTabItem(
                                widget.listItemTitleTab[i], dataSelected);
                          }
                        }
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
                ),

                ///condition for check widget is Expanded or not
                isExpand
                    ? Expanded(
                        child: TabBarView(
                          controller: _basetabController,
                          children: widget.tabBarView,
                        ),
                      )
                    : Container(
                        height: widget.heightTabBarView,
                        padding: EdgeInsets.only(top: paddingTopTabBarView),
                        child: TabBarView(
                          controller: _basetabController,
                          children: widget.tabBarView,
                        ),
                      ),
              ],
            ),
          );
  }

  ///function for handle tab selected for update data
  _handleTabSelection() {
    if (indexTab != _basetabController.index) {
      setState(() {
        widget.onTap(_basetabController.index);
        indexTab = _basetabController.index;
      });
    }
  }

  ///widget for set item tab in tabbar
  // ignore: non_constant_identifier_names
  Widget bubbleTabItem(String title, String dataSelected) {
    totalUnreadlabelNew = widget.totalUnreadinfo;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tab(
          child: Container(
            // color: Colors.black,
            padding: EdgeInsets.all(10),
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.lato,
                  fontSize: widget.sizeLabel ?? 10.0),
            ),
          ),
        ),
        widget.titleNameLabelNew != null &&
                widget.titleNameLabelNew == title &&
                dataSelected != title &&
                totalUnreadlabelNew > 0
            ? Container(
                padding: EdgeInsets.only(left: 10),
                width: 10,
                height: 10,
                decoration: new BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              )
            : Container()
      ],
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
                : widget.subTitle != null
                    ? 200
                    : 150,
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

        ///condition for set title when collapsing
        bottom: widget.showTitle
            ? TabBar(
                controller: _basetabController,
                isScrollable: isScrollable,
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
                            widget.subTitle != null
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      widget.subTitle,
                                      style: TextStyle(
                                        fontFamily: FontsFamily.roboto,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    widget.showTitle
                        ? Container()
                        : widget.searchBar ?? Container(),
                    TabBar(
                        controller: _basetabController,
                        isScrollable: isScrollable,
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
                  ],
                ),
              ));
  }
}
