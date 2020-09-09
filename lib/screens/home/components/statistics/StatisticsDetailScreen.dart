import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

import 'Statistics.dart';

class StatisticsDetailScreen extends StatefulWidget {
  final RemoteConfigLoaded remoteConfigLoaded;
  final StatisticsLoaded statisticsLoaded;
  final RapidTestLoaded rapidTestLoaded;
  final PcrTestLoaded pcrTestLoaded;

  StatisticsDetailScreen(
      {@required this.remoteConfigLoaded,
      @required this.statisticsLoaded,
      @required this.rapidTestLoaded,
      @required this.pcrTestLoaded})
      : assert(remoteConfigLoaded != null),
        assert(statisticsLoaded != null),
        assert(rapidTestLoaded != null),
        assert(pcrTestLoaded != null);

  @override
  _StatisticsDetailScreenState createState() => _StatisticsDetailScreenState();
}

class _StatisticsDetailScreenState extends State<StatisticsDetailScreen> {
  RemoteConfig get remoteConfig => widget.remoteConfigLoaded.remoteConfig;

  DocumentSnapshot get statisticsDoc => widget.statisticsLoaded.snapshot;

  DocumentSnapshot get rapidDoc => widget.rapidTestLoaded.snapshot;

  DocumentSnapshot get pcrDoc => widget.pcrTestLoaded.snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.statistics),
      body: SingleChildScrollView(child: _buildContent()),
    );
  }

  _buildContent() {
    if (!statisticsDoc.exists)
      return Container(
        child: Center(
          child: Text(Dictionary.errorStatisticsNotExists),
        ),
      );

    // Get label from the remote config
    Map<String, dynamic> labels = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.labels,
        defaultValue: FirebaseConfig.labelsDefaultValue);

    // Get bottom sheet config from the remote config
    Map<String, dynamic> statisticBottomSheet = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.statisticsBottomSheet,
        defaultValue: FirebaseConfig.statisticsBottomSheetDefaultValue);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labels['last_updated_on'],
                  style: TextStyle(
                      color: ColorBase.veryDarkGrey,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  unixTimeStampToDateTimeWithoutDay(
                      statisticsDoc['updated_at'].seconds),
                  style: TextStyle(
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.lato,
                      fontSize: 10.0),
                ),
                SizedBox(height: Dimens.padding),
                _buildConfirmedBox(
                    label: labels['statistics']['confirmed'],
                    caseTotal: '${statisticsDoc['aktif']['jabar']}'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: Dimens.padding,
                bottom: Dimens.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContainerOne(
                    '${Environment.iconAssets}virus_yellow.png',
                    labels['statistics']['positif'],
                    getDataActivePositive(
                        statisticsDoc['aktif']['jabar'],
                        statisticsDoc['sembuh']['jabar'],
                        statisticsDoc['meninggal']['jabar']),
                    getDataProcessPercent(
                        statisticsDoc['aktif']['jabar'],
                        int.parse(getDataActivePositive(
                            statisticsDoc['aktif']['jabar'],
                            statisticsDoc['sembuh']['jabar'],
                            statisticsDoc['meninggal']['jabar'])))),
                _buildContainerOne(
                    '${Environment.iconAssets}virus_green.png',
                    labels['statistics']['recovered'],
                    '${statisticsDoc['sembuh']['jabar']}',
                    getDataProcessPercent(statisticsDoc['aktif']['jabar'],
                        statisticsDoc['sembuh']['jabar'])),
                _buildContainerOne(
                    '${Environment.iconAssets}virus_red.png',
                    labels['statistics']['deaths'],
                    '${statisticsDoc['meninggal']['jabar']}',
                    getDataProcessPercent(statisticsDoc['aktif']['jabar'],
                        statisticsDoc['meninggal']['jabar']))
              ],
            ),
          ),

          /// Total Kasus Kontak Erat
          _buildContainerTwo(
              labels['statistics']['odp'],
              () {
                showTextBottomSheet(
                    context: context,
                    title: statisticBottomSheet['kontak_erat']['title'],
                    message: statisticBottomSheet['kontak_erat']['message']);
              },
              '${statisticsDoc['kontak_erat']['total']}',
              labels['statistics']['quarantine'],
              '${statisticsDoc['kontak_erat']['karantina']}',
              getDataProcessPercent(statisticsDoc['kontak_erat']['total'],
                  statisticsDoc['kontak_erat']['karantina']),
              labels['statistics']['discarded'],
              () {
                showTextBottomSheet(
                    context: context,
                    title: statisticBottomSheet['discarded']['title'],
                    message: statisticBottomSheet['discarded']['message']);
              },
              getDataProcess(statisticsDoc['kontak_erat']['total'],
                  statisticsDoc['kontak_erat']['karantina']),
              getDataProcessPercent(
                  statisticsDoc['kontak_erat']['total'],
                  int.parse(getDataProcess(
                      statisticsDoc['kontak_erat']['total'],
                      statisticsDoc['kontak_erat']['karantina'])))),

          /// Total Kasus Suspek
          _buildContainerTwo(
              labels['statistics']['pdp'],
              () {
                showTextBottomSheet(
                    context: context,
                    title: statisticBottomSheet['suspek']['title'],
                    message: statisticBottomSheet['suspek']['message']);
              },
              '${statisticsDoc['suspek']['total']}',
              labels['statistics']['positif'],
              '${statisticsDoc['suspek']['isolasi']}',
              getDataProcessPercent(statisticsDoc['suspek']['total'],
                  statisticsDoc['suspek']['isolasi']),
              labels['statistics']['discarded'],
              () {
                showTextBottomSheet(
                    context: context,
                    title: statisticBottomSheet['discarded']['title'],
                    message: statisticBottomSheet['discarded']['message']);
              },
              getDataProcess(statisticsDoc['suspek']['total'],
                  statisticsDoc['suspek']['isolasi']),
              getDataProcessPercent(
                  statisticsDoc['suspek']['total'],
                  int.parse(getDataProcess(statisticsDoc['suspek']['total'],
                      statisticsDoc['suspek']['isolasi'])))),

          /// Total Kasus Probable
          _buildContainerTwo(
            labels['statistics']['probable'],
            () {
              showTextBottomSheet(
                  context: context,
                  title: statisticBottomSheet['probable']['title'],
                  message: statisticBottomSheet['probable']['message']);
            },
            '${statisticsDoc['probable']['total']}',
            labels['statistics']['positif'],
            '${statisticsDoc['probable']['isolasi']}',
            getDataProcessPercent(statisticsDoc['probable']['total'],
                statisticsDoc['probable']['isolasi']),
            labels['statistics']['recovered'],
            null,
            '${statisticsDoc['probable']['selesai']}',
            getDataProcessPercent(statisticsDoc['probable']['total'],
                statisticsDoc['probable']['selesai']),
            fourthTitle: labels['statistics']['deaths'],
            fourthTitleHelpOnTap: null,
            fourthCount:
                '${statisticsDoc['probable']['total'] - statisticsDoc['probable']['isolasi'] - statisticsDoc['probable']['selesai']}',
            fourthPercentage: getDataProcessPercent(
                statisticsDoc['probable']['total'],
                statisticsDoc['probable']['total'] -
                    statisticsDoc['probable']['isolasi'] -
                    statisticsDoc['probable']['selesai']),
          ),

          _buildContentRapidTest()
        ],
      ),
    );
  }

  _buildConfirmedBox({@required String label, @required caseTotal}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: ColorBase.gradientBlueStatistics),
          borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: [
          Positioned(
              width: 60.0,
              height: 60.0,
              right: 0.0,
              top: 0.0,
              child: Image.asset(
                '${Environment.iconAssets}virus_purple.png',
                width: 60.0,
                height: 60.0,
              )),
          Container(
            margin: EdgeInsets.all(Dimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    formattedStringNumber(caseTotal),
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildContainerOne(
      String image, String title, String count, String percentage) {
    count = formattedStringNumber(count);

    return Expanded(
      child: Container(
        width: (MediaQuery.of(context).size.width / 3),
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
            color: Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 5.0),
                child: image != ''
                    ? Image.asset(
                        image,
                        height: 15.0,
                      )
                    : null),
            Container(
              margin: EdgeInsets.only(top: 10, left: 5.0),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.lato)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 5.0),
              child: Text(count,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: ColorBase.veryDarkGrey,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 5.0),
              child: percentage != ''
                  ? Text(percentage,
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff828282),
                          fontFamily: FontsFamily.lato))
                  : null,
            )
          ],
        ),
      ),
    );
  }

  _buildContainerTwo(
      String mainTitle,
      GestureTapCallback mainTitleHelpOnTap,
      String mainCount,
      String secondTitle,
      String secondCount,
      String secondPercentage,
      String thirdTitle,
      GestureTapCallback thirdTitleHelpOnTap,
      String thirdCount,
      String thirdPercentage,
      {String fourthTitle,
      GestureTapCallback fourthTitleHelpOnTap,
      String fourthCount,
      String fourthPercentage}) {
    mainCount = formattedStringNumber(mainCount);
    secondCount = formattedStringNumber(secondCount);
    thirdCount = formattedStringNumber(thirdCount);
    fourthCount = formattedStringNumber(fourthCount);

    return Container(
      padding: EdgeInsets.all(Dimens.padding),
      margin: EdgeInsets.only(
          left: Dimens.padding, right: Dimens.padding, bottom: Dimens.padding),
      decoration: BoxDecoration(
          color: Color(0xFFFAFAFA), borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mainTitle,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.lato)),
              GestureDetector(
                  onTap: mainTitleHelpOnTap,
                  child: SizedBox(
                    width: 20,
                    child: Icon(Icons.help_outline,
                        size: 13.0, color: ColorBase.darkGrey),
                  ),)
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(mainCount,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20.0,
                    color: ColorBase.veryDarkGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto)),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.padding),
            width: MediaQuery.of(context).size.width,
            height: 1.0,
            color: ColorBase.menuBorderColor,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(secondTitle,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: ColorBase.darkGrey,
                            fontFamily: FontsFamily.lato)),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(secondCount,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: ColorBase.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(secondPercentage,
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.darkGrey,
                              fontFamily: FontsFamily.lato)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(thirdTitle,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: ColorBase.darkGrey,
                                fontFamily: FontsFamily.lato)),
                        thirdTitleHelpOnTap != null
                            ? GestureDetector(
                                onTap: thirdTitleHelpOnTap,
                                child: SizedBox(
                                  width: 20,
                                  child: Icon(Icons.help_outline,
                                      size: 13.0, color: ColorBase.darkGrey),
                                ),
                              )
                            : Container()
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(thirdCount,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: ColorBase.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(thirdPercentage,
                          style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.darkGrey,
                              fontFamily: FontsFamily.lato)),
                    )
                  ],
                ),
              ),
              fourthTitle != null
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(fourthTitle ?? '',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: ColorBase.darkGrey,
                                      fontFamily: FontsFamily.lato)),
                              SizedBox(width: 5.0),
                              fourthTitleHelpOnTap != null
                                  ? GestureDetector(
                                      onTap: fourthTitleHelpOnTap,
                                      child: SizedBox(
                                        width: 20,
                                        child: Icon(Icons.help_outline,
                                            size: 13.0, color: ColorBase.darkGrey),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(fourthCount ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: ColorBase.darkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontsFamily.roboto)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(fourthPercentage ?? '',
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                    color: ColorBase.darkGrey,
                                    fontFamily: FontsFamily.lato)),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  _buildContentRapidTest() {
    String count =
        formattedStringNumber('${rapidDoc['total'] + pcrDoc['total']}');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RapidTestDetail(remoteConfig, rapidDoc, pcrDoc)),
        );
      },
      child: Card(
        elevation: 0,
        color: Color(0xffFAFAFA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
        child: Padding(
          padding: EdgeInsets.all(Dimens.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Container(
                        height: 41,
                        child: Image.asset(
                            '${Environment.imageAssets}bloodTest@4x.png')),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: Dimens.verticalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(Dictionary.testSummaryTitle,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: ColorBase.veryDarkGrey,
                                    fontFamily: FontsFamily.lato)),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(count,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: ColorBase.veryDarkGrey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: FontsFamily.roboto)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Color(0xff27AE60),
              )
            ],
          ),
        ),
      ),
    );
  }
}
