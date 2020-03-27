import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/utilities/sharedpreference/AnnouncementSharedPreference.dart';

class AnnouncementScreen extends StatefulWidget {
  final RemoteConfig remoteConfig;

  AnnouncementScreen(this.remoteConfig);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  bool isCloseAnnouncement;
  Map<String, dynamic> dataAnnouncement;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 0), () async {
      isCloseAnnouncement =
          await AnnouncementSharedPreference.getAnnounceScreen();
    });

    if (widget.remoteConfig != null) {
      dataAnnouncement = json
          .decode(widget.remoteConfig.getString(FirebaseConfig.announcement));
    }
    return widget.remoteConfig != null &&
            dataAnnouncement['enabled'] == true &&
            isCloseAnnouncement == true
        ? Container(
            width: (MediaQuery.of(context).size.width),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: ColorBase.announcementBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: dataAnnouncement['content'] != null
                                ? dataAnnouncement['content']
                                : Dictionary.infoTextAnnouncement,
                            style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                                fontFamily: FontsFamily.productSans),
                          ),
                          dataAnnouncement['action_url'].toString().isNotEmpty
                              ? TextSpan(
                                  text: Dictionary.moreDetail,
                                  style: TextStyle(
                                      color: ColorBase.green,
                                      fontFamily: FontsFamily.productSans,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, NavigationConstrants.Browser,
                                          arguments:
                                              dataAnnouncement['action_url']);
                                    })
                              :  TextSpan(text: '')
                        ]),
                      )),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[600],
                    size: 18,
                  ),
                  onTap: () async {
                    setState(() {
                      isCloseAnnouncement = false;
                    });
                    await AnnouncementSharedPreference.setAnnounceScreen(false);
                  },
                )
              ],
            ),
          )
        : Container();
  }
}
