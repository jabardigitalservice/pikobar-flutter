import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckDistributionBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionDetailScreen.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionOtherScreen.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class CheckDistributionScreen extends StatelessWidget {
  CheckDistributionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckDistributionBloc>(
      create: (context) => CheckDistributionBloc(
          checkDistributionRepository: CheckDistributionRepository()),
      child: CheckDistribution(),
    );
  }
}

class CheckDistribution extends StatefulWidget {
  CheckDistribution({Key key}) : super(key: key);

  @override
  _CheckDistributionState createState() => _CheckDistributionState();
}

class _CheckDistributionState extends State<CheckDistribution> {
  CheckDistributionBloc _checkdistributionBloc;

  String _address = '-';
  bool isFindOtherLocation;
  String latitude;
  String longitude;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.checkDistribution);

    _checkdistributionBloc = BlocProvider.of<CheckDistributionBloc>(context);

    isFindOtherLocation = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.checkDistribution),
        backgroundColor: Colors.white,
        body: BlocListener<CheckDistributionBloc, CheckDistributionState>(
          listener: (BuildContext context, CheckDistributionState state) {
            // Show dialog error message
            // When check distribution failed to load
            if (state is CheckDistributionFailure) {
              showDialog(
                  context: context,
                  builder: (context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: "OK",
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
              Scaffold.of(context).hideCurrentSnackBar();
              // Move to detail screen
              // When check distribution successfully loaded
            } else if (state is CheckDistributionLoaded) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CheckDistributionDetail(
                        state: state, address: _address)),
              );
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(Dimens.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Image section
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Image.asset(
                          '${Environment.imageAssets}background_cekSebaran.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      // Title Section
                      Container(
                        margin: const EdgeInsets.fromLTRB(
                            Dimens.padding, 0, Dimens.padding, 0),
                        child: Text(
                          Dictionary.checkLocationSpread,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      // Description Section
                      Container(
                        margin: const EdgeInsets.fromLTRB(
                            Dimens.padding, 10, Dimens.padding, 0),
                        child: Text(
                          Dictionary.checkLocationSpreadDesc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ),

                      // const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),

              // Box
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(Dimens.padding),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Button Section
                        boxContainer(
                          Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    Dimens.padding,
                                    8,
                                    Dimens.padding,
                                    Dimens.padding),
                                child: BlocBuilder<CheckDistributionBloc,
                                    CheckDistributionState>(
                                  builder: (context, state) {
                                    return Column(
                                      children: <Widget>[
                                        ButtonTheme(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          height: 45,
                                          child: RaisedButton(
                                              color: state
                                                      is CheckDistributionLoading
                                                  ? Color(0xff828282)
                                                  : ColorBase.green,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.borderRadius),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  state is CheckDistributionLoading
                                                      ? Container(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                            strokeWidth: 1.5,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color(
                                                                        0xff27AE60)),
                                                          ),
                                                        )
                                                      : Container(),
                                                  state is CheckDistributionLoading
                                                      ? const SizedBox(
                                                          width: 10,
                                                        )
                                                      : Container(),
                                                  Text(
                                                      Dictionary
                                                          .checkCurrentLocation,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          // ignore: deprecated_member_use
                                                          .subhead
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14)),
                                                ],
                                              ),
                                              onPressed: () async {
                                                bool hasToken =
                                                    await AuthRepository()
                                                        .hasToken();

                                                /// Checking user is login
                                                if (!hasToken) {
                                                  /// Move to login screen
                                                  bool isLoggedIn = await Navigator
                                                          .of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginScreen(
                                                                  title: Dictionary
                                                                      .checkDistribution)));

                                                  if (isLoggedIn != null &&
                                                      isLoggedIn) {
                                                    String id =
                                                        await AuthRepository()
                                                            .getToken();
                                                    _handleLocation(
                                                        isOther: false, id: id);
                                                  }
                                                } else {
                                                  String id =
                                                      await AuthRepository()
                                                          .getToken();

                                                  /// Get user location
                                                  _handleLocation(
                                                      isOther: false, id: id);
                                                }
                                              }),
                                        ),
                                        const SizedBox(height: 10),
                                        OutlineButton(
                                            borderSide: BorderSide(
                                                color: Color(0xff27AE60)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckDistributionOtherScrenn()),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  state is CheckDistributionLoadingIsOther
                                                      ? Container(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                            strokeWidth: 1.5,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    Color(
                                                                        0xff27AE60)),
                                                          ),
                                                        )
                                                      : Container(),
                                                  state is CheckDistributionLoadingIsOther
                                                      ? const SizedBox(
                                                          width: 10,
                                                        )
                                                      : Container(),
                                                  Container(
                                                      child: Text(
                                                    Dictionary
                                                        .checkOtherLocation,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff27AE60),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            FontsFamily.lato),
                                                  )),
                                                ],
                                              ),
                                            )),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Info section
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: Dictionary.checkDistributionInfo,
                                  style: TextStyle(
                                    fontFamily: FontsFamily.lato,
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                                TextSpan(
                                    text: Dictionary.here,
                                    style: TextStyle(
                                      fontFamily: FontsFamily.lato,
                                      color: Colors.blue,
                                      fontSize: 12,
                                      height: 1.3,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, NavigationConstrants.Faq);
                                      })
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget boxContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 20, // soften the shadow
            spreadRadius: 10, //extend the shadow
            offset: Offset(
              1, // Move to right 1  horizontally
              1, // Move to bottom 1 Vertically
            ),
          )
        ],
      ),
      child: child,
    );
  }

  // Get user location by current location or pick in maps
  Future<void> _handleLocation({bool isOther = false, String id}) async {
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;
    // Check status permission
    if (await permissionService.status.isGranted) {
      // Get user location by current location or pick in maps
      await _actionFindLocation(isOther, id);
    } else {
      // Show permission dialog
      showDialog(
          context: context,
          builder: (context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationSpread,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isPermanentlyDenied) {
                    Platform.isAndroid
                        ? await AppSettings.openAppSettings()
                        : await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status,
                          isOther: isOther, id: id);
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

  // Get distribution from api
  _checkDistribution(latitude, longitude, bool isOther, {String id}) {
    _checkdistributionBloc.add(LoadCheckDistribution(
        lat: latitude, long: longitude, id: id, isOther: isOther));
  }

  _actionFindLocation(bool isOther, String id) async {
    /// Checking [isOther]
    /// When true pick location in maps
    if (isOther) {
      LatLng result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => LocationPicker()));

      /// set gecoder to show in location information
      final String address = await GeocoderRepository().getAddress(result);

      if (address != null) {
        setState(() {
          _address = address;
        });
      }

      /// find location
      if (result != null) {
        _checkDistribution(result.latitude, result.longitude, isOther);

        // analytics
        AnalyticsHelper.setLogEvent(
            Analytics.tappedFindByLocation, <String, dynamic>{
          'latlong': '${result.latitude}, ${result.longitude}'
        });
      }
    } else {
      // Pick location by current location
      Position position = await Geolocator.getLastKnownPosition();
      if (position != null && position.latitude != null) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks != null && placemarks.isNotEmpty) {
          final Placemark pos = placemarks[0];
          final stringAddress = pos.thoroughfare +
              ', ' +
              pos.locality +
              ', ' +
              pos.subAdministrativeArea;

          setState(() {
            _address = stringAddress;
          });

          // find location
          _checkDistribution(position.latitude, position.longitude, isOther,
              id: id);
        }
      } else {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks != null && placemarks.isNotEmpty) {
          final Placemark pos = placemarks[0];
          final stringAddress = pos.thoroughfare +
              ', ' +
              pos.locality +
              ', ' +
              pos.subAdministrativeArea;

          setState(() {
            _address = stringAddress;
          });

          // find location
          _checkDistribution(position.latitude, position.longitude, isOther,
              id: id);

          // analytics
          AnalyticsHelper.setLogEvent(
              Analytics.tappedFindByLocation, <String, dynamic>{
            'latlong': '${position.latitude}, ${position.longitude}'
          });
        }
      }
      // analytics
      AnalyticsHelper.setLogEvent(Analytics.tappedCheckCurrentLocation);
    }
  }

  void _onStatusRequested(BuildContext context, PermissionStatus statuses,
      {bool isOther, String id}) async {
    if (statuses.isGranted) {
      _actionFindLocation(isOther, id);
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }

  @override
  void dispose() {
    _checkdistributionBloc.close();
    super.dispose();
  }
}
