import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/rapidTest/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/RapidTestRepository.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class Statistics extends StatefulWidget {

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, state) {
        return state is RemoteConfigLoaded
            ? _buildStatistics(state.remoteConfig)
            : Container();
      },
    );
  }

  _buildStatistics(RemoteConfig remoteConfig) {
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
          new StreamBuilder(
              stream: Firestore.instance
                  .collection(Collections.statistics)
                  .document('jabar-dan-nasional')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoading();
                } else {
                  var userDocument = snapshot.data;
                  return _buildContent(userDocument);
                }
              }),
          SizedBox(
            height: 20,
          ),
          remoteConfig.getBool(FirebaseConfig.rapidTestEnable)?
          StreamBuilder(
              stream: Firestore.instance
                  .collection(Collections.statistics)
                  .document('rdt')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildLoadingRapidTest();
                } else {
                  var userDocument = snapshot.data;
                  return buildContentRapidTest(userDocument, remoteConfig);
                }
              }):Container()
        ],
      ),
    );
  }

  _buildLoading() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer('', Dictionary.positif, Dictionary.positif, '-',
                    3, Dictionary.people, Colors.grey[600], Colors.grey[600]),
                _buildContainer('', Dictionary.recover, Dictionary.recover, '-',
                    3, Dictionary.people, Colors.grey[600], Colors.grey[600]),
                _buildContainer('', Dictionary.die, Dictionary.die, '-', 3,
                    Dictionary.people, Colors.grey[600], Colors.grey[600]),
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
                    Colors.grey[600]),
                _buildContainer(
                    '',
                    Dictionary.inMonitoring,
                    Dictionary.inMonitoring,
                    '-',
                    2,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600]),
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
              Text(
                unixTimeStampToDateTimeWithoutDay(data['updated_at'].seconds),
                style: TextStyle(
                    color: Colors.grey[650],
                    fontFamily: FontsFamily.productSans,
                    fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.imageAssets}bg-positif.png',
                  Dictionary.positif,
                  Dictionary.positif,
                  '${data['aktif']['jabar']}',
                  3,
                  Dictionary.people,
                  Colors.white,
                  Colors.white),
              _buildContainer(
                  '${Environment.imageAssets}bg-sembuh.png',
                  Dictionary.recover,
                  Dictionary.recover,
                  '${data['sembuh']['jabar']}',
                  3,
                  Dictionary.people,
                  Colors.white,
                  Colors.white),
              _buildContainer(
                  '${Environment.imageAssets}bg-meninggal.png',
                  Dictionary.die,
                  Dictionary.die,
                  '${data['meninggal']['jabar']}',
                  3,
                  Dictionary.people,
                  Colors.white,
                  Colors.white),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '',
                  Dictionary.inMonitoring,
                  Dictionary.opdDesc,
                  getDataProcess(data['odp']['total']['jabar'],
                      data['odp']['selesai']['jabar']),
                  2,
                  /*getDataProcessPercent(data['odp']['total']['jabar'],
                      data['odp']['selesai']['jabar']),*/
                  Dictionary.people,
                  Colors.grey[600],
                  ColorBase.green),
              _buildContainer(
                  '',
                  Dictionary.underSupervision,
                  Dictionary.pdpDesc,
                  getDataProcess(data['pdp']['total']['jabar'],
                      data['pdp']['selesai']['jabar']),
                  2,
                  /*getDataProcessPercent(data['pdp']['total']['jabar'],
                      data['pdp']['selesai']['jabar']),*/
                  Dictionary.people,
                  Colors.grey[600],
                  ColorBase.green),
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
                child:
                    Image.asset('${Environment.imageAssets}rapid_test.png')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Skeleton(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(Dictionary.rapidTestTitle,
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

  Widget buildContentRapidTest(DocumentSnapshot document, RemoteConfig remoteConfig) {
    String count = formatter
        .format(document.data['total'])
        .replaceAll(',', '.');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RapidTestDetail(
                    remoteConfig,document
                  )),
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
                  child: Image.asset(
                      '${Environment.imageAssets}rapid_test.png')),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(Dictionary.rapidTestTitle,
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

  _buildContainer(String image, String title, String description, String count,
      int length, String label, Color colorTextTitle, Color colorNumber) {
    if (count != null && count.isNotEmpty && count != '-') {
      try {
        count = formatter.format(int.parse(count)).replaceAll(',', '.');
      } catch (e) {
        print(e.toString());
      }
    }

    return Expanded(
      child: InkWell(
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          decoration: BoxDecoration(
              image: image != '' && image != null
                  ? DecorationImage(fit: BoxFit.fill, image: AssetImage(image))
                  : null,
              border: image == null || image == ''
                  ? Border.all(color: Colors.grey[400])
                  : null,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: colorTextTitle,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              ),
              Container(
                margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                child: Text(count,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: colorNumber,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              )
            ],
          ),
        ),
        onTap: () {
          openChromeSafariBrowser(url: UrlThirdParty.urlCoronaInfo);
        },
      ),
    );
  }
}
