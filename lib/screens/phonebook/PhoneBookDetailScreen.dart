import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class PhoneBookDetail extends StatefulWidget {
  List<ReferralHospitalModel> documentReferralHospital;
  CallCenterModel documentCallCenterModel;
  GugusTugasWebModel documentGugusTugasWebModel;
  String nameModel, nameCity;

  PhoneBookDetail(
      {Key key,
      this.documentReferralHospital,
      this.documentCallCenterModel,
      this.documentGugusTugasWebModel,
      @required this.nameModel,
      @required this.nameCity})
      : super(key: key);

  @override
  _PhoneBookDetailState createState() => _PhoneBookDetailState();
}

class _PhoneBookDetailState extends State<PhoneBookDetail> {
  String appBarTitle;
  ScrollController _scrollController;

  @override
  void initState() {
    appBarTitle = widget.nameCity;
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.13 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.animatedAppBar(
            title: appBarTitle, showTitle: _showTitle),
        backgroundColor: Colors.white,
        body: ListView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              AnimatedOpacity(
                opacity: _showTitle ? 0.0 : 1.0,
                duration: Duration(milliseconds: 250),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    appBarTitle,
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              widget.nameModel == 'ReferralHospitalModel'
                  ? Column(
                      children: buildListContentRefferalHospital(
                          widget.documentReferralHospital),
                    )
                  : widget.nameModel == 'CallCenterModel'
                      ? buildCallCenter(widget.documentCallCenterModel)
                      : buildWebGugusTugas(widget.documentGugusTugasWebModel)
            ]));
  }
}

List<Widget> buildListContentRefferalHospital(
    List<ReferralHospitalModel> document) {
  List<Widget> list = List();
  for (var i = 0; i < document.length; i++) {
    Column column = Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              i == 0
                  ? Container()
                  : Divider(
                      color: ColorBase.greyBorder,
                      thickness: 1,
                    ),
              SizedBox(
                height: 20,
              ),
              document[i].name != null
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(document[i].name,
                          style: TextStyle(
                              fontFamily: FontsFamily.roboto,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    )
                  : Container(),
              document[i].address != null
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(document[i].address,
                          style: TextStyle(
                              color: ColorBase.netralGrey,
                              fontFamily: FontsFamily.roboto,
                              fontSize: 12)),
                    )
                  : Container(),
              document[i].phones != null && document[i].phones.isNotEmpty
                  ? Column(
                      children: _buildListDetailPhone(
                          document[i].phones, 'phones',
                          hasDivider: false),
                    )
                  : Container(),
              document[i].web != null && document[i].web.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: InkWell(
                        onTap: () {
                          _launchURL(document[i].web, 'web');

                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedphoneBookEmergencyWeb,
                              <String, dynamic>{
                                'title': document[i].name,
                                'web': document[i].web
                              });
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 15,
                                child: Image.asset(
                                    '${Environment.iconAssets}web_underline.png')),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                document[i].web,
                                style: TextStyle(
                                    color: ColorBase.dodgerBlue,
                                    fontFamily: FontsFamily.roboto,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          ))
    ]);

    list.add(column);
  }
  return list;
}

Widget buildCallCenter(CallCenterModel document) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        document.callCenter != null && document.callCenter.isNotEmpty
            ? Column(
                children:
                    _buildListDetailPhone(document.callCenter, 'call_center'),
              )
            : Container(),
        document.hotline != null && document.hotline.isNotEmpty
            ? Column(
                children: _buildListDetailPhone(document.hotline, 'hotline'),
              )
            : Container(),
      ],
    ),
  );
}

Widget buildWebGugusTugas(GugusTugasWebModel document) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        document.website != null && document.website.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: InkWell(
                  onTap: () {
                    _launchURL(document.website, 'web');

                    AnalyticsHelper.setLogEvent(
                        Analytics.tappedphoneBookEmergencyWeb,
                        <String, dynamic>{
                          'title': document.name,
                          'web': document.website
                        });
                  },
                  child: Row(
                    children: [
                      Container(
                          height: 15,
                          child: Image.asset(
                              '${Environment.iconAssets}web_underline.png')),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        document.website,
                        style: TextStyle(
                            color: ColorBase.dodgerBlue,
                            fontFamily: FontsFamily.roboto,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}

/// Build list of phone number
List<Widget> _buildListDetailPhone(List<dynamic> document, String name,
    {bool hasDivider = true}) {
  List<Widget> list = List();

  for (int i = 0; i < document.length; i++) {
    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: InkWell(
            onTap: () {
              _launchURL(document[i], 'number');

              AnalyticsHelper.setLogEvent(
                  Analytics.tappedphoneBookEmergencyTelp,
                  <String, dynamic>{'title': document, 'telp': document[i]});
            },
            child: Row(
              children: [
                Container(
                    height: 15,
                    child: Image.asset('${Environment.iconAssets}phone.png')),
                SizedBox(
                  width: 20,
                ),
                Text(
                  document[i],
                  style: TextStyle(
                      color: ColorBase.dodgerBlue,
                      fontFamily: FontsFamily.roboto,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ],
    );

    list.add(column);
  }
  return list;
}

_launchURL(String launchUrl, tipeURL, {String message}) async {
  String url;
  if (tipeURL == 'number') {
    url = 'tel:${launchUrl.replaceAll(RegExp(r'(\s+)'), '')}';
  } else if (tipeURL == 'web') {
    url = launchUrl;
  } else {
    url = Uri.encodeFull(
        'whatsapp://send?phone=${launchUrl.replaceAll('+', '')}&text=$message');
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
