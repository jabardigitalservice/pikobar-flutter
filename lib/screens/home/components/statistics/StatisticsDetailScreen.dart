import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcrIndividu/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdtAntigen/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

import 'Statistics.dart';

class StatisticsDetailScreen extends StatefulWidget {
  final RemoteConfigLoaded remoteConfigLoaded;
  final StatisticsLoaded statisticsLoaded;
  final RapidTestLoaded rapidTestLoaded;
  final PcrTestLoaded pcrTestLoaded;
  final RapidTestAntigenLoaded rapidTestAntigenLoaded;
  final PcrTestIndividuLoaded pcrTestIndividuLoaded;

  StatisticsDetailScreen(
      {Key key,
      @required this.remoteConfigLoaded,
      @required this.statisticsLoaded,
      @required this.rapidTestLoaded,
      @required this.pcrTestLoaded,
      @required this.rapidTestAntigenLoaded,
      @required this.pcrTestIndividuLoaded})
      : assert(remoteConfigLoaded != null),
        assert(statisticsLoaded != null),
        assert(rapidTestLoaded != null),
        assert(pcrTestLoaded != null),
        assert(rapidTestAntigenLoaded != null),
        assert(pcrTestIndividuLoaded != null),
        super(key: key);

  @override
  _StatisticsDetailScreenState createState() => _StatisticsDetailScreenState();
}

class _StatisticsDetailScreenState extends State<StatisticsDetailScreen> {
  ScrollController _scrollController;

  RemoteConfig get remoteConfig => widget.remoteConfigLoaded.remoteConfig;

  DocumentSnapshot get statisticsDoc => widget.statisticsLoaded.snapshot;

  DocumentSnapshot get rapidDoc => widget.rapidTestLoaded.snapshot;

  DocumentSnapshot get pcrDoc => widget.pcrTestLoaded.snapshot;

  DocumentSnapshot get rapidAntigenDoc =>
      widget.rapidTestAntigenLoaded.snapshot;

  DocumentSnapshot get pcrIndividuDoc => widget.pcrTestIndividuLoaded.snapshot;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.13 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.animatedAppBar(
          title: Dictionary.statistics, showTitle: _showTitle),
      body: SingleChildScrollView(
          controller: _scrollController, child: _buildContent()),
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
        firebaseConfig: FirebaseConfig.bottomSheetContent,
        defaultValue:
            FirebaseConfig.bottomSheetDefaultValue)['statistics_bottom_sheet'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
            child: AnimatedOpacity(
              opacity: _showTitle ? 0.0 : 1.0,
              duration: Duration(milliseconds: 250),
              child: Text(
                Dictionary.statistics,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Text(
                  unixTimeStampToDateTimeWithoutDay(
                      statisticsDoc['updated_at'].seconds),
                  style: TextStyle(
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.roboto,
                      fontSize: 10.0),
                ),
                const SizedBox(height: Dimens.padding),
                _buildConfirmedBox(
                    label: labels['statistics']['confirmed'],
                    caseTotal: '${statisticsDoc['aktif']['jabar']}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: Dimens.padding,
                bottom: Dimens.padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContainerOne(
                    '${Environment.iconAssets}circle_plus_yellow.png',
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
                    '${Environment.iconAssets}circle_check_green.png',
                    labels['statistics']['recovered'],
                    '${statisticsDoc['sembuh']['jabar']}',
                    getDataProcessPercent(statisticsDoc['aktif']['jabar'],
                        statisticsDoc['sembuh']['jabar'])),
                _buildContainerOne(
                    '${Environment.iconAssets}circle_cross_red.png',
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
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
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
            margin: const EdgeInsets.all(Dimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    formattedStringNumber(caseTotal),
                    style: TextStyle(
                        fontFamily: FontsFamily.roboto,
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
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
            color: Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 5.0),
                child: image != ''
                    ? Image.asset(
                        image,
                        height: 15.0,
                      )
                    : null),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 5.0),
              child: Text(title,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.roboto)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 5.0),
              child: Text(count,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: ColorBase.veryDarkGrey,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            ),
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
      padding: const EdgeInsets.all(Dimens.padding),
      margin: const EdgeInsets.only(
          left: Dimens.contentPadding,
          right: Dimens.contentPadding,
          bottom: Dimens.padding),
      decoration: BoxDecoration(
          color: Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mainTitle,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: ColorBase.veryDarkGrey,
                      fontFamily: FontsFamily.roboto)),
              GestureDetector(
                onTap: mainTitleHelpOnTap,
                child: SizedBox(
                  width: 20,
                  child: Icon(Icons.help_outline,
                      size: 13.0, color: ColorBase.darkGrey),
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Text(mainCount,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16.0,
                    color: ColorBase.veryDarkGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: Dimens.padding),
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
                            fontFamily: FontsFamily.roboto)),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(secondCount,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: ColorBase.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
                    ),
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
                                fontFamily: FontsFamily.roboto)),
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
                      margin: const EdgeInsets.only(top: 10),
                      child: Text(thirdCount,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: ColorBase.darkGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
                    ),
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
                                      fontFamily: FontsFamily.roboto)),
                              const SizedBox(width: 5.0),
                              fourthTitleHelpOnTap != null
                                  ? GestureDetector(
                                      onTap: fourthTitleHelpOnTap,
                                      child: SizedBox(
                                        width: 20,
                                        child: Icon(Icons.help_outline,
                                            size: 13.0,
                                            color: ColorBase.darkGrey),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(fourthCount ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: ColorBase.darkGrey,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontsFamily.roboto)),
                          ),
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
    final String count = formattedStringNumber(
        '${rapidDoc['total'] + pcrDoc['total'] + rapidAntigenDoc['total'] + pcrIndividuDoc['total']}');

    return InkWell(
      onTap: () {
        AnalyticsHelper.setLogEvent(Analytics.tappedTotalInspectionCovid);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RapidTestDetail(
                    remoteConfig: remoteConfig,
                    document: rapidDoc,
                    documentPCR: pcrDoc,
                    documentPCRIndividu: pcrIndividuDoc,
                    documentRdtAntigen: rapidAntigenDoc,
                  )),
        );
      },
      child: Card(
        elevation: 0,
        color: Color(0xffFAFAFA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(Dictionary.testSummaryTitle,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: ColorBase.veryDarkGrey,
                            fontFamily: FontsFamily.roboto)),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
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
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: ColorBase.netralGrey,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
