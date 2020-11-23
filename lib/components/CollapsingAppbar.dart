import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

// ignore: must_be_immutable
class CollapsingAppbar extends StatefulWidget {
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
      {this.scrollController,
      this.showTitle,
      this.heightAppbar,
      this.actionsAppBar,
      this.titleAppbar,
      this.backgroundAppBar,
      this.body,
      this.searchBar,
      this.isBottomAppbar});

  @override
  _CollapsingAppbarState createState() => _CollapsingAppbarState();
}

class _CollapsingAppbarState extends State<CollapsingAppbar> {
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
            bottom: widget.isBottomAppbar
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
                color: widget.isBottomAppbar
                    ? Colors.black
                    : widget.showTitle
                        ? Colors.black
                        : Colors.white),
            expandedHeight: widget.showTitle
                ? widget.isBottomAppbar
                    ? widget.heightAppbar
                    : 250
                : widget.isBottomAppbar
                    ? 180
                    : 300,
            floating: false,
            flexibleSpace: !widget.isBottomAppbar
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
            title: widget.isBottomAppbar
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
