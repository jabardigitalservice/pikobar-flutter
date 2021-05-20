import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/screens/home/components/AlertUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/AnnouncementScreen.dart';
import 'package:pikobar_flutter/screens/home/components/BannerListSlider.dart';
import 'package:pikobar_flutter/screens/home/components/DailyChart.dart';
import 'package:pikobar_flutter/screens/home/components/DailyUpdate.dart';
import 'package:pikobar_flutter/screens/home/components/SocialMedia.dart';
import 'package:pikobar_flutter/screens/home/components/Zonation.dart';
import 'package:pikobar_flutter/screens/home/components/statistics/Statistics.dart';

class JabarTodayScreen extends StatefulWidget {
  JabarTodayScreen({Key key}) : super(key: key);

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
              margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: BannerListSlider()),

          /// Statistics Announcement
          AnnouncementScreen(),

          /// Zonation
          Zonation(),

          /// Daily Update Section
          DailyUpdateScreen(),

          /// Statistics Section
          Container(
              color: ColorBase.grey,
              margin: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[50],
                    width: MediaQuery.of(context).size.width,
                    height: 10,
                  ),
                  Statistics(),
                ],
              )),

          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Container(
                  color: Colors.grey[50],
                  width: MediaQuery.of(context).size.width,
                  height: 10,
                ),
                DailyChart(),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: SocialMedia(),
          ),
        ]),
        AlertUpdate()
      ],
    );
  }
}
