import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/rapidTest/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class RapidTestDetail extends StatefulWidget {
  final RemoteConfig remoteConfig;
  final DocumentSnapshot document, documentPCR;

  RapidTestDetail(this.remoteConfig, this.document, this.documentPCR);
  @override
  _RapidTestDetailState createState() => _RapidTestDetailState();
}

class _RapidTestDetailState extends State<RapidTestDetail> {
  Map<String, dynamic> dataAnnouncement;
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    if (widget.remoteConfig != null) {
      dataAnnouncement = json
          .decode(widget.remoteConfig.getString(FirebaseConfig.rapidTestInfo));
    }
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: Dictionary.testSummaryTitleAppbar,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        children: <Widget>[
          buildHeader(Dictionary.rapidTestTitle, widget.document.data['total'],
              Color(0xff27AE60)),
          SizedBox(
            height: 15,
          ),
          buildDetailRDT(),
          SizedBox(
            height: 20,
          ),
          buildHeader(Dictionary.pcrTitle, widget.documentPCR.data['total'],
              Color(0xff2D9CDB)),
          SizedBox(
            height: 15,
          ),
          buildDetailPCR(),
          SizedBox(
            height: 20,
          ),
          widget.remoteConfig != null && dataAnnouncement['enabled'] == true
              ? buildAnnouncement()
              : Container(),
          SizedBox(
            height: 20,
          ),
          // widget.document.data['last_update'] == null
          //     ? Container()
          //     : Center(
          //         child: Text(
          //           '${Dictionary.lastUpdate} ${unixTimeStampToDateTimeWithoutDay(widget.document.data['last_update'].seconds)}',
          //           style: TextStyle(
          //               color: Color(0xff828282),
          //               fontWeight: FontWeight.bold,
          //               fontSize: 16),
          //         ),
          //       )
        ],
      ),
    );
  }

  Widget buildAnnouncement() {
    return Container(
        width: (MediaQuery.of(context).size.width),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(left: 5, right: 5),
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
            SizedBox(height: 15),
            RichText(
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
              ]),
            ),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: dataAnnouncement['content_pcr'] != null
                      ? dataAnnouncement['content_pcr']
                      : Dictionary.infoTextAnnouncement,
                  style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[600],
                      fontFamily: FontsFamily.productSans),
                ),
                dataAnnouncement['action_url'].toString().isNotEmpty
                    ? TextSpan(
                    text: Dictionary.moreDetailRapidTest,
                    style: TextStyle(
                        color: ColorBase.green,
                        fontFamily: FontsFamily.productSans,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (widget.remoteConfig != null &&
                            widget.remoteConfig.getString(
                                FirebaseConfig.loginRequired) !=
                                null) {
                          Map<String, dynamic> _loginRequiredMenu =
                          json.decode(widget.remoteConfig
                              .getString(
                              FirebaseConfig.loginRequired));

                          if (_loginRequiredMenu['rdt_menu']) {
                            bool hasToken =
                            await AuthRepository().hasToken();
                            if (!hasToken) {
                              bool isLoggedIn = await Navigator.of(
                                  context)
                                  .push(MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(
                                          title: Dictionary
                                              .rapidTestAppBar)));

                              if (isLoggedIn != null && isLoggedIn) {
                                var url = await userDataUrlAppend(
                                    dataAnnouncement['action_url']);
                                openChromeSafariBrowser(url: url);
                              }
                            } else {
                              var url = await userDataUrlAppend(
                                  dataAnnouncement['action_url']);
                              openChromeSafariBrowser(url: url);
                            }
                          } else {
                            openChromeSafariBrowser(
                                url: dataAnnouncement['action_url']);
                          }
                        }
                      })
                    : TextSpan(text: ''),
              ]),
            ),
          ],
        ));
  }

  Widget buildHeader(String title, int total, Color color) {
    String count =
        formatter.format(int.parse(total.toString())).replaceAll(',', '.');
    return Card(
      color: color,
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
                Container(
                  margin: EdgeInsets.only(left: 5.0),
                  child: Text(title,
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
              color: color,
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailRDT() {
    return Row(
      children: <Widget>[
        buildContainer(
            '',
            Dictionary.reaktif,
            widget.document.data['positif'].toString(),
            2,
            Colors.grey[600],
            ColorBase.green,
            widget.document.data['total']),
        buildContainer(
            '',
            Dictionary.nonReaktif,
            widget.document.data['negatif'].toString(),
            2,
            Colors.grey[600],
            ColorBase.green,
            widget.document.data['total']),
        buildContainer(
            '',
            Dictionary.invalid,
            widget.document.data['invalid'].toString(),
            2,
            Colors.grey[600],
            ColorBase.green,
            widget.document.data['total'])
      ],
    );
  }

  Widget buildDetailPCR() {
    return Row(
      children: <Widget>[
        buildContainer(
            '',
            Dictionary.positifText,
            widget.documentPCR.data['positif'].toString(),
            2,
            Colors.grey[600],
            ColorBase.green,
            widget.documentPCR.data['total']),
        buildContainer(
            '',
            Dictionary.negatifText,
            widget.documentPCR.data['negatif'].toString(),
            2,
            Colors.grey[600],
            ColorBase.green,
            widget.documentPCR.data['total']),
      ],
    );
  }

  buildContainer(String image, String title, String count, int length,
      Color colorTextTitle, Color colorNumber, int total) {
    var countFormatted;
    if (count != null && count.isNotEmpty && count != '-') {
      try {
        countFormatted =
            formatter.format(int.parse(count)).replaceAll(',', '.');
      } catch (e) {
        print(e.toString());
      }
    }
    var percent = (int.parse(count) / total) * 100;

    return Expanded(
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
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: colorTextTitle,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                  child: Text(countFormatted,
                      style: TextStyle(
                          fontSize: 22.0,
                          color: colorNumber,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.productSans)),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text('(${percent.toStringAsFixed(2)})%',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: colorTextTitle,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
