import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';

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
    /// Condition for get data announcement from remote config
    if (remoteConfig != null) {
      dataAnnouncement =
          json.decode(remoteConfig.getString(FirebaseConfig.announcement));
    }

    /// Set up for show announcement widget
    return remoteConfig != null && dataAnnouncement['enabled'] == true
        ? Announcement(
          title: dataAnnouncement['title'] != null
              ? dataAnnouncement['title']
              : Dictionary.titleInfoTextAnnouncement,
          content: dataAnnouncement['content'] != null
              ? dataAnnouncement['content']
              : Dictionary.infoTextAnnouncement,
          context: context,
          actionUrl: dataAnnouncement['action_url'],
        )
        : Container();
  }
}
