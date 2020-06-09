import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
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
import 'package:pikobar_flutter/screens/checkDistribution/components/CheckDistributionBanner.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/CheckDistributionCardFilter.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/CheckDistributionCardRadius.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class CheckDistributionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckdistributionBloc>(
      create: (context) => CheckdistributionBloc(
          checkDistributionReposity: CheckDistributionReposity()),
      child: CheckDistribution(),
    );
  }
}

class CheckDistribution extends StatefulWidget {
  @override
  _CheckDistributionState createState() => _CheckDistributionState();
}

class _CheckDistributionState extends State<CheckDistribution> {
  CheckdistributionBloc _checkdistributionBloc;

  String _address = '-';
  bool isFindOtherLocation;
  String latitude;
  String longitude;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.checkDistribution);

    _checkdistributionBloc = BlocProvider.of<CheckdistributionBloc>(context);

    isFindOtherLocation = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.checkDistribution),
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              child: Container(
                padding: EdgeInsets.all(Dimens.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Image.asset(
                        '${Environment.imageAssets}background_cekSebaran.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimens.padding, 0.0, Dimens.padding, 0.0),
                      child: Text(
                        Dictionary.checkLocationSpread,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          Dimens.padding, 10.0, Dimens.padding, 0.0),
                      child: Text(
                        Dictionary.checkLocationSpreadDesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0),
                      ),
                    ),

                    // SizedBox(height: 25),
                  ],
                ),
              ),
            ),
            BlocBuilder<CheckdistributionBloc, CheckdistributionState>(
              bloc: _checkdistributionBloc,
              builder: (context, state) {
                return state is CheckDistributionLoading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorBase.green),
                            )
                          ],
                        ),
                      )
                    : state is CheckDistributionLoaded
                        ? buildContent(state)
                        : state is CheckDistributionFailure
                            ? ErrorContent(error: state.error)
                            : Container();
              },
            ),

            // Box
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                padding: const EdgeInsets.all(Dimens.padding),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Card(
                      //   color: Color(0xFFF9EFD0),
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8)),
                      //   elevation: 0.1,
                      //   child: Container(
                      //       padding: EdgeInsets.all(Dimens.padding),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             Dictionary.disclaimer,
                      //             style: TextStyle(
                      //               fontFamily: FontsFamily.lato,
                      //               color: Colors.grey[600],
                      //               fontSize: 12.0,
                      //               fontWeight: FontWeight.bold,
                      //               height: 1.3,
                      //             ),
                      //           ),
                      //           SizedBox(height: 10),
                      //           Text(
                      //             Dictionary.informationLocation,
                      //             style: TextStyle(
                      //               fontFamily: FontsFamily.lato,
                      //               color: Colors.grey[600],
                      //               fontSize: 12.0,
                      //               height: 1.3,
                      //             ),
                      //           ),
                      //         ],
                      //       )),
                      // ),
                      // SizedBox(height: 22),
                      boxContainer(
                        Column(
                          children: <Widget>[
                            // box section address
                            // Container(
                            //   padding: const EdgeInsets.all(Dimens.padding),
                            //   child: Row(
                            //     children: <Widget>[
                            //       Image.asset(
                            //         '${Environment.iconAssets}pin.png',
                            //         scale: 1.5,
                            //       ),
                            //       SizedBox(width: 14),
                            //       Expanded(
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           mainAxisAlignment: MainAxisAlignment.center,
                            //           children: <Widget>[
                            //             Text(
                            //               Dictionary.currentLocationTitle,
                            //               style: TextStyle(
                            //                 fontFamily: FontsFamily.lato,
                            //                 color: Colors.grey[600],
                            //                 fontSize: 12.0,
                            //                 height: 1.2,
                            //               ),
                            //             ),
                            //             SizedBox(height: 4),
                            //             Text(
                            //               _address,
                            //               style: TextStyle(
                            //                 fontFamily: FontsFamily.lato,
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 14.0,
                            //                 height: 1.2,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            // Box section button

                            Container(
                              padding: const EdgeInsets.fromLTRB(Dimens.padding,
                                  8.0, Dimens.padding, Dimens.padding),
                              child: Column(
                                children: <Widget>[
                                  RoundedButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      title: Dictionary.checkCurrentLocation,
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: ColorBase.green,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .subhead
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                      onPressed: () async {
                                        bool hasToken =
                                            await AuthRepository().hasToken();
                                        if (!hasToken) {
                                          bool isLoggedIn = await Navigator.of(
                                                  context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) => LoginScreen(
                                                      title: Dictionary
                                                          .checkDistribution)));

                                          if (isLoggedIn != null &&
                                              isLoggedIn) {
                                            String id = await AuthRepository()
                                                .getToken();
                                            _handleLocation(
                                                isOther: false, id: id);
                                          }
                                        } else {
                                          String id =
                                              await AuthRepository().getToken();
                                          _handleLocation(
                                              isOther: false, id: id);
                                        }
                                      }),
                                  SizedBox(height: 10),
                                  OutlineButton(
                                      borderSide:
                                          BorderSide(color: Color(0xffEB5757)),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      color: Colors.white,
                                      onPressed: () {
                                        _handleLocation(isOther: true);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Center(
                                                child: Text(
                                              Dictionary.checkOtherLocation,
                                              style: TextStyle(
                                                  color: Color(0xffEB5757),
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: FontsFamily.lato),
                                            ))),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
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
                                  fontSize: 12.0,
                                  height: 1.3,
                                ),
                              ),
                              TextSpan(
                                  text: Dictionary.here,
                                  style: TextStyle(
                                    fontFamily: FontsFamily.lato,
                                    color: Colors.blue,
                                    fontSize: 12.0,
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
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget buildContent(CheckDistributionLoaded state) {
    print(state.record.detected.toString());
    return state.record.detected == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ErrorContent(error: Dictionary.unreachableLocation),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 30.0),
                child: Text(
                  Dictionary.cantFindLocation,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.lato,
                    fontSize: 14.0,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          )
        : Padding(
            padding: const EdgeInsets.only(
                top: 0, left: Dimens.padding, right: Dimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // build Section Location by radius
                CheckDistributionCardRadius(state: state),
                SizedBox(height: 20),
                Text(
                  '${Dictionary.locationKecamatanTitle}',
                  style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  Dictionary.locationKecamatanDesc,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.lato,
                    fontSize: 14.0,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: Dimens.padding),
                boxContainer(
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          onTap: (index) {
                            if (index == 0) {
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedFindByVillage);
                            } else if (index == 1) {
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedFindByDistricts);
                            }
                          },
                          labelColor: Colors.black,
                          indicatorColor: ColorBase.green,
                          indicatorWeight: 2.8,
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                Dictionary.village,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontsFamily.lato,
                                    fontSize: 13.0),
                              ),
                            ),
                            Tab(
                              child: Text(
                                Dictionary.districts,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontsFamily.lato,
                                    fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: MediaQuery.of(context).size.height * 0.20,
                          child: TabBarView(
                            children: <Widget>[
                              // show kelurahan / desa
                              CheckDistributionCardFilter(
                                region: state.record.currentLocation.namaKel,
                                countPositif:
                                    state.record.detected.desa.positif,
                                countOdp: state.record.detected.desa.odpProses,
                                countPdp: state.record.detected.desa.pdpProses,
                                typeRegion: Dictionary.village,
                              ),

                              // show kecamatan
                              CheckDistributionCardFilter(
                                region: state.record.currentLocation.namaKec,
                                countPositif: state.record.detected.kec.positif,
                                countOdp: state.record.detected.kec.odpProses,
                                countPdp: state.record.detected.kec.pdpProses,
                                typeRegion: Dictionary.districts,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // Widget buildList(CheckDistributionLoaded state) {

  // }

  Widget boxContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 10.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 1  horizontally
              1.0, // Move to bottom 1 Vertically
            ),
          )
        ],
      ),
      child: child,
    );
  }

  Future<void> _handleLocation({bool isOther = false, String id}) async {
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      await _actionFindLocation(isOther, id);
    } else {
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

  _checkDistribution(latitude, longitude, bool isOther, {String id}) {
    _checkdistributionBloc.add(LoadCheckDistribution(
        lat: latitude, long: longitude, id: id, isOther: isOther));
  }

  _actionFindLocation(bool isOther, String id) async {
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
      Position position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      if (position != null && position.latitude != null) {
        List<Placemark> placemarks = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);

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
        List<Placemark> placemarks = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);

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
