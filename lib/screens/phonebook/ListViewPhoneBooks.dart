import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'dart:convert';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/phonebook/CallCenterDetailScreen.dart';
import 'package:pikobar_flutter/screens/phonebook/PhoneBookDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ListViewPhoneBooks extends StatefulWidget {
  String searchQuery;

  ListViewPhoneBooks({Key key, this.searchQuery}) : super(key: key);

  @override
  _ListViewPhoneBooksState createState() => _ListViewPhoneBooksState();
}

class _ListViewPhoneBooksState extends State<ListViewPhoneBooks> {
  Map<String, bool> _categoryExpansionStateMap = Map<String, bool>();
  Map<String, bool> _detailEmergencyPhoneExpansionStateMap =
      Map<String, bool>();

  int callCenterPhoneCount, emergencyPhoneCount;
  int tag = 0;
  List<String> options = [
    'No Darurat',
    'RS Rujukan COVID-19',
    'Call Center Kota/Kab',
  ];
  @override
  void initState() {
    super.initState();
    _categoryExpansionStateMap = {
      "NomorDarurat": true,
      "RumahSakitRujukan": true,
      "CallCenter": true,
    };
  }

  callback(String value, bool newValue) {
    setState(() {
      _detailEmergencyPhoneExpansionStateMap["$value"] = !newValue;
      print(_detailEmergencyPhoneExpansionStateMap["$value"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ChipsChoice<int>.single(
          padding: EdgeInsets.symmetric(vertical: 5),
          value: tag,
          onChanged: (val) => setState(() {
            tag = val;
            print(tag);
            _detailEmergencyPhoneExpansionStateMap.clear();
          }),
          options: ChipsChoiceOption.listFrom<int, String>(
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
          itemConfig: const ChipsChoiceItemConfig(
            showCheckmark: false, selectedColor: Color(0xff27AE60),
            labelStyle: TextStyle(
              fontSize: 10,
              color: Color(0xff828282),
              fontFamily: 'lato',
            ),
            selectedBrightness: Brightness.dark,
            // unselectedBrightness: Brightness.dark,
          ),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              tag == 0
                  ? Column(
                      children: <Widget>[
                        widget.searchQuery == null
                            ? _buildDaruratNumber(context)
                            : Container(),
                      ],
                    )
                  : tag == 1
                      ? Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection(Collections.emergencyNumbers)
                                    .orderBy('name')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data.documents.isEmpty
                                        ? EmptyData(
                                            message:
                                                Dictionary.emptyDataPhoneBook)
                                        : snapshot.data.documents[0]['name'] !=
                                                null
                                            ? Column(
                                                children:
                                                    getListRumahSakitRujukan(
                                                        snapshot),
                                              )
                                            : Column(
                                                children: _buildLoading(),
                                              );
                                  } else {
                                    return Column(
                                      children: _buildLoading(),
                                    );
                                  }
                                }),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection(Collections.callCenters)
                                    .orderBy(
                                      'nama_kotkab',
                                    )
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data.documents.isEmpty
                                        ? EmptyData(
                                            message:
                                                Dictionary.emptyDataPhoneBook)
                                        : snapshot.data.documents[0]
                                                    ['nama_kotkab'] !=
                                                null
                                            ? Column(
                                                children:
                                                    getListCallCenter(snapshot),
                                              )
                                            : Column(
                                                children: _buildLoading(),
                                              );
                                  } else {
                                    return Column(
                                      children: _buildLoading(),
                                    );
                                  }
                                })
                          ],
                        ),
              widget.searchQuery != null &&
                      callCenterPhoneCount == 0 &&
                      emergencyPhoneCount == 0
                  ? EmptyData(message: Dictionary.emptyDataPhoneBook)
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getListRumahSakitRujukan(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> list = List();

    Column _cardTile(DocumentSnapshot document) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      height: 15,
                      child: Image.asset('${Environment.iconAssets}phone.png')),
                  SizedBox(
                    width: 20,
                  ),
                  document['name'] == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Text(document['name'],
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.lato,
                              fontSize: 12)),
                ],
              ),
              IconButton(
                icon: Icon(
                  _detailEmergencyPhoneExpansionStateMap[document['name']]
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  color: Color(0xff828282),
                  size: _detailEmergencyPhoneExpansionStateMap[document['name']]
                      ? 25
                      : 15,
                ),
                onPressed: () {
                  callback(document['name'],
                      _detailEmergencyPhoneExpansionStateMap[document['name']]);
                  print(_detailEmergencyPhoneExpansionStateMap);
                },
              )
            ],
          ),
          _detailEmergencyPhoneExpansionStateMap[document['name']]
              ? Padding(
                  padding: EdgeInsets.only(left: 35, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      document['address'] != null
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Text(document['address'],
                                  style: TextStyle(
                                      color: Color(0xff828282),
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 12)),
                            )
                          : Container(),
                      document['address'] != null
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document['phones'] != null &&
                              document['phones'].isNotEmpty
                          ? Column(
                              children:
                                  _buildListDetailPhone(document, 'phones'),
                            )
                          : Container(),
                      document['web'] != null && document['web'].isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document['web'] != null && document['web'].isNotEmpty
                          ? ListTile(
                              contentPadding: EdgeInsets.all(0),
                              trailing: Container(
                                  height: 15,
                                  child: Image.asset(
                                      '${Environment.iconAssets}web_underline.png')),
                              title: Text(
                                document['web'],
                                style: TextStyle(
                                    color: Color(0xff2D9CDB),
                                    fontFamily: FontsFamily.lato,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12),
                              ),
                              onTap: () {
                                _launchURL(document['web'], 'web');

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedphoneBookEmergencyWeb,
                                    <String, dynamic>{
                                      'title': document['name'],
                                      'web': document['web']
                                    });
                              })
                          : Container()
                    ],
                  ),
                )
              : Container()
        ],
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: _cardTile(document));
    }

    List dataNomorDarurat;
    if (widget.searchQuery != null) {
      dataNomorDarurat = snapshot.data.documents
          .where((test) => test['name']
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
    } else {
      dataNomorDarurat = snapshot.data.documents;
    }

    emergencyPhoneCount = dataNomorDarurat.length;
    for (int i = 0; i < emergencyPhoneCount; i++) {
      if (!_detailEmergencyPhoneExpansionStateMap
          .containsKey(dataNomorDarurat[i]['name'])) {
        _detailEmergencyPhoneExpansionStateMap
            .addAll({dataNomorDarurat[i]['name']: false});
      }

      Column column = Column(
        children: <Widget>[
          widget.searchQuery != null
              ? _card(dataNomorDarurat[i])
              : _categoryExpansionStateMap["RumahSakitRujukan"]
                  ? _card(dataNomorDarurat[i])
                  : Container(),
          _categoryExpansionStateMap["RumahSakitRujukan"]
              ? i == emergencyPhoneCount - 1
                  ? Container()
                  : SizedBox(
                      height: 15,
                      child: Container(
                        color: ColorBase.grey,
                      ),
                    )
              : Container()
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> _buildListDetailPhone(DocumentSnapshot document, String name) {
    List<Widget> list = List();

    for (int i = 0; i < document[name].length; i++) {
      Column column = Column(
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.all(0),
              trailing: Container(
                  height: 15,
                  child: Image.asset(
                      '${Environment.iconAssets}phone_underline.png')),
              title: Text(
                document[name][i],
                style: TextStyle(
                    color: Color(0xff2D9CDB),
                    fontFamily: FontsFamily.lato,
                    decoration: TextDecoration.underline,
                    fontSize: 12),
              ),
              onTap: () {
                _launchURL(document[name][i], 'number');

                AnalyticsHelper.setLogEvent(
                    Analytics.tappedphoneBookEmergencyTelp, <String, dynamic>{
                  'title': document['name'],
                  'telp': document[name][i]
                });
              }),
          i == document[name].length - 1
              ? Container()
              : SizedBox(
                  height: 5,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                )
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> getListCallCenter(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> list = List();
    Column _cardTile(DocumentSnapshot document) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      height: 15,
                      child: Image.asset('${Environment.iconAssets}phone.png')),
                  SizedBox(
                    width: 20,
                  ),
                  document['nama_kotkab'] == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Text(document['nama_kotkab'],
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.lato,
                              fontSize: 12)),
                ],
              ),
              IconButton(
                icon: Icon(
                  _detailEmergencyPhoneExpansionStateMap[
                          document['nama_kotkab']]
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  color: Color(0xff828282),
                  size: _detailEmergencyPhoneExpansionStateMap[
                          document['nama_kotkab']]
                      ? 25
                      : 15,
                ),
                onPressed: () {
                  callback(
                      document['nama_kotkab'],
                      _detailEmergencyPhoneExpansionStateMap[
                          document['nama_kotkab']]);
                  print(document);
                  print(_detailEmergencyPhoneExpansionStateMap);
                },
              )
            ],
          ),
          _detailEmergencyPhoneExpansionStateMap[document['nama_kotkab']]
              ? Padding(
                  padding: EdgeInsets.only(left: 35, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      document['call_center'] != null &&
                              document['call_center'].isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document['call_center'] != null &&
                              document['call_center'].isNotEmpty
                          ? Column(
                              children: _buildListDetailPhone(
                                  document, 'call_center'),
                            )
                          : Container(),
                      document['hotline'] != null &&
                              document['hotline'].isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document['hotline'] != null &&
                              document['hotline'].isNotEmpty
                          ? Column(
                              children:
                                  _buildListDetailPhone(document, 'hotline'),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container()
        ],
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: _cardTile(document));
    }

    List dataNomorDarurat;
    if (widget.searchQuery != null) {
      dataNomorDarurat = snapshot.data.documents
          .where((test) => test['nama_kotkab']
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
    } else {
      dataNomorDarurat = snapshot.data.documents;
    }

    callCenterPhoneCount = dataNomorDarurat.length;
    for (int i = 0; i < callCenterPhoneCount; i++) {
      if (!_detailEmergencyPhoneExpansionStateMap
          .containsKey(dataNomorDarurat[i]['nama_kotkab'])) {
        _detailEmergencyPhoneExpansionStateMap
            .addAll({dataNomorDarurat[i]['nama_kotkab']: false});
      }
      Column column = Column(
        children: <Widget>[
          widget.searchQuery != null
              ? _card(dataNomorDarurat[i])
              : _categoryExpansionStateMap["CallCenter"]
                  ? _card(dataNomorDarurat[i])
                  : Container(),
          i == callCenterPhoneCount - 1
              ? Container()
              : SizedBox(
                  height: 15,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                ),
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> getListEmergencyCall(var snapshot) {
    List<Widget> list = List();

    ListTile _cardTile(var document) {
      return ListTile(
        leading: Container(height: 25, child: Image.network(document['image'])),
        title: Text(
          document['title'],
          style: TextStyle(
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.lato,
              fontSize: 12),
        ),
        onTap: () {
          if (document['action'] == 'call') {
            _launchURL(document['phone_number'], 'number');

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyTelp, <String, dynamic>{
              'title': document['title'],
              'telp': document['phone_number']
            });
          } else if (document['action'] == 'whatsapp') {
            _launchURL(document['phone_number'], 'whatsapp',
                message: document['message']);

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyWa, <String, dynamic>{
              'title': document['title'],
              'wa': document['phone_number']
            });
          }
        },
      );
    }

    Widget _card(var document) {
      return Card(elevation: 0, child: _cardTile(document));
    }

    for (int i = 0; i < snapshot.length; i++) {
      Column column = Column(
        children: <Widget>[
          _card(snapshot[i]),
          i == snapshot.length - 1
              ? Container()
              : SizedBox(
                  height: 15,
                  child: Container(
                    color: ColorBase.grey,
                  ),
                ),
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> _buildLoading() {
    List<Widget> list = List();
    for (var i = 0; i < 8; i++) {
      Column column = Column(children: <Widget>[
        Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Skeleton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            height: 15,
                            child: Image.asset(
                                '${Environment.iconAssets}phone.png')),
                        SizedBox(
                          width: 20,
                        ),
                        Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xff828282),
                      size: 15,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
          child: Container(
            color: ColorBase.grey,
          ),
        )
      ]);
      list.add(column);
    }
    return list;
  }

  Widget _buildDaruratNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        // _buildCardHeader(
        //     context,
        //     'emergency_phone.png',
        //     Dictionary.phoneBookEmergencyInformation,
        //     Dictionary.phoneBookEmergencyInformationCaption,
        //     'NomorDarurat',
        //     _categoryExpansionStateMap["NomorDarurat"]),
        _categoryExpansionStateMap["NomorDarurat"]
            ? FutureBuilder<RemoteConfig>(
                future: setupRemoteConfig(),
                builder: (BuildContext context,
                    AsyncSnapshot<RemoteConfig> snapshot) {
                  var getEmergencyCall;
                  if (snapshot.data != null) {
                    getEmergencyCall = json.decode(
                        snapshot.data.getString(FirebaseConfig.emergencyCall));
                  }

                  return snapshot.data != null
                      ? Column(
                          children: getListEmergencyCall(getEmergencyCall),
                        )
                      : Container();
                })
            : Container(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildCardHeader(BuildContext context, String iconPath, title, content,
      nameBoolean, bool isExpand) {
    return InkWell(
      onTap: () {
        callback(nameBoolean, isExpand);
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Color(0xffF2C94C),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: EdgeInsets.all(17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                          height: 60,
                          child: Image.asset(
                              '${Environment.iconAssets}$iconPath')),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(content, style: TextStyle(fontSize: 11))
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    isExpand
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneBookDetailScreen(document: document),
      ),
    );

    AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergencyDetail,
        <String, dynamic>{'title': document['name']});
  }

  void _onTapCallCenter(BuildContext context, DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallCenterDetailScreen(document: document),
      ),
    );

    AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergencyDetail,
        <String, dynamic>{'title': document['nama_kotkab']});
  }

  _launchURL(String launchUrl, tipeURL, {String message}) async {
    String url;
    if (tipeURL == 'number') {
      url = 'tel:$launchUrl';
    } else if (tipeURL == 'web') {
      url = launchUrl;
    } else {
      url = Uri.encodeFull('whatsapp://send?phone=${launchUrl.replaceAll('+', '')}&text=$message');
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig
        .setDefaults(<String, dynamic>{FirebaseConfig.emergencyCall: []});

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    return remoteConfig;
  }
}
