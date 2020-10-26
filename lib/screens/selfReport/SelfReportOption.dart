import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/blocs/selfReport/otherSelfReport/OtherSelfReportBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/AddUserForm.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportList.dart';

class SelfReportOption extends StatefulWidget {
  final LatLng location;
  SelfReportOption(this.location);

  @override
  _SelfReportOptionState createState() => _SelfReportOptionState();
}

class _SelfReportOptionState extends State<SelfReportOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(
        title: Dictionary.dailyMonitoring,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider<OtherSelfReportBloc>(
        create: (BuildContext context) =>
            OtherSelfReportBloc()..add(OtherSelfReportLoad()),
        child: BlocBuilder<OtherSelfReportBloc, OtherSelfReportState>(
            builder: (context, state) {
          if (state is OtherSelfReportLoaded) {
            return buildContent(state.querySnapshot.documents);
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

  Widget buildContent(List<DocumentSnapshot> documents) {
    documents.sort((b, a) => b['created_at'].compareTo(a['created_at']));
    return Padding(
      padding: EdgeInsets.all(Dimens.contentPadding),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              // move to self report list screen
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelfReportList(
                      widget.location, Analytics.tappedDailyReport)));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: ColorBase.menuBorderColor),
                              )),
                          Positioned(
                            left: 15,
                            top: 15,
                            child: Image.asset(
                              '${Environment.imageAssets}male_icon.png',
                              height: 20,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Dictionary.forMySelfTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: FontsFamily.lato),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            Dictionary.forMySelfDesc,
                            style: TextStyle(
                                fontSize: 12, fontFamily: FontsFamily.lato),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: ColorBase.grey,
            thickness: 10,
          ),
          documents.length == 0
              ? buildCreateOtherReport()
              : buildOtherReportList(documents)
        ],
      ),
    );
  }

  Widget buildCreateOtherReport() {
    return InkWell(
      onTap: () {
        // move to form screen
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddUserFormScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: ColorBase.menuBorderColor),
                        )),
                    Positioned(
                      left: 15,
                      top: 15,
                      child: Image.asset(
                        '${Environment.iconAssets}other_report_icon.png',
                        height: 20,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Dictionary.forOtherTitle,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: FontsFamily.lato),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Dictionary.forOtherDesc,
                      style:
                          TextStyle(fontSize: 12, fontFamily: FontsFamily.lato),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget buildOtherReportList(List<DocumentSnapshot> documents) {
    return Expanded(
      child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, i) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelfReportList(
                              widget.location,
                              Analytics.tappedDailyOtherReport,
                              otherUID: documents[i].data['user_id'],
                            )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: ColorBase.menuBorderColor),
                                    )),
                                Positioned(
                                  left: 15,
                                  top: 15,
                                  child: Image.asset(
                                    '${Environment.imageAssets}${documents[i].data['gender'] == 'M' ? 'male_icon' : 'female_icon'}.png',
                                    height: 20,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Dictionary.countPeople + (i + 1).toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      fontFamily: FontsFamily.lato),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  documents[i].data['name'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: FontsFamily.lato),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                i == documents.length - 1
                    ? buildCreateButton()
                    : Divider(
                        color: ColorBase.grey,
                        thickness: 10,
                      ),
              ],
            );
          }),
    );
  }

  /// Function to build create button
  Widget buildCreateButton() {
    return RoundedButton(
        title: Dictionary.addOtherReport,
        elevation: 0.0,
        color: ColorBase.green,
        borderRadius: BorderRadius.circular(8),
        textStyle: TextStyle(
            fontFamily: FontsFamily.lato,
            fontSize: 12.0,
            fontWeight: FontWeight.w900,
            color: Colors.white),
        onPressed: () {
          // move to form screen
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddUserFormScreen()));
        });
  }
}
