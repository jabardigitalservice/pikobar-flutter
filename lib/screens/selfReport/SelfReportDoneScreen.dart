import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportList/SelfReportListBloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/screens/phonebook/Phonebook.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationDetailScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportList.dart';

class SelfReportDoneScreen extends StatefulWidget {
  final LatLng location;
  SelfReportDoneScreen(this.location);
  @override
  _SelfReportDoneScreenState createState() => _SelfReportDoneScreenState();
}

class _SelfReportDoneScreenState extends State<SelfReportDoneScreen> {
  var listIndications = [];
  bool isHealthy = false;
  String summary = '';
  EducationModel educationModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.dailySelfReport),
      body: BlocProvider<SelfReportListBloc>(
        create: (BuildContext context) =>
            SelfReportListBloc()..add(SelfReportListLoad()),
        child: BlocBuilder<SelfReportListBloc, SelfReportListState>(
            builder: (context, state) {
          if (state is SelfReportListLoaded) {
            return _buildContent(state);
          } else if (state is SelfReportListFailure) {
            return ErrorContent(error: state.error);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  Widget _buildContent(SelfReportListLoaded snapshot) {
    // Checking document is not null
    if (snapshot.querySnapshot.documents.length != 0) {
      for (var i = 0; i < snapshot.querySnapshot.documents.length; i++) {
        /// Get indications to [listIndications]
        listIndications.add(snapshot
            .querySnapshot.documents[i].data['indications']
            .replaceAll('[', '')
            .replaceAll(']', ''));
      }
    }
    // Checking user indications
    if (countNoIndications(listIndications, 'Tidak Ada Gejala') == 14) {
      isHealthy = true;
    // Remove same string from list
      listIndications = listIndications.toSet().toList();
      summary = 'tidak ada indikasi gejala.';
    } else {
      isHealthy = false;
      String tempStringIndications =
          listIndications.toString().replaceAll('[', '').replaceAll(']', '');
      listIndications = tempStringIndications.split(',');
      listIndications = listIndications.toSet().toList();
      listIndications.remove('Tidak Ada Gejala');
      listIndications.remove(' Tidak Ada Gejala');
      int countIndications = listIndications.length;
      summary =
          'terdapat ${countIndications.toString()} indikasi gejala, yaitu ${listIndications.toString().replaceAll('[', '').replaceAll(']', '')}.';
    }
  

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Image.asset(
            '${Environment.imageAssets}daily_report_done.png',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            Dictionary.monitoringIsComplete,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.lato,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            Dictionary.selfReportSummary + summary,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: FontsFamily.lato,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RoundedButton(
            title: Dictionary.selfReportHistory,
            elevation: 0.0,
            color: ColorBase.green,
            borderRadius: BorderRadius.circular(8),
            textStyle: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 12.0,
                fontWeight: FontWeight.w900,
                color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SelfReportList(widget.location)));
            }),
        SizedBox(
          height: 20,
        ),
        Announcement(
          title: Dictionary.info,
          content: isHealthy
              ? Dictionary.announcementDescHealthy
              : Dictionary.announcementDescIndication,
          textStyleContent: TextStyle(
              fontFamily: FontsFamily.lato,
              fontSize: 12.0,
              color: Colors.black),
        ),
        SizedBox(
          height: 20,
        ),
        OutlineButton(
          borderSide: BorderSide(color: ColorBase.limeGreen),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EducationDetailScreen(
                      id: 'kejgmxftb0xlbssc944',
                      educationCollection: kEducationContent,
                      model: educationModel,
                    )));
          },
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  Dictionary.readHealthTips,
                  style: TextStyle(
                      color: ColorBase.limeGreen,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.lato),
                ))),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Phonebook()));
            },
            child: Text(
              Dictionary.callEmergencyNumber,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorBase.darkGrey,
                fontFamily: FontsFamily.lato,
              ),
            ))
      ],
    );
  }

// Function for count same string from list
  int countNoIndications(List<dynamic> list, String element) {
    if (list == null || list.isEmpty) {
      return 0;
    }
    var foundElements = list.where((e) => e == element);
    return foundElements.length;
  }
}
