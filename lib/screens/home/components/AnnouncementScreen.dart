import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
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
      dataAnnouncement =
          json.decode(remoteConfig.getString(FirebaseConfig.announcement));
    }

    return remoteConfig != null && dataAnnouncement['enabled'] == true
        ? Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Announcement(
              title: dataAnnouncement['title'] != null
                  ? dataAnnouncement['title']
                  : Dictionary.titleInfoTextAnnouncement,
              content: dataAnnouncement['content'] != null
                  ? dataAnnouncement['content']
                  : Dictionary.infoTextAnnouncement,
              context: context,
              actionUrl: dataAnnouncement['action_url'],
            ),
          )
        : Container();
  }
}
