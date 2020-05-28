import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'dart:convert';
import 'package:pikobar_flutter/constants/Dictionary.dart';
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
  int callCenterPhoneCount, emergencyPhoneCount;
  @override
  void initState() {
    super.initState();
    _categoryExpansionStateMap = {
      "NomorDarurat": true,
      "RumahSakitRujukan": false,
      "CallCenter": false,
    };
  }

  callback(String value, bool newValue) {
    setState(() {
      _categoryExpansionStateMap["$value"] = !newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              widget.searchQuery == null
                  ? _buildDaruratNumber(context)
                  : Container(),
              widget.searchQuery == null
                  ? _buildCardHeader(
                      context,
                      'hospital.png',
                      Dictionary.daftarRumahSakitRujukan,
                      Dictionary.daftarRumahSakitRujukanCaption,
                      'RumahSakitRujukan',
                      _categoryExpansionStateMap["RumahSakitRujukan"])
                  : Container(),
              StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(Collections.emergencyNumbers)
                      .orderBy('name')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data.documents.isEmpty
                          ? EmptyData(message: Dictionary.emptyDataPhoneBook)
                          : Column(
                              children: getListRumahSakitRujukan(snapshot),
                            );
                    } else {
                      return Center(child: _buildLoading());
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              widget.searchQuery == null
                  ? _buildCardHeader(
                      context,
                      'call_center.png',
                      Dictionary.callCenterTitle,
                      Dictionary.callCenterCaption,
                      'CallCenter',
                      _categoryExpansionStateMap["CallCenter"])
                  : Container(),
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
                          ? EmptyData(message: Dictionary.emptyDataPhoneBook)
                          : Column(
                              children: getListCallCenter(snapshot),
                            );
                    } else {
                      return Center(child: _buildLoading());
                    }
                  })
            ],
          ),
        ),
        widget.searchQuery != null &&
                callCenterPhoneCount == 0 &&
                emergencyPhoneCount == 0
            ? EmptyData(message: Dictionary.emptyDataPhoneBook)
            : Container()
      ],
    );
  }

  List<Widget> getListRumahSakitRujukan(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> list = List();

    ListTile _cardTile(DocumentSnapshot document) {
      return ListTile(
        leading: Container(
            height: 25,
            child: Image.asset('${Environment.iconAssets}office.png')),
        title: Text(
          document['name'],
          style:
              TextStyle(color: Color(0xff4F4F4F), fontWeight: FontWeight.bold),
        ),
        onTap: () => _onTapItem(context, document),
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: _cardTile(document),
          ));
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
      Column column = Column(
        children: <Widget>[
          emergencyPhoneCount == 0 && callCenterPhoneCount == 0
              ? EmptyData(
                  message:
                      '${Dictionary.emptyData} ${Dictionary.phoneBookEmergency}')
              : widget.searchQuery != null
                  ? _card(dataNomorDarurat[i])
                  : _categoryExpansionStateMap["RumahSakitRujukan"]
                      ? _card(dataNomorDarurat[i])
                      : Container(),
          _categoryExpansionStateMap["RumahSakitRujukan"]
              ? SizedBox(
                  height: 10,
                )
              : Container()
        ],
      );

      list.add(column);
    }
    return list;
  }

  List<Widget> getListCallCenter(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Widget> list = List();

    ListTile _cardTile(DocumentSnapshot document) {
      return ListTile(
        leading: Container(
            height: 25,
            child: Image.asset('${Environment.iconAssets}office.png')),
        title: Text(
          document['nama_kotkab'],
          style:
              TextStyle(color: Color(0xff4F4F4F), fontWeight: FontWeight.bold),
        ),
        onTap: () => _onTapCallCenter(context, document),
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: _cardTile(document),
          ));
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
      Column column = Column(
        children: <Widget>[
          widget.searchQuery != null
              ? _card(dataNomorDarurat[i])
              : _categoryExpansionStateMap["CallCenter"]
                  ? _card(dataNomorDarurat[i])
                  : Container(),
          SizedBox(
            height: 10,
          )
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
          style:
              TextStyle(color: Color(0xff4F4F4F), fontWeight: FontWeight.bold),
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
            _launchURL(document['phone_number'], 'whatsapp',message: document['message']);

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
      return Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: _cardTile(document),
          ));
    }

    for (int i = 0; i < snapshot.length; i++) {
      Column column = Column(
        children: <Widget>[_card(snapshot[i])],
      );

      list.add(column);
    }
    return list;
  }

  Widget _buildLoading() {
    return Column(
      children: <Widget>[
        Skeleton(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: EdgeInsets.all(17.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Skeleton(
                    height: 80,
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Skeleton(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 10,
                        ),
                        Skeleton(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildDaruratNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildCardHeader(
            context,
            'emergency_phone.png',
            Dictionary.phoneBookEmergencyInformation,
            Dictionary.phoneBookEmergencyInformationCaption,
            'NomorDarurat',
            _categoryExpansionStateMap["NomorDarurat"]),
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

  _launchURL(String launchUrl, tipeURL,{String message}) async {
    String url;
    if (tipeURL == 'number') {
      url = 'tel:$launchUrl';
    } else {
      url = 'whatsapp://send?phone=$launchUrl&text=$message';
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
