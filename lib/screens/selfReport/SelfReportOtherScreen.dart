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

class SelfReportOtherScreen extends StatefulWidget {
  final LatLng location;

  SelfReportOtherScreen({Key key, this.location}) : super(key: key);

  @override
  _SelfReportOtherScreenState createState() => _SelfReportOtherScreenState();
}

class _SelfReportOtherScreenState extends State<SelfReportOtherScreen> {
  ScrollController _scrollController;

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
      body: BlocProvider<OtherSelfReportBloc>(
        create: (BuildContext context) =>
            OtherSelfReportBloc()..add(OtherSelfReportLoad()),
        child: BlocBuilder<OtherSelfReportBloc, OtherSelfReportState>(
            builder: (context, state) {
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
          padding: EdgeInsets.all(20),
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
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                      '${Environment.imageAssets}no_data_other_report.png',
                      width: 180.0,
                      height: 180.0),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
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
      padding: EdgeInsets.all(Dimens.padding),
      child: ListView.builder(
          controller: _scrollController,
          itemCount: documents.length,
          itemBuilder: (context, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                i == 0
                    ? AnimatedOpacity(
                        opacity: _showTitle ? 0.0 : 1.0,
                        duration: Duration(milliseconds: 250),
                        child: Padding(
                          padding: EdgeInsets.only(
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
                              widget.location,
                              Analytics.tappedDailyOtherReport,
                              otherUID: documents[i].get('user_id'),
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
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ColorBase.greyContainer,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Image.asset(
                                '${Environment.imageAssets}${documents[i].get('gender') == 'M' ? 'male_icon' : 'female_icon'}.png',
                              ),
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
                                      fontSize: 14,
                                      color: ColorBase.grey800,
                                      fontFamily: FontsFamily.roboto),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  documents[i].get('name'),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: ColorBase.grey800,
                                      fontFamily: FontsFamily.roboto),
                                ),
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
                SizedBox(
                  height: 5,
                ),
                i == documents.length - 1
                    ? SizedBox(
                        height: 80,
                      )
                    : Container()
              ],
            );
          }),
    );
  }

  /// Function to build create button
  Widget buildCreateButton() {
    return Padding(
      padding: EdgeInsets.all(10.0),
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
}
