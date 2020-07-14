import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/Bloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/EmergencyNumberBloc.dart';
import 'package:pikobar_flutter/blocs/emergencyNumber/EmergencyNumberEvent.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'dart:convert';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/CallCenterModel.dart';
import 'package:pikobar_flutter/models/EmergencyNumber.dart';
import 'package:pikobar_flutter/models/GugusTugasWebModel.dart';
import 'package:pikobar_flutter/models/ReferralHospitalModel.dart';
import 'package:pikobar_flutter/repositories/EmergencyNumberRepository.dart';
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
  Map<String, bool> _detailExpandList = Map<String, bool>();
  String typeEmergenyNumber = Dictionary.emergencyNumber;
  int callCenterPhoneCount, emergencyPhoneCount, dataWebGugustugasCount;
  int tag = 0;
  EmergencyNumberBloc _emergencyNumberBloc;
  final EmergencyNumberRepository _emergencyNumberRepository =
      EmergencyNumberRepository();
  List<String> options = [
    'No Darurat',
    'RS Rujukan COVID-19',
    'Call Center Kota/Kab',
    'Website Gugus Tugas Kota/Kabupaten Jawa Barat'
  ];
  List<String> listItemTitleTab = [
    Dictionary.emergencyNumber,
    Dictionary.referralHospital,
    Dictionary.callCenterArea,
    Dictionary.gugusTugasWeb
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
      _detailExpandList["$value"] = !newValue;
      print(_detailExpandList["$value"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmergencyNumberBloc>(
      create: (BuildContext context) => _emergencyNumberBloc =
          EmergencyNumberBloc(
              emergencyNumberRepository: _emergencyNumberRepository),
      child: BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
        builder: (context, state) {
          return CustomBubbleTab(
            indicatorColor: ColorBase.green,
            labelColor: Colors.white,
            listItemTitleTab: listItemTitleTab,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              if (index == 0) {
                setState(() {
                  typeEmergenyNumber = Dictionary.emergencyNumber;
                });
                AnalyticsHelper.setLogEvent(
                    Analytics.tappedphoneBookEmergencyTab);
              } else if (index == 1) {
                setState(() {
                  typeEmergenyNumber = Dictionary.referralHospital;
                  _emergencyNumberBloc.add(ReferralHospitalLoad());
                });
                AnalyticsHelper.setLogEvent(
                    Analytics.tappedRefferalHospitalTab);
              } else if (index == 2) {
                setState(() {
                  typeEmergenyNumber = Dictionary.callCenterArea;
                  _emergencyNumberBloc.add(CallCenterLoad());
                });
                AnalyticsHelper.setLogEvent(Analytics.tappedCallCenterTab);
              } else if (index == 3) {
                setState(() {
                  typeEmergenyNumber = Dictionary.gugusTugasWeb;
                  _emergencyNumberBloc.add(GugusTugasWebLoad());
                });
                AnalyticsHelper.setLogEvent(Analytics.tappedGugusTugasWebTab);
              }
            },
            tabBarView: <Widget>[
              buildEmergencyNumberTab(),
              buildReferralHospitalTab(),
              buildCallCenterTab(),
              buildWebGugusTugasTab()
            ],
            isExpand: true,
          );
        },
      ),
    );
  }

  /// Function to build Emergency Number Screen
  Widget buildEmergencyNumberTab() {
    return Column(
      children: <Widget>[
        _buildDaruratNumber(context),
      ],
    );
  }

  /// Function to build Referral Hospital Screen
  Widget buildReferralHospitalTab() {
    return ListView(
      children: <Widget>[
        BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (context, state) {
            if (state is ReferralHospitalLoaded) {
              List<ReferralHospitalModel> dataNomorDarurat;

              /// Checking search field
              if (widget.searchQuery != null) {
                /// Filtering data by search
                dataNomorDarurat = state.referralHospitalList
                    .where((test) => test.name
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()))
                    .toList();
              } else {
                dataNomorDarurat = state.referralHospitalList;
              }
              return dataNomorDarurat.isEmpty
                  ? EmptyData(
                      message: Dictionary.emptyDataPhoneBook,
                      desc: Dictionary.emptyDataPhoneBookDesc,
                      isFlare: false,
                      image: "${Environment.imageAssets}not_found.png",
                    )
                  : Column(
                      children: getListRumahSakitRujukan(dataNomorDarurat),
                    );
            } else {
              return Column(
                children: _buildLoading(),
              );
            }
          },
        )
      ],
    );
  }

  /// Function to build Call Center Screen
  Widget buildCallCenterTab() {
    return ListView(
      children: <Widget>[
        BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (context, state) {
            if (state is CallCenterLoaded) {
              List<CallCenterModel> dataCallCenter;

              /// Checking search field
              if (widget.searchQuery != null) {
                /// Filtering data by search
                dataCallCenter = state.callCenterList
                    .where((test) => test.nameCity
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()))
                    .toList();
              } else {
                dataCallCenter = state.callCenterList;
              }
              return dataCallCenter.isEmpty
                  ? EmptyData(
                      message: Dictionary.emptyDataPhoneBook,
                      desc: Dictionary.emptyDataPhoneBookDesc,
                      isFlare: false,
                      image: "${Environment.imageAssets}not_found.png",
                    )
                  : Column(
                      children: getListCallCenter(dataCallCenter),
                    );
            } else {
              return Column(
                children: _buildLoading(),
              );
            }
          },
        )
      ],
    );
  }

  /// Function to build Web Gugus Tugas Screen
  Widget buildWebGugusTugasTab() {
    return ListView(
      children: <Widget>[
        BlocBuilder<EmergencyNumberBloc, EmergencyNumberState>(
          builder: (context, state) {
            if (state is GugusTugasWebLoaded) {
              List<GugusTugasWebModel> dataWebGugusTugas;

              /// Checking search field
              if (widget.searchQuery != null) {
                /// Filtering data by search
                dataWebGugusTugas = state.gugusTugasWebModel
                    .where((test) => test.name
                        .toLowerCase()
                        .contains(widget.searchQuery.toLowerCase()))
                    .toList();
              } else {
                dataWebGugusTugas = state.gugusTugasWebModel;
              }
              return dataWebGugusTugas.isEmpty
                  ? EmptyData(
                      message: Dictionary.emptyDataPhoneBook,
                      desc: Dictionary.emptyDataPhoneBookDesc,
                      isFlare: false,
                      image: "${Environment.imageAssets}not_found.png",
                    )
                  : Column(
                      children: getListWebGugusTugas(dataWebGugusTugas),
                    );
            } else {
              return Column(
                children: _buildLoading(),
              );
            }
          },
        )
      ],
    );
  }

  /// Function to build Emergency Number Screen
  Widget _buildDaruratNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        _categoryExpansionStateMap["NomorDarurat"]
            ? FutureBuilder<RemoteConfig>(
                future: setupRemoteConfig(),
                builder: (BuildContext context,
                    AsyncSnapshot<RemoteConfig> snapshot) {
                  var tempGetEmergencyCall;
                  List<EmergencyNumberModel> getEmergencyCallFilter;

                  if (snapshot.data != null) {
                    tempGetEmergencyCall = json.decode(
                        snapshot.data.getString(FirebaseConfig.emergencyCall));
                    List<EmergencyNumberModel> getEmergencyCall =
                        (tempGetEmergencyCall as List)
                            .map((itemWord) =>
                                EmergencyNumberModel.fromJson(itemWord))
                            .toList();

                    /// Checking search field
                    if (widget.searchQuery != null) {
                      /// Filtering data by search
                      getEmergencyCallFilter = getEmergencyCall
                          .where((test) => test.title
                              .toLowerCase()
                              .contains(widget.searchQuery.toLowerCase()))
                          .toList();
                    } else {
                      getEmergencyCallFilter = getEmergencyCall;
                    }
                  }

                  return snapshot.data != null
                      ? getEmergencyCallFilter.isEmpty
                          ? EmptyData(
                              message: Dictionary.emptyDataPhoneBook,
                              desc: Dictionary.emptyDataPhoneBookDesc,
                              isFlare: false,
                              image: "${Environment.imageAssets}not_found.png",
                            )
                          : Column(
                              children:
                                  getListEmergencyCall(getEmergencyCallFilter),
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

  /// Build list of Refferal Hospital
  List<Widget> getListRumahSakitRujukan(List<ReferralHospitalModel> listModel) {
    List<Widget> list = List();

    Column _cardTile(ReferralHospitalModel document) {
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
                  document.name == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(document.name,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 12)),
                        ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _detailExpandList[document.name]
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  color: Color(0xff828282),
                  size: _detailExpandList[document.name] ? 25 : 15,
                ),
                onPressed: () {
                  callback(document.name, _detailExpandList[document.name]);
                  if (_detailExpandList[document.name]) {
                    AnalyticsHelper.setLogEvent(
                        Analytics.tappedphoneBookEmergencyDetail,
                        <String, dynamic>{'title': document.name});
                  }
                },
              )
            ],
          ),
          _detailExpandList[document.name]
              ? Padding(
                  padding: EdgeInsets.only(left: 35, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      document.address != null
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Text(document.address,
                                  style: TextStyle(
                                      color: Color(0xff828282),
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 12)),
                            )
                          : Container(),
                      document.address != null
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document.phones != null && document.phones.isNotEmpty
                          ? Column(
                              children: _buildListDetailPhone(
                                  document.phones, 'phones'),
                            )
                          : Container(),
                      document.web != null && document.web.isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document.web != null && document.web.isNotEmpty
                          ? ListTile(
                              contentPadding: EdgeInsets.all(0),
                              trailing: Container(
                                  height: 15,
                                  child: Image.asset(
                                      '${Environment.iconAssets}web_underline.png')),
                              title: Text(
                                document.web,
                                style: TextStyle(
                                    color: Color(0xff2D9CDB),
                                    fontFamily: FontsFamily.lato,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12),
                              ),
                              onTap: () {
                                _launchURL(document.web, 'web');

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedphoneBookEmergencyWeb,
                                    <String, dynamic>{
                                      'title': document.name,
                                      'web': document.web
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

    Widget _card(ReferralHospitalModel document) {
      return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: _cardTile(document));
    }

    emergencyPhoneCount = listModel.length;
    for (int i = 0; i < emergencyPhoneCount; i++) {
      if (!_detailExpandList.containsKey(listModel[i].name)) {
        /// Add list of name and boolean for expanded container
        _detailExpandList.addAll({listModel[i].name: false});
      }

      Column column = Column(
        children: <Widget>[
          _card(listModel[i]),
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

  /// Build list of phone number
  List<Widget> _buildListDetailPhone(List<dynamic> document, String name) {
    List<Widget> list = List();

    for (int i = 0; i < document.length; i++) {
      Column column = Column(
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.all(0),
              trailing: Container(
                  height: 15,
                  child: Image.asset(
                      '${Environment.iconAssets}phone_underline.png')),
              title: Text(
                document[i],
                style: TextStyle(
                    color: Color(0xff2D9CDB),
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    fontSize: 12),
              ),
              onTap: () {
                _launchURL(document[i], 'number');

                AnalyticsHelper.setLogEvent(
                    Analytics.tappedphoneBookEmergencyTelp,
                    <String, dynamic>{'title': document, 'telp': document[i]});
              }),
          i == document.length - 1
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

  /// Build list of Call Center
  List<Widget> getListCallCenter(List<CallCenterModel> listModel) {
    List<Widget> list = List();
    Column _cardTile(CallCenterModel document) {
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
                  document.nameCity == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(document.nameCity,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 12)),
                        ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _detailExpandList[document.nameCity]
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  color: Color(0xff828282),
                  size: _detailExpandList[document.nameCity] ? 25 : 15,
                ),
                onPressed: () {
                  callback(
                      document.nameCity, _detailExpandList[document.nameCity]);
                  if (_detailExpandList[document.nameCity]) {
                    AnalyticsHelper.setLogEvent(
                        Analytics.tappedphoneBookEmergencyDetail,
                        <String, dynamic>{'title': document.nameCity});
                  }
                },
              )
            ],
          ),
          _detailExpandList[document.nameCity]
              ? Padding(
                  padding: EdgeInsets.only(left: 35, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      document.callCenter != null &&
                              document.callCenter.isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document.callCenter != null &&
                              document.callCenter.isNotEmpty
                          ? Column(
                              children: _buildListDetailPhone(
                                  document.callCenter, 'call_center'),
                            )
                          : Container(),
                      document.hotline != null && document.hotline.isNotEmpty
                          ? SizedBox(
                              height: 5,
                              child: Container(
                                color: ColorBase.grey,
                              ),
                            )
                          : Container(),
                      document.hotline != null && document.hotline.isNotEmpty
                          ? Column(
                              children: _buildListDetailPhone(
                                  document.hotline, 'hotline'),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container()
        ],
      );
    }

    Widget _card(CallCenterModel document) {
      return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: _cardTile(document));
    }

    callCenterPhoneCount = listModel.length;
    for (int i = 0; i < callCenterPhoneCount; i++) {
      if (!_detailExpandList.containsKey(listModel[i].nameCity)) {
        /// Add list of name and boolean for expanded container
        _detailExpandList.addAll({listModel[i].nameCity: false});
      }
      Column column = Column(
        children: <Widget>[
          _card(listModel[i]),
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

  /// Build list of Web Gugus Tugas
  List<Widget> getListWebGugusTugas(List<GugusTugasWebModel> listModel) {
    List<Widget> list = List();
    Column _cardTile(GugusTugasWebModel document) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  document.name == null
                      ? Skeleton(
                          height: 5,
                          width: MediaQuery.of(context).size.width / 4,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(document.name,
                              style: TextStyle(
                                  color: Color(0xff333333),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.lato,
                                  fontSize: 12)),
                        ),
                ],
              ),
              IconButton(
                icon: Icon(
                  _detailExpandList[document.name]
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  color: Color(0xff828282),
                  size: _detailExpandList[document.name] ? 25 : 15,
                ),
                onPressed: () {
                  callback(document.name, _detailExpandList[document.name]);
                  if (_detailExpandList[document.name]) {
                    AnalyticsHelper.setLogEvent(
                        Analytics.tappedphoneBookEmergencyDetail,
                        <String, dynamic>{'title': document.name});
                  }
                },
              )
            ],
          ),
          _detailExpandList[document.name]
              ? Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      document.website != null && document.website.isNotEmpty
                          ? ListTile(
                              contentPadding: EdgeInsets.all(0),
                              trailing: Container(
                                  height: 15,
                                  child: Image.asset(
                                      '${Environment.iconAssets}web_underline.png')),
                              title: Text(
                                document.website,
                                style: TextStyle(
                                    color: Color(0xff2D9CDB),
                                    fontFamily: FontsFamily.lato,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12),
                              ),
                              onTap: () {
                                _launchURL(document.website, 'web');

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedphoneBookEmergencyWeb,
                                    <String, dynamic>{
                                      'title': document.name,
                                      'web': document.website
                                    });
                              })
                          : Container(),
                    ],
                  ),
                )
              : Container()
        ],
      );
    }

    Widget _card(GugusTugasWebModel document) {
      return Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: _cardTile(document));
    }

    dataWebGugustugasCount = listModel.length;
    for (int i = 0; i < dataWebGugustugasCount; i++) {
      if (!_detailExpandList.containsKey(listModel[i].name)) {
        /// Add list of name and boolean for expanded container
        _detailExpandList.addAll({listModel[i].name: false});
      }
      Column column = Column(
        children: <Widget>[
          _card(listModel[i]),
          i == dataWebGugustugasCount - 1
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

  /// Build list of Emergency Number
  List<Widget> getListEmergencyCall(List<EmergencyNumberModel> snapshot) {
    List<Widget> list = List();

    ListTile _cardTile(EmergencyNumberModel document) {
      return ListTile(
        leading: Container(height: 25, child: Image.network(document.image)),
        title: Text(
          document.title,
          style: TextStyle(
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.lato,
              fontSize: 12),
        ),
        onTap: () {
          if (document.action == 'call') {
            _launchURL(document.phoneNumber, 'number');

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyTelp, <String, dynamic>{
              'title': document.title,
              'telp': document.phoneNumber
            });
          } else if (document.action == 'whatsapp') {
            _launchURL(document.phoneNumber, 'whatsapp',
                message: document.message);

            AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergencyWa, <String, dynamic>{
              'title': document.title,
              'wa': document.phoneNumber
            });
          }
        },
      );
    }

    Widget _card(EmergencyNumberModel document) {
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
      url = Uri.encodeFull(
          'whatsapp://send?phone=${launchUrl.replaceAll('+', '')}&text=$message');
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

  @override
  void dispose() {
    _emergencyNumberBloc.close();
    super.dispose();
  }
}
