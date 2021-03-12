import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportList/SelfReportListBloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportReminder/SelfReportReminderBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportDetailScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportFormScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';

class SelfReportList extends StatefulWidget {
  final LatLng location;
  final String otherUID;
  final String analytics;
  final String cityId;
  final bool isHealthStatusChange;

  SelfReportList(
      {Key key,
      this.location,
      this.analytics,
      this.otherUID,
      this.cityId,
      this.isHealthStatusChange})
      : super(key: key);

  @override
  _SelfReportListState createState() => _SelfReportListState();
}

class _SelfReportListState extends State<SelfReportList> {
  bool isReminder;
  List<dynamic> listDocumentId = [];
  DateTime firstDay, currentDay;
  Color textColor;
  ScrollController _scrollController;
  final OverlayTutorialController _controller = OverlayTutorialController();
  final addButtonKey = GlobalKey(),
      counterTextKey = GlobalKey(),
      resetKey = GlobalKey();
  bool isTouchDisable = false;
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(widget.analytics);
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  showTutorial() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.showOverlayTutorial();
    });
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: OverlayTutorial(
      context: context,
      controller: _controller,
      overlayTutorialEntries: <OverlayTutorialEntry>[
        OverlayTutorialCustomShapeEntry(
          widgetKey: resetKey,
          shapeBuilder: (rect, path) {
            path = Path.combine(
              PathOperation.difference,
              path,
              Path()
                ..addOval(Rect.fromLTWH(
                  rect.left - 10,
                  rect.top - 10,
                  80,
                  80,
                )),
            );
            return path;
          },
        ),
      ],
      overlayColor: Color(0xff006430).withOpacity(0.9),
      overlayChildren: <Widget>[
        Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 20,
            child: Column(
              children: [
                Text('Anda telah melewati masa 14 \nhari lapor mandiri',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.white,
                        fontFamily: FontsFamily.roboto,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                        fontSize: 24)),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Untuk melakukan laporan mandiri lagi, \nsilakan lakukan reset melalui tombol titik tiga \ndi pojok kanan atas',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: Colors.white,
                        fontFamily: FontsFamily.roboto,
                        height: 1.5,
                        fontSize: 16)),
              ],
            )),
        Positioned(
          child: Row(
            children: [
              FlatButton(
                minWidth: 1,
                onPressed: () {
                  _controller.hideOverlayTutorial();
                  setState(() {
                    isTouchDisable = false;
                  });
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          left: 0,
        ),
        Positioned(
          child: Row(
            children: [
              FlatButton(
                minWidth: 1,
                onPressed: () {
                  _controller.hideOverlayTutorial();
                  showResetButton();

                  setState(() {
                    isTouchDisable = false;
                  });
                },
                child: Icon(Icons.more_horiz, color: Colors.white),
              ),
            ],
          ),
          right: 0,
        ),
        Positioned(
          child: FlatButton(
            minWidth: 1,
            onPressed: () {
              _controller.hideOverlayTutorial();
              setState(() {
                isTouchDisable = false;
              });
            },
            child: Text('Skip',
                style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                    fontFamily: FontsFamily.roboto,
                    height: 1.5,
                    fontSize: 14)),
          ),
          right: 20,
          bottom: 20,
        ),
      ],
      child: AbsorbPointer(
        absorbing: isTouchDisable,
        child: Scaffold(
          appBar: CustomAppBar.animatedAppBar(
            actions: [
              IconButton(
                  key: resetKey,
                  icon: Icon(Icons.more_horiz, color: Colors.black),
                  onPressed: () {
                    showResetButton();
                  })
            ],
            showTitle: _showTitle,
            title: widget.otherUID != null
                ? Dictionary.reportForOther
                : Dictionary.reportForMySelf,
          ),
          backgroundColor: Colors.white,
          body: MultiBlocProvider(
              providers: [
                BlocProvider<SelfReportReminderBloc>(
                  create: (context) => SelfReportReminderBloc()
                    ..add(SelfReportReminderListLoad()),
                ),
                BlocProvider<SelfReportListBloc>(
                  create: (context) => SelfReportListBloc()
                    ..add(SelfReportListLoad(otherUID: widget.otherUID)),
                ),
              ],
              child: BlocListener<SelfReportListBloc, SelfReportListState>(
                listener: (context, state) {
                  if (state is SelfReportListLoaded) {
                    if (widget.isHealthStatusChange) {
                      print('health status');
                      setState(() {
                        isTouchDisable = true;
                      });
                      showTutorial();
                    } else if (DateTime.now()
                            .difference(DateTime.fromMillisecondsSinceEpoch(
                                state.querySnapshot.docs.last
                                        .get('created_at')
                                        .seconds *
                                    1000))
                            .inDays >=
                        14) {
                      print('14 hari');
                      setState(() {
                        isTouchDisable = true;
                      });
                      showTutorial();
                    }
                  }
                },
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    AnimatedOpacity(
                      opacity: _showTitle ? 0.0 : 1.0,
                      duration: Duration(milliseconds: 250),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20),
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
                            margin: const EdgeInsets.all(Dimens.contentPadding),
                            decoration: BoxDecoration(
                                color: ColorBase.grey,
                                borderRadius: BorderRadius.circular(8)),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Padding(
                                padding:
                                    const EdgeInsets.all(Dimens.contentPadding),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      BlocBuilder<SelfReportListBloc,
                                              SelfReportListState>(
                                          builder: (BuildContext context,
                                              SelfReportListState state) {
                                        if (state is SelfReportListLoaded) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                Dictionary
                                                    .dailyMonitoringProgress,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontsFamily.roboto,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorBase.netralGrey,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                '${((state.querySnapshot.docs.length / 14) * 100).toStringAsPrecision(3)}%',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontsFamily.roboto,
                                                    color:
                                                        ColorBase.primaryGreen,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              )
                                            ],
                                          );
                                        } else if (state
                                            is SelfReportListFailure) {
                                          return ErrorContent(
                                              error: state.error);
                                        } else {
                                          return Container();
                                        }
                                      }),
                                      BlocBuilder<SelfReportListBloc,
                                              SelfReportListState>(
                                          builder: (BuildContext context,
                                              SelfReportListState state) {
                                        if (state is SelfReportListLoaded) {
                                          return LinearPercentIndicator(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            lineHeight: 8.0,
                                            backgroundColor:
                                                ColorBase.menuBorderColor,
                                            percent: (state
                                                    .querySnapshot.docs.length /
                                                14),
                                            progressColor:
                                                ColorBase.primaryGreen,
                                          );
                                        } else if (state
                                            is SelfReportListFailure) {
                                          return ErrorContent(
                                              error: state.error);
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
                                              builder: (BuildContext context,
                                                  SelfReportReminderState
                                                      state) {
                                            if (state
                                                is SelfReportIsReminderLoaded) {
                                              isReminder = state.querySnapshot
                                                  .get('remind_me');
                                              return FlutterSwitch(
                                                width: 50.0,
                                                height: 20.0,
                                                toggleColor: Colors.white,
                                                valueFontSize: 12.0,
                                                activeColor:
                                                    ColorBase.primaryGreen,
                                                inactiveColor:
                                                    ColorBase.disableText,
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
                                              return ErrorContent(
                                                  error: state.error);
                                            } else {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }
                                          }),
                                        ],
                                      ),
                                    ]))),
                    BlocBuilder<SelfReportListBloc, SelfReportListState>(
                        builder:
                            (BuildContext context, SelfReportListState state) {
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
                ),
              )),
        ),
      ),
    ));
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
                                cityId: widget.cityId,
                                reportId: '${i + 1}',
                                otherUID: widget.otherUID,
                                analytics: widget.analytics)),
                      );
                    } else {
                      if (listDocumentId.contains('$i')) {
                        /// Move to form screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelfReportFormScreen(
                                cityId: widget.cityId,
                                analytics: widget.analytics,
                                otherUID: widget.otherUID,
                                dailyId: '${i + 1}',
                                location: widget.location)));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => DialogTextOnly(
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
                        builder: (context) => DialogTextOnly(
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
                      builder: (context) => DialogTextOnly(
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
                            cityId: widget.cityId,
                            reportId: '${i + 1}',
                            otherUID: widget.otherUID,
                            analytics: widget.analytics)),
                  );
                } else {
                  /// Move to form screen
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelfReportFormScreen(
                          cityId: widget.cityId,
                          analytics: widget.analytics,
                          dailyId: '${i + 1}',
                          otherUID: widget.otherUID,
                          location: widget.location)));
                }
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
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
                          const SizedBox(
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
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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

  showResetButton() {
    showWidgetBottomSheet(
      context: context,
      isScrollControlled: true,
      child: Center(
        child: FlatButton(
          minWidth: 1,
          onPressed: () {
            showConfirmDialog();
          },
          child: Text('Reset Laporan',
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.red[400],
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                  fontSize: 16)),
        ),
      ),
    );
  }

  showConfirmDialog() {
    return showWidgetBottomSheet(
      context: context,
      isScrollControlled: true,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 44.0, vertical: Dimens.verticalPadding),
            child: Image.asset(
              '${Environment.imageAssets}warning_image.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Apakah Anda yakin?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Laporan Anda tidak bisa diakses kembali \nsetelah Reset. Anda akan mulai laporan dari \nhari pertama',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontsFamily.roboto,
                height: 1.5,
                fontSize: 12.0,
                color: Colors.grey[600]),
          ),
          SizedBox(height: 24.0),
          RoundedButton(
              borderRadius: BorderRadius.circular(10),
              title: 'Reset',
              textStyle: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              color: Colors.red[400],
              elevation: 0.0,
              onPressed: () {}),
          SizedBox(height: 10.0),
          RoundedButton(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: ColorBase.disableText),
              title: Dictionary.cancel,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
              color: Colors.white,
              elevation: 0.0,
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      ),
    );
  }
}
