import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CustomAppBar {
  AppBar DefaultAppBar(
      {Widget leading, @required String title, List<Widget> actions}) {
    return AppBar(
      leading: leading,
      title: Text(title,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.intro),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
      titleSpacing: 0.0,
      actions: actions,
    );
  }

  static AppBar SearchAppBar(
      BuildContext context, TextEditingController textController) {
    return AppBar(
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
}
