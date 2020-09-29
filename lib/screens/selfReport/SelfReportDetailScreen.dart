
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportDetail/SelfReportDetailBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportFormScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class SelfReportDetailScreen extends StatefulWidget {
  final String reportId;

  SelfReportDetailScreen(this.reportId);

  @override
  _SelfReportDetailScreenState createState() => _SelfReportDetailScreenState();
}

class _SelfReportDetailScreenState extends State<SelfReportDetailScreen> {
  DateTime currentDay = DateTime.now();
  SelfReportDetailBloc _selfReportDetailBloc = SelfReportDetailBloc();

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedDailyReportDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.selfReportDetail),
      body: BlocProvider<SelfReportDetailBloc>(
        create: (context) => _selfReportDetailBloc
          ..add(SelfReportDetailLoad(selfReportId: widget.reportId)),
        child: BlocBuilder<SelfReportDetailBloc, SelfReportDetailState>(
            builder: (context, state) {
          return state is SelfReportDetailLoaded
              ? _buildContent(state)
              : state is SelfReportDetailFailure
                  ? ErrorContent(error: state.error)
                  : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _buildContent(SelfReportDetailLoaded state) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Image.asset('${Environment.iconAssets}calendar_1.png',
                        width: 39, height: 39),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${Dictionary.monitoringDays}${state.documentSnapshot['id']}',
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              height: 1.214),
                        ),
                        SizedBox(height: 8.0),
                        _buildText(
                            text: Dictionary.monitoringCompleted,
                            isLabel: true),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 32.0,
              ),

              /// Input date section
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildText(text: Dictionary.inputDate, isLabel: true),
                    _buildText(
                        text: unixTimeStampToDate(
                            state.documentSnapshot['created_at'].seconds))
                  ],
                ),
              )
            ],
          ),
        ),

        state.documentSnapshot['contact_date'] != null &&
                state.documentSnapshot['contact_date'].toString().isNotEmpty
            ? Column(
                children: <Widget>[
                  /// Divider
                  Container(
                    height: 8.0,
                    color: ColorBase.grey,
                  ),

                  /// Contact date section
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.padding,
                        vertical: Dimens.verticalPadding),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: _buildText(
                              text: Dictionary.contactDateCovid, isLabel: true),
                        ),SizedBox(width: 40,),
                        _buildText(
                            text: unixTimeStampToDate(
                                state.documentSnapshot['contact_date'].seconds))
                      ],
                    ),
                  ),
                ],
              )
            : Container(),

        /// Divider
        Container(
          height: 8.0,
          color: ColorBase.grey,
        ),

        /// Temperature section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText(text: Dictionary.bodyTemperature, isLabel: true),
              _buildText(
                  text: '${state.documentSnapshot['body_temperature']}° C')
            ],
          ),
        ),

        /// Divider
        Container(
          height: 8.0,
          color: ColorBase.grey,
        ),

        /// The symptoms section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child:
                      _buildText(text: Dictionary.indications, isLabel: true)),
              Expanded(
                child: _buildText(
                    text: state.documentSnapshot['indications'],
                    textAlign: TextAlign.end),
              )
            ],
          ),
        ),

        /// Back button section
        Container(
          height: 38.0,
          margin: EdgeInsets.all(Dimens.padding),
          child: RaisedButton(
              splashColor: Colors.lightGreenAccent,
              color: ColorBase.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                Dictionary.back,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),

        /// Edit button section
        isSameDate(
                DateTime.fromMillisecondsSinceEpoch(
                    state.documentSnapshot['created_at'].seconds * 1000),
                currentDay)
            ?
        Container(
                height: 38.0,
                margin: EdgeInsets.only(
                    left: Dimens.padding,
                    right: Dimens.padding,
                    bottom: Dimens.padding),
                child: RaisedButton(
                    splashColor: Colors.lightGreenAccent,
                    color: ColorBase.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      Dictionary.editDailyMonitoring,
                      style: TextStyle(
                          fontFamily: FontsFamily.lato,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.white),
                    ),
                    onPressed: () async {
                      /// Add data to DailyReportModel that will be used for edit data
                      LatLng latLng = LatLng(
                          state.documentSnapshot['location'].latitude,
                          state.documentSnapshot['location'].longitude);

                      var dailyReportModel = DailyReportModel(
                          id: state.documentSnapshot['id'],
                          createdAt: DateTime.fromMillisecondsSinceEpoch(
                              state.documentSnapshot['created_at'].seconds *
                                  1000),
                          contactDate:
                              state.documentSnapshot['contact_date'] != null
                                  ? DateTime.fromMillisecondsSinceEpoch(state
                                          .documentSnapshot['contact_date']
                                          .seconds *
                                      1000)
                                  : null,
                          indications: state.documentSnapshot['indications'],
                          bodyTemperature:
                              state.documentSnapshot['body_temperature'],
                          location: latLng);

                      /// Move to form screen
                      bool isUpdateForm =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SelfReportFormScreen(
                                    dailyId: state.documentSnapshot['id'],
                                    location: latLng,
                                    dailyReportModel: dailyReportModel,
                                  )));

                      /// If data form updates, will get the newest data detail
                      if (isUpdateForm != null && isUpdateForm) {
                        _selfReportDetailBloc
                          ..add(SelfReportDetailLoad(
                              selfReportId: widget.reportId));
                      }
                    }),
              )
            : Container()
      ],
    );
  }

  /// Condition for check report is same day or not
  bool isSameDate(DateTime createReportDay, DateTime currentDay) {
    return createReportDay.year == currentDay.year &&
        createReportDay.month == currentDay.month &&
        createReportDay.day == currentDay.day;
  }

  /// Creates a text widget.
  ///
  /// If the [isLabel] parameter is true, it will make the text bold.
  /// The [text] parameter must not be null.
  Text _buildText(
      {@required String text, bool isLabel = false, TextAlign textAlign}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: FontsFamily.lato,
          fontWeight: isLabel ? FontWeight.normal : FontWeight.bold,
          fontSize: 12.0,
          height: 1.1667),
      textAlign: textAlign,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
