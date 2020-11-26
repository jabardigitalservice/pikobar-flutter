import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/ContactHistoryScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationListScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportOption.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';

class SelfReportScreen extends StatefulWidget {
  @override
  _SelfReportScreenState createState() => _SelfReportScreenState();
}

class _SelfReportScreenState extends State<SelfReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationAuthenticated profileLoaded;

  // ignore: close_sinks
  AuthenticationBloc _authenticationBloc;
  LatLng latLng;
  String addressMyLocation;
  bool hasLogin = false;
  bool isLocationChange = false;

  @override
  void initState() {
    addressMyLocation = '-';
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) => _authenticationBloc =
                AuthenticationBloc(authRepository: _authRepository)
                  ..add(AppStarted())),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            // Show an error message dialog when login,
            // except for errors caused by users who were canceled to login.
            if (!state.error.contains('ERROR_ABORTED_BY_USER') &&
                !state.error.contains('NoSuchMethodError')) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: "OK",
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
            }
            _scaffoldKey.currentState.hideCurrentSnackBar();
            setState(() {
              hasLogin = false;
            });
          }
          if (state is AuthenticationLoading) {
            // Show dialog when loading
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Row(
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      child: Text(Dictionary.loading),
                    )
                  ],
                ),
                duration: Duration(seconds: 15),
              ),
            );
            setState(() {
              hasLogin = false;
            });
          }
          if (state is AuthenticationUnauthenticated) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            setState(() {
              hasLogin = false;
            });
          }

          if (state is AuthenticationAuthenticated) {
            _scaffoldKey.currentState.hideCurrentSnackBar();
            setState(() {
              profileLoaded = state;
              hasLogin = true;
            });
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar.defaultAppBar(
              title: Dictionary.titleSelfReport,
            ),
            body:
                BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (
              BuildContext context,
              AuthenticationState state,
            ) {
              if (state is AuthenticationUnauthenticated ||
                  state is AuthenticationLoading) {
                // When user is not login show login screen
                return OnBoardingLoginScreen(
                  authenticationBloc: _authenticationBloc,
                );
              } else if (state is AuthenticationAuthenticated ||
                  state is AuthenticationLoading) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(kUsers)
                        .doc(profileLoaded != null
                            ? profileLoaded.record.uid
                            : null)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError)
                        // Show error ui when unable to get data
                        return ErrorContent(error: snapshot.error);
                      switch (snapshot.connectionState) {
                        // Show loading while get data
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          // Show content when data is ready
                          return snapshot.data.exists
                              ? _buildContent(snapshot)
                              : _buildContent(null);
                      }
                    });
              } else if (state is AuthenticationFailure ||
                  state is AuthenticationLoading) {
                return OnBoardingLoginScreen(
                  authenticationBloc: _authenticationBloc,
                );
              } else {
                return Container();
              }
            })),
      ),
    );
  }

  /// Function for check if profile not complete user must fill profile in menu edit profile
  bool _isProfileUserNotComplete(AsyncSnapshot<DocumentSnapshot> state) {
    if (state != null &&
        getField(state.data, 'name').toString().isNotEmpty &&
        getField(state.data, 'nik').toString().isNotEmpty &&
        getField(state.data, 'email').toString().isNotEmpty &&
        getField(state.data, 'phone_number').toString().isNotEmpty &&
        getField(state.data, 'address').toString().isNotEmpty &&
        getField(state.data, 'birthdate').toString().isNotEmpty &&
        getField(state.data, 'gender').toString().isNotEmpty &&
        getField(state.data, 'city_id').toString().isNotEmpty &&
        getField(state.data, 'location').toString().isNotEmpty &&
        getField(state.data, 'name') != null &&
        getField(state.data, 'nik') != null &&
        getField(state.data, 'email') != null &&
        getField(state.data, 'phone_number') != null &&
        getField(state.data, 'address') != null &&
        getField(state.data, 'birthdate') != null &&
        getField(state.data, 'gender') != null &&
        getField(state.data, 'city_id') != null &&
        getField(state.data, 'location') != null) {
      return false;
    } else {
      return true;
    }
  }

  /// Function for build widget content
  Widget _buildContent(AsyncSnapshot<DocumentSnapshot> state) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          hasLogin
              ? !HealthCheck().isUserHealty(
                          getField(state.data, 'health_status')) &&
                      _isProfileUserNotComplete(state)
                  ? _buildAnnounceProfileNotComplete(state)
                  : Container()
              : Container(),
          SizedBox(
            height: 10,
          ),
          _buildLocation(state),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}calendar_disable.png',
                  '${Environment.iconAssets}calendar_enable.png',
                  Dictionary.dailyMonitoring,
                  2,
                  //for give condition onPressed in widget _buildContainer
                  () {
                if (latLng == null ||
                    addressMyLocation == '-' ||
                    addressMyLocation.isEmpty ||
                    addressMyLocation == null) {
                  Fluttertoast.showToast(
                      msg: Dictionary.alertLocationSelfReport,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16.0);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelfReportOption(latLng)));
                }
              },
                  // condition for check if user login and user complete fill that profile
                  // and health status is not healthy user can access for press the button in _buildContainer
                  hasLogin
                      ? !_isProfileUserNotComplete(state) &&
                              !HealthCheck().isUserHealty(
                                  getField(state.data, 'health_status'))
                          ? hasLogin
                          : false
                      : false),
              _buildContainer(
                  '${Environment.iconAssets}history_contact_disable.png',
                  '${Environment.iconAssets}history_contact_enable.png',
                  Dictionary.historyContact,
                  2, () {
                if (latLng == null ||
                    addressMyLocation == '-' ||
                    addressMyLocation.isEmpty ||
                    addressMyLocation == null) {
                  Fluttertoast.showToast(
                      msg: Dictionary.alertLocationSelfReport,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16.0);
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ContactHistoryScreen()));
                }
              },
                  hasLogin
                      ? !_isProfileUserNotComplete(state) &&
                              !HealthCheck().isUserHealty(
                                  getField(state.data, 'health_status'))
                          ? hasLogin
                          : false
                      : false),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          EducationListScreen()
        ],
      ),
    );
  }

  ///Function for build widget announcement if profile user not complete
  Widget _buildAnnounceProfileNotComplete(
      AsyncSnapshot<DocumentSnapshot> state) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xffEB5757), borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.exclamationTriangle,
                        size: 12,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text(
                        Dictionary.profileNotComplete,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.lato),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: Dictionary.descProfile1,
                        style: TextStyle(
                            height: 1.7,
                            fontSize: 12.0,
                            color: Colors.white,
                            fontFamily: FontsFamily.lato),
                      ),
                      TextSpan(
                          text: Dictionary.descProfile2,
                          style: TextStyle(
                              fontSize: 12.0,
                              height: 1.7,
                              color: Colors.white,
                              fontFamily: FontsFamily.lato,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, NavigationConstrants.Edit,
                                  arguments: state);
                            }),
                      TextSpan(
                        text: Dictionary.descProfile3,
                        style: TextStyle(
                            fontSize: 12.0,
                            height: 1.7,
                            color: Colors.white,
                            fontFamily: FontsFamily.lato),
                      ),
                    ]),
                  ))
                ]),
          ),
        ],
      ),
    );
  }

  ///Function for build widget location user
  Widget _buildLocation(AsyncSnapshot<DocumentSnapshot> state) {
    if (!isLocationChange) {
      if (state != null) {
        if (getField(state.data, 'address') != null) {
          addressMyLocation = getField(state.data, 'address').toString();
        }
        if (getField(state.data, 'location') != null) {
          latLng = LatLng(state.data['location'].latitude,
              state.data['location'].longitude);
        }
      }
    }

    return GestureDetector(
      child: Card(
        elevation: 0,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${Dictionary.currentLocationTitleSelfReport}',
                    style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                      height: 1.2,
                    ),
                  ),
                  Container(
                      child: Icon(
                    Icons.expand_more,
                    color: Colors.black,
                    size: 17,
                  )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    '${Environment.iconAssets}pin_location_red.png',
                    scale: 3,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      addressMyLocation,
                      style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        hasLogin
            ? !_isProfileUserNotComplete(state) &&
                    !HealthCheck()
                        .isUserHealty(getField(state.data, 'health_status'))
                ? _handleLocation()
                // ignore: unnecessary_statements
                : null
            // ignore: unnecessary_statements
            : null;
      },
    );
  }

  /// Function for build widget button self report
  _buildContainer(String imageDisable, String imageEnable, String title,
      int length, GestureTapCallback onPressed, bool isShowMenu) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: OutlineButton(
        splashColor: Colors.green,
        highlightColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 30, bottom: 30),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 60,
                  child: Image.asset(isShowMenu ? imageEnable : imageDisable)),
              Container(
                margin: EdgeInsets.only(top: 15, left: 5.0, right: 5.0),
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xff333333),
                        fontFamily: FontsFamily.lato)),
              )
            ],
          ),
        ),
        onPressed: isShowMenu ? onPressed : null,
      ),
    ));
  }

  /// Function to get location user
  Future<void> _handleLocation() async {
    //Checking permission status
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      // Permission allowed
      await _openLocationPicker();
    } else {
      // Permission disallowed
      // Show dialog to ask permission
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationSpread,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isDenied) {
                    await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status);
                    });
                  }
                },
                onCancelPressed: () {
                  AnalyticsHelper.setLogEvent(
                      Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  // Function to get lat long user and auto complete address field
  Future<void> _openLocationPicker() async {
    latLng = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));
    final String address = await GeocoderRepository().getAddress(latLng);
    if (address != null) {
      setState(() {
        isLocationChange = true;
        addressMyLocation = address;
      });
    }
  }

  // Function to get status for access location
  void _onStatusRequested(
      BuildContext context, PermissionStatus statuses) async {
    if (statuses.isGranted) {
      _openLocationPicker();
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }
}
