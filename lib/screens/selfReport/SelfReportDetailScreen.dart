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
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class SelfReportDetailScreen extends StatefulWidget {
  final String reportId, otherUID, analytics, cityId;

  SelfReportDetailScreen(
      {Key key, this.reportId, this.otherUID, this.analytics, this.cityId})
      : super(key: key);

  @override
  _SelfReportDetailScreenState createState() => _SelfReportDetailScreenState();
}

class _SelfReportDetailScreenState extends State<SelfReportDetailScreen> {
  DateTime currentDay = DateTime.now();
  SelfReportDetailBloc _selfReportDetailBloc = SelfReportDetailBloc();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedDailyReportDetail);

    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelfReportDetailBloc>(
      create: (context) => _selfReportDetailBloc
        ..add(SelfReportDetailLoad(
            selfReportId: widget.reportId, otherUid: widget.otherUID)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar.animatedAppBar(
          showTitle: _showTitle,
          title: Dictionary.selfReportDetail,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BlocBuilder<SelfReportDetailBloc, SelfReportDetailState>(
                builder: (context, state) {
              return state is SelfReportDetailLoaded
                  ?

                  /// Edit button section
                  isSameDate(
                          DateTime.fromMillisecondsSinceEpoch(
                              state.documentSnapshot['created_at'].seconds *
                                  1000),
                          currentDay)
                      ? Container(
                          height: 38.0,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              left: Dimens.padding, right: Dimens.padding),
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
                                    state.documentSnapshot['location']
                                        .longitude);

                                var dailyReportModel = DailyReportModel(
                                    id: state.documentSnapshot['id'],
                                    quarantineDate:
                                        state.documentSnapshot['quarantine_date'] !=
                                                null
                                            ? DateTime.fromMillisecondsSinceEpoch(
                                                state.documentSnapshot['quarantine_date'].seconds *
                                                    1000)
                                            : null,
                                    createdAt:
                                        DateTime.fromMillisecondsSinceEpoch(state
                                                .documentSnapshot['created_at']
                                                .seconds *
                                            1000),
                                    contactDate: state.documentSnapshot['contact_date'] !=
                                            null
                                        ? DateTime.fromMillisecondsSinceEpoch(
                                            state.documentSnapshot['contact_date'].seconds * 1000)
                                        : null,
                                    indications: state.documentSnapshot['indications'],
                                    bodyTemperature: state.documentSnapshot['body_temperature'],
                                    location: latLng);

                                /// Move to form screen
                                bool isUpdateForm = await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) =>
                                            SelfReportFormScreen(
                                              cityId: widget.cityId,
                                              dailyId:
                                                  state.documentSnapshot['id'],
                                              otherUID: widget.otherUID,
                                              location: latLng,
                                              analytics: widget.analytics,
                                              dailyReportModel:
                                                  dailyReportModel,
                                            )));

                                /// If data form updates, will get the newest data detail
                                if (isUpdateForm != null && isUpdateForm) {
                                  _selfReportDetailBloc
                                    ..add(SelfReportDetailLoad(
                                        selfReportId: widget.reportId,
                                        otherUid: widget.otherUID));
                                }
                              }),
                        )
                      : Container()
                  : state is SelfReportDetailFailure
                      ? Container()
                      : Center(
                          child: CircularProgressIndicator(),
                        );
            }),

            /// Back button section
            Container(
              height: 38.0,
              width: MediaQuery.of(context).size.width,
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
          ],
        ),
        body: BlocBuilder<SelfReportDetailBloc, SelfReportDetailState>(
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
      controller: _scrollController,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _showTitle ? 0.0 : 1.0,
                duration: Duration(milliseconds: 250),
                child: Text(
                  Dictionary.selfReportDetail,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30.0),

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
                              fontFamily: FontsFamily.roboto,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.grey800,
                              fontSize: 14.0,
                              height: 1.214),
                        ),
                        SizedBox(height: 8.0),
                        _buildText(
                            text: Dictionary.monitoringCompleted,
                            color: ColorBase.netralGrey,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildText(text: Dictionary.inputDate, isLabel: true),
                    SizedBox(
                      height: 10.0,
                    ),
                    _buildText(
                        text: unixTimeStampToDateWithoutDay(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
                    height: 1.0,
                    color: ColorBase.greyBorder,
                  ),

                  /// Contact date section
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.padding,
                        vertical: Dimens.verticalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _buildText(
                            text: Dictionary.contactDateCovid, isLabel: true),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildText(
                            text: unixTimeStampToDateWithoutDay(
                                state.documentSnapshot['contact_date'].seconds))
                      ],
                    ),
                  ),
                ],
              )
            : Container(),

        getField(state.documentSnapshot, 'quarantine_date') != null &&
                getField(state.documentSnapshot, 'quarantine_date')
                    .toString()
                    .isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Divider
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
                    height: 1.0,
                    color: ColorBase.greyBorder,
                  ),

                  /// Quarantine date section
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.padding,
                        vertical: Dimens.verticalPadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildText(
                            text: Dictionary.quarantineDate, isLabel: true),
                        SizedBox(
                          height: 10.0,
                        ),
                        _buildText(
                            text: unixTimeStampToDateWithoutDay(state
                                .documentSnapshot['quarantine_date'].seconds))
                      ],
                    ),
                  ),
                ],
              )
            : Container(),

        /// Divider
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
          height: 1.0,
          color: ColorBase.greyBorder,
        ),

        /// Temperature section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildText(text: Dictionary.bodyTemperature, isLabel: true),
              SizedBox(
                height: 10.0,
              ),
              _buildText(
                  text: '${state.documentSnapshot['body_temperature']} °c')
            ],
          ),
        ),

        /// Divider
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
          height: 1.0,
          color: ColorBase.greyBorder,
        ),

        /// The symptoms section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child:
                      _buildText(text: Dictionary.indications, isLabel: true)),
              SizedBox(
                height: 10.0,
              ),
              _buildText(
                  text: state.documentSnapshot['indications']
                      .replaceAll('[', '')
                      .replaceAll(']', ''),
                  textAlign: TextAlign.start)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        )
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
      {@required String text,
      bool isLabel = false,
      TextAlign textAlign,
      Color color}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: FontsFamily.roboto,
          color: color ?? ColorBase.grey800,
          fontWeight: isLabel ? FontWeight.bold : FontWeight.normal,
          fontSize: isLabel ? 12.0 : 14.0,
          height: 1.1667),
      textAlign: textAlign,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
