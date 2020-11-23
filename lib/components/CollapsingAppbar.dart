import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

// ignore: must_be_immutable
class CollapsingAppbar extends StatefulWidget {
  /// [scrollController] cannot be null, required for set controller NestedScrollView
  /// [showTitle] cannot be null, for set hide & show title in appbar
  /// [actionsAppBar] for set icon or widget inside action Appbar
  /// [heightAppbar] for set height Appbar
  /// [titleAppbar] cannot be null, for set title Appbar
  /// [backgroundAppBar] for set widget in background Appbar
  /// [body] cannot be null, for set widget inside body Appbar
  /// [searchBar] for set widget search inside Appbar
  /// [isBottomAppbar] for set bottom inside Appbar

  ScrollController scrollController;
  bool showTitle;
  List<Widget> actionsAppBar;
  double heightAppbar;
  String titleAppbar;
  Widget backgroundAppBar;
  Widget body;
  Widget searchBar;
  bool isBottomAppbar;

  CollapsingAppbar(
      {@required this.scrollController,
      @required this.showTitle,
      this.heightAppbar,
      this.actionsAppBar,
      @required this.titleAppbar,
      this.backgroundAppBar,
      @required this.body,
      this.searchBar,
      this.isBottomAppbar});

  @override
  _CollapsingAppbarState createState() => _CollapsingAppbarState();
}

class _CollapsingAppbarState extends State<CollapsingAppbar> {
  double heightAppbar;
  bool isBottomAppbar;

  @override
  void initState() {
    /// for set default value for height appbar & bottom Appbar
    heightAppbar = widget.heightAppbar ?? 150;
    isBottomAppbar = widget.isBottomAppbar ?? true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            actions: widget.actionsAppBar,
            bottom: isBottomAppbar
                ? !widget.showTitle
                    ? PreferredSize(
                        preferredSize:
                            Size.fromHeight(widget.showTitle ? 0 : 130.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedOpacity(
                              opacity: widget.showTitle ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 250),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  widget.titleAppbar,
                                  style: TextStyle(
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                            widget.searchBar != null
                                ? widget.showTitle
                                    ? Container()
                                    : widget.searchBar
                                : Container(),
                          ],
                        ),
                      )
                    : PreferredSize(
                        child: Container(), preferredSize: Size.fromHeight(0))
                : null,
            iconTheme: IconThemeData(
                color: isBottomAppbar
                    ? Colors.black
                    : widget.showTitle
                        ? Colors.black
                        : Colors.white),
            expandedHeight: widget.showTitle
                ? isBottomAppbar
                    ? heightAppbar
                    : 250
                : isBottomAppbar
                    ? 180
                    : 300,
            floating: false,
            flexibleSpace: !isBottomAppbar
                ? FlexibleSpaceBar(
                    centerTitle: true,
                    title: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 70),
                          child: AnimatedOpacity(
                            opacity: widget.showTitle ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 250),
                            child: Text(
                              widget.showTitle ? widget.titleAppbar : '',
                              style: TextStyle(
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                    background: widget.backgroundAppBar)
                : null,
            title: isBottomAppbar
                ? AnimatedOpacity(
                    opacity: widget.showTitle ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 250),
                    child: Text(
                      widget.showTitle ? widget.titleAppbar : '',
                      style: TextStyle(
                          fontFamily: FontsFamily.lato,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  )
                : null,
          ),
        ];
      },
      body: widget.body,
    );
  }
}
