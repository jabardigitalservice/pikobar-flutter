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
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
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
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0.0, 1),
            blurRadius: 4.0),
      ]),
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
            ? _buildContent(state.snapshot)
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
                  fontFamily: FontsFamily.productSans,
                  fontSize: 16.0),
            ),
            SizedBox(height: Dimens.padding),
            SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer(
                    '',
                    Dictionary.positif,
                    Dictionary.positif,
                    '-',
                    3,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer(
                    '',
                    Dictionary.recover,
                    Dictionary.recover,
                    '-',
                    3,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer('', Dictionary.die, Dictionary.die, '-', 3,
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

  Container _buildContent(DocumentSnapshot data) {
    if (!data.exists)
      return Container(
        child: Center(
          child: Text(Dictionary.errorStatisticsNotExists),
        ),
      );

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
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.productSans,
                    fontSize: 16.0),
              ),
              InkWell(onTap: (){
                openChromeSafariBrowser(
              url: urlStatistic.isNotEmpty
                  ? urlStatistic
                  : UrlThirdParty.urlCoronaInfoData);
              },
                child: Text(
                  Dictionary.moreDetail,
                  style: TextStyle(
                      color: Color(0xff27AE60),
                      fontFamily: FontsFamily.productSans,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(
            unixTimeStampToDateTimeWithoutDay(data['updated_at'].seconds),
            style: TextStyle(
                color: Color(0xff828282),
                fontFamily: FontsFamily.productSans,
                fontSize: 12.0),
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}virusRed.png',
                  Dictionary.positif,
                  Dictionary.positif,
                  '${data['aktif']['jabar']}',
                  3,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xffEB5757),
                  ''),
              _buildContainer(
                  '${Environment.iconAssets}virusGreen.png',
                  Dictionary.recover,
                  Dictionary.recover,
                  '${data['sembuh']['jabar']}',
                  3,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xff27AE60),
                  ''),
              _buildContainer(
                  '${Environment.iconAssets}virusYellow.png',
                  Dictionary.die,
                  Dictionary.die,
                  '${data['meninggal']['jabar']}',
                  3,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xffFFCC29),
                  ''),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '',
                  Dictionary.odp,
                  Dictionary.opdDesc,
                  getDataProcess(data['odp']['total']['jabar'],
                      data['odp']['selesai']['jabar']),
                  2,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xffF2994A),
                  data['odp']['total']['jabar'].toString()),
              _buildContainer(
                  '',
                  Dictionary.pdp,
                  Dictionary.pdpDesc,
                  getDataProcess(data['pdp']['total']['jabar'],
                      data['pdp']['selesai']['jabar']),
                  2,
                  Dictionary.people,
                  Color(0xff828282),
                  Color(0xffF2994A),
                  data['pdp']['total']['jabar'].toString()),
            ],
          )
        ],
      ),
    );
  }

  Widget buildLoadingRapidTest() {
    return Card(
      color: Color(0xff27AE60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                height: 60,
                child: Image.asset('${Environment.imageAssets}rapid_test.png')),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                ),
                Skeleton(
                  child: Container(
                    margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                    child: Text('0',
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
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
        color: Color(0xff27AE60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                  height: 60,
                  child:
                      Image.asset('${Environment.imageAssets}rapid_test.png')),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                    child: Text(count,
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.white,
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
      String total) {
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
          margin: EdgeInsets.symmetric(horizontal: 10),
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
                              fontFamily: FontsFamily.productSans)),
                    )
                  : Container(height: 15, child: Image.asset(image)),
              Container(
                margin: EdgeInsets.only(top: 10, left: 5.0),
                child: Text(count,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: colorNumber,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              ),
              total == ''
                  ? Container(
                      margin: EdgeInsets.only(top: 10, left: 5.0),
                      child: Text(title,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: colorTextTitle,
                              fontFamily: FontsFamily.productSans)),
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10, left: 5.0),
                      child: Text(Dictionary.textSum + total,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: colorTextTitle,
                              fontFamily: FontsFamily.productSans)),
                    )
            ],
          ),
        ),
        onTap: () {
          
        },
      ),
    );
  }
}
