import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

// ignore: must_be_immutable
class CollapsingAppbar extends StatefulWidget {
  ScrollController scrollController;
  bool isShrink;
  List<Widget> actionsAppBar;
  double heightAppbar;
  String titleAppbar;
  Widget backgroundAppBar;
  Widget body;
  bool isBottomAppbar;

  CollapsingAppbar(
      {this.scrollController,
      this.isShrink,
      this.heightAppbar,
      this.actionsAppBar,
      this.titleAppbar,
      this.backgroundAppBar,
      this.body,
      this.isBottomAppbar});

  @override
  _CollapsingAppbarState createState() => _CollapsingAppbarState();
}

class _CollapsingAppbarState extends State<CollapsingAppbar> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: widget.scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            actions: widget.actionsAppBar,
            bottom: widget.isBottomAppbar
                ? PreferredSize(
                    preferredSize: Size.fromHeight(widget.isShrink ? 0 : 130.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: widget.isShrink ? 0.0 : 1.0,
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
                      ],
                    ),
                  )
                : null,
            iconTheme: IconThemeData(
                color: widget.isShrink ? Colors.black : Colors.white),
            expandedHeight: widget.heightAppbar ?? 150,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: AnimatedOpacity(
                        opacity: widget.isShrink ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 250),
                        child: Text(
                          widget.isShrink ? widget.titleAppbar : '',
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
                background: widget.backgroundAppBar),
          ),
        ];
      },
      body: widget.body,
    );
  }
}
