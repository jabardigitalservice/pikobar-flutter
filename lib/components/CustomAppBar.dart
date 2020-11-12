import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
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
          color: Color(0xffFAFAFA),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0)),
      child: TextField(
        controller: searchController,
        autofocus: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xff828282),
            ),
            suffixIcon: searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(EvaIcons.closeCircle),
                    color: Color(0xff828282),
                    onPressed: () {
                      searchController.text = '';
                    },
                  )
                : null,
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Color(0xff828282),
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
}
