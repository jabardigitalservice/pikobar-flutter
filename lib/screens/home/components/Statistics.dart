import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/GetLabelRemoteConfig.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final formatter = new NumberFormat("#,###");
  String urlStatistic = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildStatistics(),
          SizedBox(
            height: 20,
          ),
          _buildRapidTest()
        ],
      ),
    );
  }

  _buildStatistics() {
    return BlocBuilder<StatisticsBloc, StatisticsState>(
      builder: (context, state) {
        return state is StatisticsLoaded
            ? BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                builder: (context, remoteState) {
                  return remoteState is RemoteConfigLoaded
                      ? _buildContent(state.snapshot, remoteState.remoteConfig)
                      : _buildLoading();
                },
              )
            : _buildLoading();
      },
    );
  }

  _buildRapidTest() {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, remoteState) {
        return remoteState is RemoteConfigLoaded
            ? remoteState.remoteConfig.getBool(FirebaseConfig.rapidTestEnable)
                ? BlocBuilder<RapidTestBloc, RapidTestState>(
                    builder: (context, rapidState) {
                      urlStatistic = remoteState.remoteConfig
                          .getString(FirebaseConfig.pikobarUrl);
                      return rapidState is RapidTestLoaded
                          ? BlocBuilder<PcrTestBloc, PcrTestState>(
                              builder: (context, pcrState) {
                                return pcrState is PcrTestLoaded
                                    ? buildContentRapidTest(
                                        remoteState.remoteConfig,
                                        rapidState.snapshot,
                                        pcrState.snapshot)
                                    : buildLoadingRapidTest();
                              },
                            )
                          : buildLoadingRapidTest();
                    },
                  )
                : Container()
            : buildLoadingRapidTest();
      },
    );
  }

  _buildLoading() {
    return Container(
      color: Colors.white,
      child: Skeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Dictionary.statistics,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.lato,
                  fontSize: 16.0),
            ),
            SizedBox(height: Dimens.padding),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer(
                    '',
                    Dictionary.caseTotal,
                    Dictionary.caseTotal,
                    '-',
                    4,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer(
                    '',
                    Dictionary.positif,
                    Dictionary.positif,
                    '-',
                    4,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer(
                    '',
                    Dictionary.positif,
                    Dictionary.positif,
                    '-',
                    4,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer('', Dictionary.die, Dictionary.die, '-', 4,
                    Dictionary.people, Colors.grey[600], Colors.grey[600], ''),
              ],
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer(
                    '',
                    Dictionary.underSupervision,
                    Dictionary.underSupervision,
                    '-',
                    2,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer(
                    '',
                    Dictionary.inMonitoring,
                    Dictionary.inMonitoring,
                    '-',
                    2,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildContent(DocumentSnapshot data, RemoteConfig remoteConfig) {
    if (!data.exists)
      return Container(
        child: Center(
          child: Text(Dictionary.errorStatisticsNotExists),
        ),
      );

    // Get label from the remote config
    Map<String, dynamic> labelUpdateTerkini =
        GetLabelRemoteConfig.getLabel(remoteConfig);

    bool statisticsSwitch = getStatisticsSwitch(remoteConfig);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Dictionary.statistics,
                style: TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.lato,
                    fontSize: 16.0),
              ),
              InkWell(
                onTap: () {
                  openChromeSafariBrowser(
                      url: urlStatistic.isNotEmpty
                          ? urlStatistic
                          : kUrlCoronaInfoData);
                },
                child: Text(
                  Dictionary.moreDetail,
                  style: TextStyle(
                      color: Color(0xff27AE60),
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            unixTimeStampToDateTimeWithoutDay(data['updated_at'].seconds),
            style: TextStyle(
                color: Color(0xff333333),
                fontFamily: FontsFamily.lato,
                fontSize: 12.0),
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}virusPurple.png',
                  labelUpdateTerkini['statistics']['confirmed'],
                  labelUpdateTerkini['statistics']['confirmed'],
                  '${data['aktif']['jabar']}',
                  4,
                  Dictionary.people,
                  Color(0xff333333),
                  Color(0xff2C347C),
                  ''),
              _buildContainer(
                  '${Environment.iconAssets}virusRed.png',
                  labelUpdateTerkini['statistics']['positif'],
                  labelUpdateTerkini['statistics']['positif'],
                  getDataActivePositive(data['aktif']['jabar'],
                      data['sembuh']['jabar'], data['meninggal']['jabar']),
                  4,
                  Dictionary.people,
                  Color(0xff333333),
                  Color(0xffEB5757),
                  ''),
              _buildContainer(
                  '${Environment.iconAssets}virusGreen.png',
                  labelUpdateTerkini['statistics']['recovered'],
                  labelUpdateTerkini['statistics']['recovered'],
                  '${data['sembuh']['jabar']}',
                  4,
                  Dictionary.people,
                  Color(0xff333333),
                  Color(0xff27AE60),
                  ''),
              _buildContainer(
                  '${Environment.iconAssets}virusYellow.png',
                  labelUpdateTerkini['statistics']['deaths'],
                  labelUpdateTerkini['statistics']['deaths'],
                  '${data['meninggal']['jabar']}',
                  4,
                  Dictionary.people,
                  Color(0xff333333),
                  Color(0xffF2994A),
                  ''),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '',
                  labelUpdateTerkini['statistics']['odp'],
                  Dictionary.opdDesc,
                  statisticsSwitch
                      ? data['kontak_erat']['total'].toString()
                      : getDataProcess(data['odp']['total']['jabar'],
                          data['odp']['selesai']['jabar']),
                  2,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xff2F80ED),
                  statisticsSwitch
                      ? data['kontak_erat']['karantina'].toString()
                      : data['odp']['total']['jabar'].toString(),
                  detailText: labelUpdateTerkini['statistics']['odp_detail']),
              _buildContainer(
                  '',
                  labelUpdateTerkini['statistics']['pdp'],
                  Dictionary.pdpDesc,
                  statisticsSwitch
                      ? data['suspek']['total'].toString()
                      : getDataProcess(data['pdp']['total']['jabar'],
                          data['pdp']['selesai']['jabar']),
                  2,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xffF2C94C),
                  statisticsSwitch
                      ? data['suspek']['isolasi'].toString()
                      : data['pdp']['total']['jabar'].toString(),
                  detailText: labelUpdateTerkini['statistics']['pdp_detail']),
            ],
          )
        ],
      ),
    );
  }

  Widget buildLoadingRapidTest() {
    return Card(
      elevation: 0,
      color: Color(0xffFAFAFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                height: 60,
                child: Image.asset('${Environment.imageAssets}bloodTest.png')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Skeleton(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(Dictionary.testSummaryTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.lato)),
                  ),
                ),
                Skeleton(
                  child: Container(
                    margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                    child: Text('0',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto)),
                  ),
                )
              ],
            ),
            Skeleton(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContentRapidTest(RemoteConfig remoteConfig,
      DocumentSnapshot document, DocumentSnapshot documentPCR) {
    String count = formatter
        .format(document.data['total'] + documentPCR.data['total'])
        .replaceAll(',', '.');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RapidTestDetail(remoteConfig, document, documentPCR)),
        );
      },
      child: Card(
        elevation: 0,
        color: Color(0xffFAFAFA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  height: 60,
                  child: Image.asset(
                      '${Environment.imageAssets}bloodTest@4x.png')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(Dictionary.testSummaryTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.lato)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                    child: Text(count,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto)),
                  )
                ],
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

  String getDataProcess(int totalData, int dataDone) {
    int processData = totalData - dataDone;
    return processData.toString();
  }

  String getDataActivePositive(int totalData, int dataDone, int dataRecover) {
    int dataActivePositive = totalData - dataDone - dataRecover;
    return dataActivePositive.toString();
  }

  String getDataProcessPercent(int totalData, int dataDone) {
    double processData =
        100 - num.parse(((dataDone / totalData) * 100).toStringAsFixed(2));

    return '(' + processData.toString() + '%)';
  }

  _buildContainer(
      String image,
      String title,
      String description,
      String count,
      int length,
      String label,
      Color colorTextTitle,
      Color colorNumber,
      String total,
      {String detailText}) {
    if (count != null && count.isNotEmpty && count != '-') {
      try {
        count = formatter.format(int.parse(count)).replaceAll(',', '.');
      } catch (e) {
        print(e.toString());
      }
    }
    if (total != null && total.isNotEmpty && total != '-') {
      try {
        total = formatter.format(int.parse(total)).replaceAll(',', '.');
      } catch (e) {
        print(e.toString());
      }
    }

    return Expanded(
      child: InkWell(
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: Color(0xffFAFAFA),
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              image == ""
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 5.0),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: colorTextTitle,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.lato)),
                    )
                  : Container(height: 15, child: Image.asset(image)),
              Container(
                margin: EdgeInsets.only(top: 10, left: 5.0),
                child: Text(count,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: colorNumber,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              ),
              total == ''
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 1.0),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 9.0,
                              color: colorTextTitle,
                              fontFamily: FontsFamily.lato)),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10, left: 5.0),
                      child: Text(detailText + total,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff333333),
                              fontFamily: FontsFamily.lato)),
                    )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }

  bool getStatisticsSwitch(RemoteConfig remoteConfig) {
    if (remoteConfig != null &&
        remoteConfig.getBool(FirebaseConfig.statisticsSwitch) != null) {
      return remoteConfig.getBool(FirebaseConfig.statisticsSwitch);
    } else {
      return false;
    }
  }
}
