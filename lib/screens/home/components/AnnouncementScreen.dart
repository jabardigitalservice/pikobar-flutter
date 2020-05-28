import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class AnnouncementScreen extends StatefulWidget {

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  Map<String, dynamic> dataAnnouncement;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, state) {
        return state is RemoteConfigLoaded
            ? _buildContent(state.remoteConfig)
            : Container();
      },
    );
  }

  _buildContent(RemoteConfig remoteConfig) {
    if (remoteConfig != null) {
      dataAnnouncement = json
          .decode(remoteConfig.getString(FirebaseConfig.announcement));
    }

    return remoteConfig != null &&
            dataAnnouncement['enabled'] == true
        ? Container(
            width: (MediaQuery.of(context).size.width),
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
                color: ColorBase.announcementBackgroundColor,
                borderRadius: BorderRadius.circular(8.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dataAnnouncement['title'] != null
                      ? dataAnnouncement['title']
                      : Dictionary.titleInfoTextAnnouncement,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.productSans),
                ),
                SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
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
                                      openChromeSafariBrowser(
                                          url: dataAnnouncement['action_url']);
                                    })
                              : TextSpan(text: '')
                        ]),
                      )),
                    ),
                  ],
                ),
              ],
            ))
        : Container();
  }
}
