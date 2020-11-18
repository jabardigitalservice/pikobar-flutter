import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CustomAppBar {
  static AppBar defaultAppBar(
      {Widget leading,
      @required String title,
      List<Widget> actions,
      PreferredSizeWidget bottom}) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: leading,
      title: setTitleAppBar(title),
      actions: actions,
      bottom: bottom,
    );
  }

  static AppBar searchAppBar(
      BuildContext context, TextEditingController textController) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Wrap(children: [
          Container(
              width: 25.0,
              height: 30.0,
              child: Icon(
                Icons.search,
                color: Colors.grey,
                size: 20.0,
              )),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 30.0,
            child: TextField(
                controller: textController,
                autofocus: true,
                maxLines: 1,
                minLines: 1,
                maxLength: 255,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                decoration: InputDecoration(
                    hintText: Dictionary.hintSearch,
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(5.0))),
          ),
        ]),
      ),
      titleSpacing: 0.0,
    );
  }

  static AppBar bottomSearchAppBar(
      {@required TextEditingController searchController,
      @required String title,
      @required String hintText,
      ValueChanged<String> onChanged}) {
    return AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: buildSearchField(searchController, hintText, onChanged),
        ),
        title: CustomAppBar.setTitleAppBar(title));
  }

  static Text setTitleAppBar(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: FontsFamily.productSans),
        maxLines: 1,
        overflow: TextOverflow.ellipsis);
  }

  static Widget buildSearchField(TextEditingController searchController,
      String hintText, ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      height: 40.0,
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          shape: BoxShape.rectangle,
          border: Border.all(color: ColorBase.greyBorder),
          borderRadius: BorderRadius.circular(8.0)),
      child: TextField(
        controller: searchController,
        autofocus: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: ColorBase.darkGrey,
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(EvaIcons.closeCircle),
                    color: ColorBase.darkGrey,
                    onPressed: () {
                      searchController.text = '';
                    },
                  )
                : null,
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: ColorBase.darkGrey,
                fontFamily: FontsFamily.lato,
                fontSize: 12,
                height: 2.2),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0)),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: onChanged,
      ),
    );
  }

  static AppBar animatedAppBar(
      {@required bool showTitle, @required String title}) {
    return AppBar(
      title: AnimatedOpacity(
        opacity: showTitle ? 1.0 : 0.0,
        duration: Duration(milliseconds: 250),
        child: Text(
          showTitle ? title : '',
          style: TextStyle(
              fontFamily: FontsFamily.lato,
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
