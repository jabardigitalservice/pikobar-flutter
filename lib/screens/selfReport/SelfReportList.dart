import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportList/SelfReportListBloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportReminder/SelfReportReminderBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportDetailScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportFormScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';

class SelfReportList extends StatefulWidget {
  final LatLng location;
  final String otherUID;
  final String analytics;

  SelfReportList(this.location, this.analytics, {this.otherUID});

  @override
  _SelfReportListState createState() => _SelfReportListState();
}

class _SelfReportListState extends State<SelfReportList> {
  bool isReminder;
  var listDocumentId = [];
  DateTime firstDay, currentDay;
  Color textColor;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(widget.analytics);
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
      appBar: CustomAppBar.animatedAppBar(
        showTitle: _showTitle,
        title: widget.otherUID != null
            ? Dictionary.reportForOther
            : Dictionary.reportForMySelf,
      ),
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
          providers: [
            BlocProvider<SelfReportReminderBloc>(
              create: (BuildContext context) =>
                  SelfReportReminderBloc()..add(SelfReportReminderListLoad()),
            ),
            BlocProvider<SelfReportListBloc>(
              create: (BuildContext context) => SelfReportListBloc()
                ..add(SelfReportListLoad(otherUID: widget.otherUID)),
            ),
          ],
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _showTitle ? 0.0 : 1.0,
                duration: Duration(milliseconds: 250),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Text(
                    widget.otherUID != null
                        ? Dictionary.reportForOther
                        : Dictionary.reportForMySelf,
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              _showTitle
                  ? Container()
                  : Container(
                      margin: EdgeInsets.all(Dimens.contentPadding),
                      decoration: BoxDecoration(
                          color: ColorBase.grey,
                          borderRadius: BorderRadius.circular(8)),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Padding(
                          padding: EdgeInsets.all(Dimens.contentPadding),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                BlocBuilder<SelfReportListBloc,
                                        SelfReportListState>(
                                    builder: (context, state) {
                                  if (state is SelfReportListLoaded) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          Dictionary.dailyMonitoringProgress,
                                          style: TextStyle(
                                              fontFamily: FontsFamily.roboto,
                                              fontWeight: FontWeight.bold,
                                              color: ColorBase.netralGrey,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          '${((state.querySnapshot.docs.length / 14) * 100).toStringAsPrecision(3)}%',
                                          style: TextStyle(
                                              fontFamily: FontsFamily.roboto,
                                              color: ColorBase.primaryGreen,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        )
                                      ],
                                    );
                                  } else if (state is SelfReportListFailure) {
                                    return ErrorContent(error: state.error);
                                  } else {
                                    return Container();
                                  }
                                }),
                                BlocBuilder<SelfReportListBloc,
                                        SelfReportListState>(
                                    builder: (context, state) {
                                  if (state is SelfReportListLoaded) {
                                    return LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      lineHeight: 8.0,
                                      backgroundColor:
                                          ColorBase.menuBorderColor,
                                      percent:
                                          (state.querySnapshot.docs.length /
                                              14),
                                      progressColor: ColorBase.primaryGreen,
                                    );
                                  } else if (state is SelfReportListFailure) {
                                    return ErrorContent(error: state.error);
                                  } else {
                                    return Container();
                                  }
                                }),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      Dictionary.rememberMe,
                                      style: TextStyle(
                                          color: ColorBase.darkGrey,
                                          fontFamily: FontsFamily.roboto,
                                          fontSize: 12),
                                    ),
                                    BlocBuilder<SelfReportReminderBloc,
                                            SelfReportReminderState>(
                                        builder: (context, state) {
                                      if (state is SelfReportIsReminderLoaded) {
                                        isReminder = state.querySnapshot
                                            .get('remind_me');
                                        return FlutterSwitch(
                                          width: 50.0,
                                          height: 20.0,
                                          toggleColor: Colors.white,
                                          valueFontSize: 12.0,
                                          activeColor: ColorBase.primaryGreen,
                                          inactiveColor: ColorBase.disableText,
                                          toggleSize: 18.0,
                                          value: isReminder,
                                          onToggle: (val) {
                                            setState(() {
                                              isReminder = val;
                                              SelfReportReminderBloc().add(
                                                  SelfReportListUpdateReminder(
                                                      isReminder));
                                            });
                                          },
                                        );
                                      } else if (state
                                          is SelfReportReminderFailure) {
                                        return ErrorContent(error: state.error);
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    }),
                                  ],
                                ),
                              ]))),
              BlocBuilder<SelfReportListBloc, SelfReportListState>(
                  builder: (context, state) {
                if (state is SelfReportListLoaded) {
                  return Column(
                    children: _buildContent(state),
                  );
                } else if (state is SelfReportListFailure) {
                  return ErrorContent(error: state.error);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
            ],
          )),
    );
  }

  List<Widget> _buildContent(SelfReportListLoaded snapshot) {
    List<Widget> list = List();
    if (snapshot.querySnapshot.docs.length != 0) {
      for (var i = 0; i < snapshot.querySnapshot.docs.length; i++) {
        /// Get [documentID] to [listDocumentId]
        listDocumentId.add(snapshot.querySnapshot.docs[i].id);

        /// Delete duplicates number in list
        listDocumentId = listDocumentId.toSet().toList();
      }

      if (getField(snapshot.querySnapshot.docs[0], 'quarantine_date') == null) {
        /// Save ['created_at'] as [firstDay] for main parameter
        firstDay = DateTime.fromMillisecondsSinceEpoch(
            snapshot.querySnapshot.docs[0].get('created_at').seconds * 1000);
      } else {
        /// Save ['quarantine_date'] as [firstDay] for main parameter
        firstDay = DateTime.fromMillisecondsSinceEpoch(
            snapshot.querySnapshot.docs[0].get('quarantine_date').seconds *
                1000);
      }

      currentDay = DateTime.now();
    }

    for (int i = 0; i < 14; i++) {
      if (i != 0) {
        if (currentDay != null) {
          if (currentDay.day == firstDay.add(Duration(days: i)).day ||
              firstDay
                  .add(Duration(days: i))
                  .difference(currentDay)
                  .isNegative) {
            if (listDocumentId.contains('${i + 1}')) {
              textColor = ColorBase.grey800;
            } else {
              if (listDocumentId.contains('$i')) {
                textColor = ColorBase.grey800;
              } else {
                textColor = ColorBase.darkGrey;
              }
            }
          } else {
            textColor = ColorBase.darkGrey;
          }
        } else {
          textColor = ColorBase.darkGrey;
        }
      } else {
        textColor = ColorBase.grey800;
      }
      Column column = Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              /// Checking data is not first array
              if (i != 0) {
                /// Checking data if [currentDay] not null
                if (currentDay != null) {
                  if (currentDay.day == firstDay.add(Duration(days: i)).day ||
                      firstDay
                          .add(Duration(days: i))
                          .difference(currentDay)
                          .isNegative) {
                    /// [currentDay] same as the day user can fill the form
                    /// Checking data is already filled or not
                    if (listDocumentId.contains('${i + 1}')) {
                      /// Data is already filled
                      /// Move to detail screeen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelfReportDetailScreen(
                                '${i + 1}', widget.otherUID, widget.analytics)),
                      );
                    } else {
                      if (listDocumentId.contains('$i')) {
                        /// Move to form screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelfReportFormScreen(
                                analytics: widget.analytics,
                                otherUID: widget.otherUID,
                                dailyId: '${i + 1}',
                                location: widget.location)));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description:
                                      '${Dictionary.errorMessageDailyMonitoringOrder}$i',
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ));
                      }
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => DialogTextOnly(
                              description:
                                  '${Dictionary.errorMessageDailyMonitoring}${i + 1}',
                              buttonText: Dictionary.ok,
                              onOkPressed: () {
                                Navigator.of(context).pop();
                              },
                            ));
                  }
                } else {
                  /// Show dialog users cant input form
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogTextOnly(
                            description:
                                '${Dictionary.errorMessageDailyMonitoring}${i + 1}',
                            buttonText: Dictionary.ok,
                            onOkPressed: () {
                              Navigator.of(context).pop();
                            },
                          ));
                }
              } else {
                /// Data is first array
                /// Checking data is already filled or not
                if (listDocumentId.contains('${i + 1}')) {
                  /// Data is already filled
                  /// Move to detail screeen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelfReportDetailScreen(
                            '${i + 1}', widget.otherUID, widget.analytics)),
                  );
                } else {
                  /// Move to form screen
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelfReportFormScreen(
                          analytics: widget.analytics,
                          dailyId: '${i + 1}',
                          otherUID: widget.otherUID,
                          location: widget.location)));
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Text(
                                listDocumentId.contains('${i + 1}')
                                    ? "✅" + '  ${Dictionary.countDay}${i + 1}'
                                    : '' + '${Dictionary.countDay}${i + 1}',
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    fontFamily: FontsFamily.roboto),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            listDocumentId.contains('${i + 1}')
                                ? Dictionary.dailyMonitoringFilled
                                : Dictionary.dailyMonitoringUnfilled,
                            style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontFamily: FontsFamily.roboto),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: ColorBase.grey800,
                    size: 18,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              color: ColorBase.grey,
              thickness: 1,
            ),
          ),
        ],
      );

      list.add(column);
    }
    return list;
  }
}
