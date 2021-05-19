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
  final DocumentSnapshot document,
      documentPCR,
      documentRdtAntigen,
      documentPCRIndividu;

  RapidTestDetail(
      {Key key,
      this.remoteConfig,
      this.document,
      this.documentPCR,
      this.documentRdtAntigen,
      this.documentPCRIndividu})
      : super(key: key);

  @override
  _RapidTestDetailState createState() => _RapidTestDetailState();
}

class _RapidTestDetailState extends State<RapidTestDetail> {
  ScrollController _scrollController;
  List<dynamic> dataAnnouncement;
  final formatter = new NumberFormat("#,###");
  List<String> listItemTitleTab = [
    Dictionary.rdtAntibodi,
    Dictionary.rdtAntigen,
    Dictionary.pcrSpesimen,
    Dictionary.pcrNewCase
  ];
  Map<String, dynamic> label;
  Map<String, dynamic> helpBottomSheet;
  String lastUpdate;

  @override
  void initState() {
    super.initState();
    lastUpdate =
        unixTimeStampToDate(widget.document.get('last_update').seconds);
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
        subTitle: lastUpdate,
        showTitle: _showTitle,
        scrollController: _scrollController,
        indicatorColor: ColorBase.green,
        labelColor: Colors.white,
        listItemTitleTab: listItemTitleTab,
        unselectedLabelColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            setState(() {
              lastUpdate = unixTimeStampToDate(
                  widget.document.get('last_update').seconds);
            });
            AnalyticsHelper.setLogEvent(Analytics.tappedRDT);
          } else if (index == 1) {
            setState(() {
              lastUpdate = unixTimeStampToDate(
                  widget.documentRdtAntigen.get('last_update').seconds);
            });
            AnalyticsHelper.setLogEvent(Analytics.tappedRDTAntigen);
          } else if (index == 2) {
            setState(() {
              lastUpdate = unixTimeStampToDate(
                  widget.documentPCR.get('last_update').seconds);
            });
            AnalyticsHelper.setLogEvent(Analytics.tappedPCR);
          } else if (index == 3) {
            setState(() {
              lastUpdate = unixTimeStampToDate(
                  widget.documentPCRIndividu.get('last_update').seconds);
            });
            AnalyticsHelper.setLogEvent(Analytics.tappedPCRNewCase);
          }
        },
        tabBarView: <Widget>[
          _buildContent(
              titleHeader: label['pcr_rdt']['rdt_antibodi']['sum'],
              total: widget.document.get('total'),
              announcementArray: 0),
          _buildContent(
              titleHeader: label['pcr_rdt']['rdt_antigen']['sum'],
              total: widget.documentRdtAntigen.get('total'),
              announcementArray: 1),
          _buildContent(
              titleHeader: label['pcr_rdt']['pcr_spesimen']['sum'],
              total: widget.documentPCR.get('total'),
              announcementArray: 2),
          _buildContent(
              titleHeader: label['pcr_rdt']['pcr_kasus_baru']['sum'],
              total: widget.documentPCRIndividu.get('total'),
              announcementArray: 3),
        ],
        isExpand: true,
      ),
    );
  }

  // Function to build content
  Widget _buildContent({String titleHeader, int total, announcementArray}) {
    Widget detailContent;
    switch (announcementArray) {
      case 0:
        detailContent = buildDetailRDTAntibodi();
        break;
      case 1:
        detailContent = buildDetailRDTAntigen();
        break;
      case 2:
        detailContent = buildDetailPCRSpesimen();
        break;
      case 3:
        detailContent = buildDetailPCRIndividu();
        break;
      default:
        detailContent = buildDetailRDTAntibodi();
    }
    return ListView(
      children: <Widget>[
        // Announcement section
        widget.remoteConfig != null &&
                dataAnnouncement[announcementArray]['enabled'] == true
            ? buildAnnouncement(announcementArray)
            : Container(),
        const SizedBox(
          height: 20,
        ),
        buildHeader(titleHeader, total, Color(0xffFAFAFA)),
        const SizedBox(
          height: 15,
        ),
        detailContent,
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement(int i) {
    return Announcement(
        margin: EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
        content: dataAnnouncement[i]['content'],
        context: context,
        onLinkTap: (url) {
          _launchURL(
            url,
            dataAnnouncement[i]['title'] != null
                ? dataAnnouncement[i]['title']
                : Dictionary.titleInfoTextAnnouncement,
          );
        });
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
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto)),
            Container(
              margin: const EdgeInsets.only(top: Dimens.padding),
              child: Text(count,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailRDTAntibodi() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['rdt_antibodi']['positif'],
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
            label['pcr_rdt']['rdt_antibodi']['negatif'],
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
            label['pcr_rdt']['rdt_antibodi']['invalid'],
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

  Widget buildDetailRDTAntigen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['rdt_antigen']['positif'],
            widget.documentRdtAntigen.get('positif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentRdtAntigen.get('total'),
          ),
          buildContainer(
            '',
            label['pcr_rdt']['rdt_antigen']['negatif'],
            widget.documentRdtAntigen.get('negatif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentRdtAntigen.get('total'),
          ),
        ],
      ),
    );
  }

  Widget buildDetailPCRSpesimen() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['pcr_spesimen']['positif'],
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
            label['pcr_rdt']['pcr_spesimen']['negatif'],
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
            label['pcr_rdt']['pcr_spesimen']['invalid'],
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

  Widget buildDetailPCRIndividu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          buildContainer(
            '',
            label['pcr_rdt']['pcr_spesimen']['positif'],
            widget.documentPCRIndividu.get('positif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentPCRIndividu.get('total'),
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
            label['pcr_rdt']['pcr_spesimen']['negatif'],
            widget.documentPCRIndividu.get('negatif').toString(),
            2,
            Colors.black,
            Colors.black,
            widget.documentPCRIndividu.get('total'),
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
            label['pcr_rdt']['pcr_spesimen']['invalid'],
            widget.documentPCRIndividu.get('invalid').toString(),
            2,
            Colors.black,
            Colors.red,
            widget.documentPCRIndividu.get('total'),
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
        padding: const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: Color(0xffFAFAFA),
            image: image != '' && image != null
                ? DecorationImage(fit: BoxFit.fill, image: AssetImage(image))
                : null,
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Wrap(
                        children: [
                          Text(title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colorTextTitle,
                                  fontFamily: FontsFamily.roboto)),
                          helpOnTap != null
                              ? GestureDetector(
                                  onTap: helpOnTap,
                                  child: SizedBox(
                                    width: 20,
                                    child: Icon(Icons.help_outline,
                                        size: 13, color: ColorBase.darkGrey),
                                  ),
                                )
                              : SizedBox()
                        ],
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
                        fontSize: 16,
                        color: colorNumber,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('(${percent.toStringAsFixed(2)})%',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 10,
                              color: ColorBase.netralGrey,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.roboto)),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
