import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class RapidTestDetail extends StatefulWidget {
  final RemoteConfig remoteConfig;
  final DocumentSnapshot document, documentPCR;

  RapidTestDetail(this.remoteConfig, this.document, this.documentPCR);

  @override
  _RapidTestDetailState createState() => _RapidTestDetailState();
}

class _RapidTestDetailState extends State<RapidTestDetail> {
  List<dynamic> dataAnnouncement;
  final formatter = new NumberFormat("#,###");
  List<String> listItemTitleTab = [Dictionary.rdt, Dictionary.pcr];
  Map<String, dynamic> label;
  Map<String, dynamic> helpBottomSheet;

  @override
  Widget build(BuildContext context) {
    if (widget.remoteConfig != null) {
      dataAnnouncement = json
          .decode(widget.remoteConfig.getString(FirebaseConfig.rapidTestInfo));

      // Get label from the remote config
      label = RemoteConfigHelper.decode(
          remoteConfig: widget.remoteConfig,
          firebaseConfig: FirebaseConfig.labels,
          defaultValue: FirebaseConfig.labelsDefaultValue);

      // Get bottom sheet config from the remote config
      helpBottomSheet = RemoteConfigHelper.decode(
          remoteConfig: widget.remoteConfig,
          firebaseConfig: FirebaseConfig.bottomSheetContent,
          defaultValue: FirebaseConfig.bottomSheetDefaultValue);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.defaultAppBar(
        title: Dictionary.testSummaryTitleAppbar,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        // Tab section
        child: CustomBubbleTab(
          indicatorColor: ColorBase.green,
          labelColor: Colors.white,
          listItemTitleTab: listItemTitleTab,
          unselectedLabelColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              AnalyticsHelper.setLogEvent(Analytics.tappedRDT);
            } else if (index == 1) {
              AnalyticsHelper.setLogEvent(Analytics.tappedPCR);
            }
          },
          tabBarView: <Widget>[_buildRDT(), _buildPCR()],
          isExpand: true,
        ),
      ),
    );
  }

  // Function to build RDT Screen
  Widget _buildRDT() {
    return ListView(
      children: <Widget>[
        // Announcement section
        widget.remoteConfig != null && dataAnnouncement[0]['enabled'] == true
            ? buildAnnouncement(0)
            : Container(),
        SizedBox(
          height: 20,
        ),
        // Last update section
        widget.document.data['last_update'] == null
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Dictionary.lastUpdate,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.lato,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${unixTimeStampToDateTime(widget.document.data['last_update'].seconds)}',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontFamily: FontsFamily.lato,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
        buildHeader(label['pcr_rdt']['rdt']['sum'], 'bloodTest@4x.png',
            widget.document.data['total'], Color(0xffFAFAFA)),
        SizedBox(
          height: 15,
        ),
        buildDetailRDT(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // Function to build PCR Screen
  Widget _buildPCR() {
    return ListView(
      children: <Widget>[
        widget.remoteConfig != null && dataAnnouncement[1]['enabled'] == true
            ? buildAnnouncement(1)
            : Container(),
        SizedBox(
          height: 20,
        ),
        widget.documentPCR.data['last_update'] == null
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: 20, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Dictionary.lastUpdate,
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.lato,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${unixTimeStampToDateTime(widget.documentPCR.data['last_update'].seconds)}',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontFamily: FontsFamily.lato,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
        buildHeader(label['pcr_rdt']['pcr']['sum'], 'bloodTestBlue@4x.png',
            widget.documentPCR.data['total'], Color(0xffFAFAFA)),
        SizedBox(
          height: 15,
        ),
        buildDetailPCR(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement(int i) {
    return Announcement(
      title: dataAnnouncement[i]['title'] != null
          ? dataAnnouncement[i]['title']
          : Dictionary.titleInfoTextAnnouncement,
      content: dataAnnouncement[i]['content'],
      context: context,
      onLinkTap: (url) {
        _launchURL(
            url,
            dataAnnouncement[i]['title'] != null
                ? dataAnnouncement[i]['title']
                : Dictionary.titleInfoTextAnnouncement);
      },
    );
  }

  Widget buildHeader(String title, image, int total, Color color) {
    String count =
        formatter.format(int.parse(total.toString())).replaceAll(',', '.');
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                height: 60,
                child: Image.asset('${Environment.imageAssets}$image')),
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
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.lato)),
                ),
                Container(
                  margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                  child: Text(count,
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.roboto)),
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
          label['pcr_rdt']['rdt']['positif'],
          widget.document.data['positif'].toString(),
          2,
          Colors.black,
          Colors.black,
          widget.document.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['rdt_bottom_sheet']['reaktif']['title'],
                message: helpBottomSheet['rdt_bottom_sheet']['reaktif']
                    ['message']);
          },
        ),
        buildContainer(
          '',
          label['pcr_rdt']['rdt']['negatif'],
          widget.document.data['negatif'].toString(),
          2,
          Colors.black,
          Colors.black,
          widget.document.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['rdt_bottom_sheet']['non-reaktif']
                    ['title'],
                message: helpBottomSheet['rdt_bottom_sheet']['non-reaktif']
                    ['message']);
          },
        ),
        buildContainer(
          '',
          label['pcr_rdt']['rdt']['invalid'],
          widget.document.data['invalid'].toString(),
          2,
          Colors.black,
          Colors.red,
          widget.document.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['rdt_bottom_sheet']['invalid']['title'],
                message: helpBottomSheet['rdt_bottom_sheet']['invalid']
                    ['message']);
          },
        )
      ],
    );
  }

  Widget buildDetailPCR() {
    return Row(
      children: <Widget>[
        buildContainer(
          '',
          label['pcr_rdt']['pcr']['positif'],
          widget.documentPCR.data['positif'].toString(),
          2,
          Colors.black,
          Colors.black,
          widget.documentPCR.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['pcr_bottom_sheet']['positif']['title'],
                message: helpBottomSheet['pcr_bottom_sheet']['positif']
                    ['message']);
          },
        ),
        buildContainer(
          '',
          label['pcr_rdt']['pcr']['negatif'],
          widget.documentPCR.data['negatif'].toString(),
          2,
          Colors.black,
          Colors.black,
          widget.documentPCR.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['pcr_bottom_sheet']['negatif']['title'],
                message: helpBottomSheet['pcr_bottom_sheet']['negatif']
                    ['message']);
          },
        ),
        buildContainer(
          '',
          label['pcr_rdt']['pcr']['invalid'],
          widget.documentPCR.data['invalid'].toString(),
          2,
          Colors.black,
          Colors.red,
          widget.documentPCR.data['total'],
          helpOnTap: () {
            showTextBottomSheet(
                context: context,
                title: helpBottomSheet['pcr_bottom_sheet']['inkonklusif']
                    ['title'],
                message: helpBottomSheet['pcr_bottom_sheet']['inkonklusif']
                    ['message']);
          },
        ),
      ],
    );
  }

  buildContainer(String image, String title, String count, int length,
      Color colorTextTitle, Color colorNumber, int total,
      {GestureTapCallback helpOnTap}) {
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
            color: Color(0xffFAFAFA),
            image: image != '' && image != null
                ? DecorationImage(fit: BoxFit.fill, image: AssetImage(image))
                : null,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      child: Wrap(
                        children: [
                          Text(title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: colorTextTitle,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.lato)),
                          helpOnTap != null
                              ? GestureDetector(
                                  onTap: helpOnTap,
                                  child: SizedBox(
                                    width: 20,
                                    child: Icon(Icons.help_outline,
                                        size: 13.0, color: ColorBase.darkGrey),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin:
                  EdgeInsets.only(top: Dimens.padding, bottom: Dimens.padding),
              child: Text(countFormatted,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: colorNumber,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.lato)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Container(
                      child: Text('(${percent.toStringAsFixed(2)})%',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.lato)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url, String title) async {
    List<String> items = [
      '_googleIDToken_',
      '_userUID_',
      '_userName_',
      '_userEmail_'
    ];
    String analyticsUrl;
    if (title != null) {
      analyticsUrl = 'tapped_url_' + title.replaceAll(" ", "_");
    } else {
      analyticsUrl = Analytics.tappedRappidTestUrl;
    }
    if (StringUtils.containsWords(url, items)) {
      bool hasToken = await AuthRepository().hasToken();
      if (!hasToken) {
        bool isLoggedIn = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));

        if (isLoggedIn != null && isLoggedIn) {
          url = await userDataUrlAppend(url);
          AnalyticsHelper.setLogEvent(analyticsUrl);
          openChromeSafariBrowser(url: url);
        }
      } else {
        url = await userDataUrlAppend(url);
        AnalyticsHelper.setLogEvent(analyticsUrl);
        openChromeSafariBrowser(url: url);
      }
    } else {
      AnalyticsHelper.setLogEvent(analyticsUrl);
      openChromeSafariBrowser(url: url);
    }
  }
}
