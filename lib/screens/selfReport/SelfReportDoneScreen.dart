import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/style.dart';
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
import 'package:pikobar_flutter/screens/selfReport/EducationDetailScreen.dart';

class SelfReportDoneScreen extends StatefulWidget {
  final LatLng location;
  final String otherUID;
  final String analytics;
  final String recurrenceReport;

  SelfReportDoneScreen(
      {Key key,
      this.location,
      this.otherUID,
      this.analytics,
      this.recurrenceReport})
      : super(key: key);

  @override
  _SelfReportDoneScreenState createState() => _SelfReportDoneScreenState();
}

class _SelfReportDoneScreenState extends State<SelfReportDoneScreen> {
  var listIndications = [];
  bool isHealthy = false;
  String summary = '';
  EducationModel educationModel;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.animatedAppBar(
        showTitle: _showTitle,
        title: Dictionary.dailySelfReport,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
                title: Dictionary.selfReportHistory,
                elevation: 0.0,
                color: ColorBase.green,
                borderRadius: BorderRadius.circular(8),
                textStyle: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                }),
            SizedBox(
              height: 20,
            ),
            RoundedButton(
                title: Dictionary.readHealthTips,
                borderSide: BorderSide(color: Colors.grey),
                elevation: 0.0,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                textStyle: TextStyle(
                    fontSize: 14,
                    color: ColorBase.netralGrey,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EducationDetailScreen(
                            id: 'kejgmxftb0xlbssc944',
                            educationCollection: kEducationContent,
                            model: educationModel,
                          )));
                }),
          ],
        ),
      ),
      body: BlocProvider<SelfReportListBloc>(
        create: (BuildContext context) => SelfReportListBloc()
          ..add(SelfReportListLoad(
              otherUID: widget.otherUID,
              recurrenceReport: widget.recurrenceReport)),
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
    if (listIndications.isEmpty) {
// Checking document is not null
      if (snapshot.querySnapshot.docs.length != 0) {
        for (var i = 0; i < snapshot.querySnapshot.docs.length; i++) {
          /// Get indications to [listIndications]
          listIndications.add(snapshot.querySnapshot.docs[i]
              .get('indications')
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
    }

    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        AnimatedOpacity(
          opacity: _showTitle ? 0.0 : 1.0,
          duration: Duration(milliseconds: 250),
          child: Text(
            Dictionary.dailySelfReport,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
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
              color: ColorBase.veryDarkGrey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: FontsFamily.roboto,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            Dictionary.selfReportSummary + summary,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: FontsFamily.roboto,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Announcement(
          title: Dictionary.info,
          content: isHealthy
              ? Dictionary.announcementDescHealthy
              : Dictionary.announcementDescIndication,
          margin: EdgeInsets.zero,
          htmlStyle: Style(
              margin: EdgeInsets.zero,
              fontFamily: FontsFamily.roboto,
              fontSize: FontSize(12.0),
              color: ColorBase.netralGrey),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
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
