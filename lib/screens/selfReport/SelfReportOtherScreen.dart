import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/otherSelfReport/OtherSelfReportBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/AddUserForm.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportList.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/HexColor.dart';

class SelfReportOtherScreen extends StatefulWidget {
  final LatLng location;
  final String cityId;

  SelfReportOtherScreen({Key key, this.location, this.cityId})
      : super(key: key);

  @override
  _SelfReportOtherScreenState createState() => _SelfReportOtherScreenState();
}

class _SelfReportOtherScreenState extends State<SelfReportOtherScreen> {
  ScrollController _scrollController;
  RemoteConfigBloc _remoteConfigBloc;
  OtherSelfReportBloc _otherSelfReportBloc;
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: buildCreateButton(),
      appBar: CustomAppBar.animatedAppBar(
        showTitle: _showTitle,
        title: Dictionary.reportForOther,
      ),
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RemoteConfigBloc>(
              create: (BuildContext context) => _remoteConfigBloc =
                  RemoteConfigBloc()..add(RemoteConfigLoad())),
          BlocProvider<OtherSelfReportBloc>(
              create: (context) => _otherSelfReportBloc = OtherSelfReportBloc()
                ..add(OtherSelfReportLoad()))
        ],
        child: BlocBuilder<OtherSelfReportBloc, OtherSelfReportState>(
            builder: (BuildContext context, OtherSelfReportState state) {
          if (state is OtherSelfReportLoaded) {
            return state.querySnapshot.docs.length == 0
                ? buildCreateOtherReport()
                : buildOtherReportList(state.querySnapshot.docs);
          } else if (state is OtherSelfReportFailure) {
            return ErrorContent(error: state.error);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  Widget buildCreateOtherReport() {
    return Stack(children: <Widget>[
      Positioned(
        left: 0.0,
        right: 0.0,
        top: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            Dictionary.reportForOther,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Positioned(
        left: 0.0,
        right: 0.0,
        top: MediaQuery.of(context).size.height * 0.2,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                      '${Environment.imageAssets}no_data_other_report.png',
                      width: 180.0,
                      height: 180.0),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        Dictionary.emptyContact,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.roboto,
                        ),
                      ))
                ],
              ),
            ),
            Container(
              child: Text(
                Dictionary.emptyContactDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorBase.netralGrey,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12.0),
              ),
            )
          ],
        ),
      )
    ]);
  }

  Widget buildOtherReportList(List<DocumentSnapshot> documents) {
    documents.sort((b, a) => b['created_at'].compareTo(a['created_at']));
    return Padding(
      padding: const EdgeInsets.all(Dimens.padding),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                i == 0
                    ? AnimatedOpacity(
                        opacity: _showTitle ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 250),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 10, right: 10),
                          child: Text(
                            Dictionary.reportForOther,
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelfReportList(
                              cityId: widget.cityId,
                              location: widget.location,
                              analytics: Analytics.tappedDailyOtherReport,
                              otherUID: documents[i].get('user_id'),
                              otherRecurrenceReport:
                                  getField(documents[i], 'recurrence_report'),
                              isHealthStatusChanged: getField(
                                      documents[i], 'health_status_changed') ??
                                  false,
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ColorBase.greyContainer,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.asset(
                                '${Environment.imageAssets}${documents[i].get('gender') == 'M' ? 'male_icon' : 'female_icon'}.png',
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Dictionary.countPeople + (i + 1).toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: ColorBase.grey800,
                                      fontFamily: FontsFamily.roboto),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  documents[i].get('name'),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorBase.grey800,
                                      fontFamily: FontsFamily.roboto),
                                ),
                                BlocBuilder<RemoteConfigBloc,
                                    RemoteConfigState>(
                                  builder: (context, remoteState) {
                                    return remoteState is RemoteConfigLoaded
                                        ? _buildHealthStatus(
                                            remoteState.remoteConfig,
                                            documents[i])
                                        : Container();
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 17,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                i == documents.length - 1
                    ? const SizedBox(
                        height: 80,
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  _buildHealthStatus(RemoteConfig remoteConfig, DocumentSnapshot data) {
    Color cardColor = ColorBase.grey;
    Color textColor = Colors.white;
    String uriImage = '${Environment.iconAssets}user_health.png';
    // Get data health status visible or not
    bool visible = remoteConfig != null &&
            remoteConfig.getBool(FirebaseConfig.healthStatusVisible) != null
        ? remoteConfig.getBool(FirebaseConfig.healthStatusVisible)
        : false;
    // Get data health status color from remote config
    if (remoteConfig != null &&
        remoteConfig.getString(FirebaseConfig.healthStatusColors) != null &&
        getField(data, 'health_status') != null) {
      Map<String, dynamic> healthStatusColor = json
          .decode(remoteConfig.getString(FirebaseConfig.healthStatusColors));

      switch (getField(data, 'health_status')) {
        case "HEALTHY":
          cardColor = HexColor.fromHex(healthStatusColor['healthy'] != null
              ? healthStatusColor['healthy']
              : ColorBase.green);
          break;

        case "ODP":
          cardColor = HexColor.fromHex(healthStatusColor['odp'] != null
              ? healthStatusColor['odp']
              : Colors.yellow);
          textColor = Colors.black;
          uriImage = '${Environment.iconAssets}user_health_black.png';
          break;

        case "PDP":
          cardColor = HexColor.fromHex(healthStatusColor['pdp'] != null
              ? healthStatusColor['pdp']
              : Colors.orange);
          textColor = Colors.black;
          uriImage = '${Environment.iconAssets}user_health_black.png';
          break;

        case "CONFIRMED":
          cardColor = HexColor.fromHex(healthStatusColor['confirmed'] != null
              ? healthStatusColor['confirmed']
              : Colors.red);
          break;

        case "OTG":
          cardColor = HexColor.fromHex(healthStatusColor['otg'] != null
              ? healthStatusColor['otg']
              : Colors.black);
          break;

        default:
          cardColor = Colors.grey;
      }
    }
    // Check if health status visible or not
    return visible && getField(data, 'health_status_text') != null
        ? Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                color: cardColor, borderRadius: BorderRadius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                getField(data, 'health_status_text'),
                style: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ))
        : Container();
  }

  /// Function to build create button
  Widget buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RoundedButton(
          title: Dictionary.addOtherReport,
          elevation: 0.0,
          color: ColorBase.green,
          borderRadius: BorderRadius.circular(8),
          textStyle: TextStyle(
              fontFamily: FontsFamily.roboto,
              fontSize: 12.0,
              fontWeight: FontWeight.w900,
              color: Colors.white),
          onPressed: () {
            // move to form screen
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddUserFormScreen()));
          }),
    );
  }

  @override
  void dispose() {
    _otherSelfReportBloc.close();
    if (_remoteConfigBloc != null) {
      _remoteConfigBloc.close();
    }
    super.dispose();
  }
}
