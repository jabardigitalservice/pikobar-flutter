import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/BannerListSlider.dart';
import 'package:pikobar_flutter/screens/home/components/DailyUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/screens/home/components/statistics/Statistics.dart';

class JabarTodayScreen extends StatefulWidget {
  @override
  _JabarTodayScreenState createState() => _JabarTodayScreenState();
}

class _JabarTodayScreenState extends State<JabarTodayScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          color: Colors.white,
        ),
        ListView(children: [
          /// Banners Section
          Container(
              margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: BannerListSlider()),

          /// Statistics Announcement
          AnnouncementScreen(),

          /// Daily Update Section
          DailyUpdateScreen(),

          /// Statistics Section
          Container(
              color: ColorBase.grey,
              margin: EdgeInsets.only(top: 10.0),
              child: Statistics()),

          Container(
            padding: EdgeInsets.only(top: 25.0),
            child: SocialMedia(),
          ),
        ]),
        AlertUpdate()
      ],
    );
  }
}
