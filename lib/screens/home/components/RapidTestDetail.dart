import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
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

  RapidTestDetail({Key key, this.remoteConfig, this.document, this.documentPCR})
      : super(key: key);

  @override
  _RapidTestDetailState createState() => _RapidTestDetailState();
}

class _RapidTestDetailState extends State<RapidTestDetail> {
  ScrollController _scrollController;
  List<dynamic> dataAnnouncement;
  final formatter = new NumberFormat("#,###");
  List<String> listItemTitleTab = [Dictionary.rdt, Dictionary.pcr];
  Map<String, dynamic> label;
  Map<String, dynamic> helpBottomSheet;

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
      body: CustomBubbleTab(
        isStickyHeader: true,
        titleHeader: Dictionary.testSummaryTitleAppbar,
        subTitle:
            unixTimeStampToDate(widget.document.get('last_update').seconds),
        showTitle: _showTitle,
        scrollController: _scrollController,
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
        const SizedBox(
          height: 20,
        ),
        buildHeader(label['pcr_rdt']['rdt']['sum'],
            widget.document.get('total'), Color(0xffFAFAFA)),
        const SizedBox(
          height: 15,
        ),
        buildDetailRDT(),
        const SizedBox(
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
        const SizedBox(
          height: 20,
        ),
        buildHeader(label['pcr_rdt']['pcr']['sum'],
            widget.documentPCR.get('total'), Color(0xffFAFAFA)),
        const SizedBox(
          height: 15,
        ),
        buildDetailPCR(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement(int i) {
    return Announcement(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
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

  Widget buildHeader(String title, int total, Color color) {
    String count =
        formatter.format(int.parse(total.toString())).replaceAll(',', '.');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto)),
            Container(
              margin: const EdgeInsets.only(top: Dimens.padding),
              child: Text(count,
                  style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailRDT() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['rdt']['positif'],
            widget.document.get('positif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.document.get('total'),
            helpOnTap: () {
              showTextBottomSheet(
                  context: context,
                  title: helpBottomSheet['rdt_bottom_sheet']['reaktif']
                      ['title'],
                  message: helpBottomSheet['rdt_bottom_sheet']['reaktif']
                      ['message']);
            },
          ),
          buildContainer(
            '',
            label['pcr_rdt']['rdt']['negatif'],
            widget.document.get('negatif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.document.get('total'),
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
            widget.document.get('invalid').toString(),
            2,
            Colors.black,
            Colors.red,
            widget.document.get('total'),
            helpOnTap: () {
              showTextBottomSheet(
                  context: context,
                  title: helpBottomSheet['rdt_bottom_sheet']['invalid']
                      ['title'],
                  message: helpBottomSheet['rdt_bottom_sheet']['invalid']
                      ['message']);
            },
          )
        ],
      ),
    );
  }

  Widget buildDetailPCR() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['pcr']['positif'],
            widget.documentPCR.get('positif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentPCR.get('total'),
            helpOnTap: () {
              showTextBottomSheet(
                  context: context,
                  title: helpBottomSheet['pcr_bottom_sheet']['positif']
                      ['title'],
                  message: helpBottomSheet['pcr_bottom_sheet']['positif']
                      ['message']);
            },
          ),
          buildContainer(
            '',
            label['pcr_rdt']['pcr']['negatif'],
            widget.documentPCR.get('negatif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentPCR.get('total'),
            helpOnTap: () {
              showTextBottomSheet(
                  context: context,
                  title: helpBottomSheet['pcr_bottom_sheet']['negatif']
                      ['title'],
                  message: helpBottomSheet['pcr_bottom_sheet']['negatif']
                      ['message']);
            },
          ),
          buildContainer(
            '',
            label['pcr_rdt']['pcr']['invalid'],
            widget.documentPCR.get('invalid').toString(),
            2,
            Colors.black,
            Colors.red,
            widget.documentPCR.get('total'),
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
      ),
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
        padding:
            const EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Color(0xffFAFAFA),
            image: image != '' && image != null
                ? DecorationImage(fit: BoxFit.fill, image: AssetImage(image))
                : null,
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
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
                                  fontFamily: FontsFamily.roboto)),
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
              margin: const EdgeInsets.only(
                  top: Dimens.padding, bottom: Dimens.padding),
              child: Text(countFormatted,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: colorNumber,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
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
                              color: ColorBase.netralGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
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
