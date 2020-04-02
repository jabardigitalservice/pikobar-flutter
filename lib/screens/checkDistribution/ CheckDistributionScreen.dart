import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/CheckDistributionRepository.dart';

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

  @override
  void initState() {
    _checkdistributionBloc = BlocProvider.of<CheckdistributionBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Dictionary.checkDistribution)),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(Dimens.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // box section banner
                  Container(
                    height: 100.0,
                    child: Card(
                      color: Color(0xFFF2C94C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    Dictionary.checkDistributionTitle,
                                    style: TextStyle(
                                        fontFamily: FontsFamily.productSans,
                                        fontSize: 16.0,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    Dictionary.checkDistributionSubTitle,
                                    style: TextStyle(
                                      fontFamily: FontsFamily.productSans,
                                      fontSize: 12.0,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Image.asset(
                              '${Environment.imageAssets}people_corona2.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  boxContainer(
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          top: Dimens.padding, left: 5, right: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          // box section address
                          Container(
                            padding: const EdgeInsets.all(Dimens.padding),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  '${Environment.iconAssets}pin.png',
                                  scale: 1.5,
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        Dictionary.currentLocationTitle,
                                        style: TextStyle(
                                          fontFamily: FontsFamily.productSans,
                                          color: Colors.grey[600],
                                          fontSize: 12.0,
                                          height: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _address,
                                        style: TextStyle(
                                          fontFamily: FontsFamily.productSans,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          // Box section button
                          Container(
                            padding: const EdgeInsets.fromLTRB(Dimens.padding,
                                8.0, Dimens.padding, Dimens.padding),
                            child: Column(
                              children: <Widget>[
                                RoundedButton(
                                    minWidth: MediaQuery.of(context).size.width,
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
                                    onPressed: () {
                                      _handleLocation();
                                    }),
                                SizedBox(height: 10),
                                RoundedButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    title: Dictionary.checkOtherLocation,
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subhead
                                        .copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                    onPressed: () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 25),
                ],
              ),
            ),
            BlocBuilder<CheckdistributionBloc, CheckdistributionState>(
              bloc: _checkdistributionBloc,
              builder: (context, state) {
                return state is CheckDistributionLoading
                    ? Column(
                        children: <Widget>[
                          CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorBase.green))
                        ],
                      )
                    : state is CheckDistributionLoaded
                        ? buildContent(state)
                        : state is CheckDistributionFailure
                            ? ErrorContent(error: state.error)
                            : Container();
              },
            )
          ],
        ));
  }

  Widget buildContent(CheckDistributionLoaded state) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 10, left: Dimens.padding, right: Dimens.padding),
      child: Column(
        children: <Widget>[
          // build Positif
          buildResult(
              Dictionary.positifTitle +
                  ': ' +
                  state.record.detected.radius.positif.toString(),
              Dictionary.positifString,
              'bg-positif-land.png',
              state.record.detected.radius.positif > 0),
          SizedBox(height: 10),

          // build PDP
          buildResult(
              Dictionary.pdpTitle +
                  ': ' +
                  state.record.detected.radius.pdpProses.toString(),
              Dictionary.pdpString,
              'bg-pdp-land.png',
              state.record.detected.radius.pdpProses > 0),
          SizedBox(height: 10),

          // build ODP
          buildResult(
              Dictionary.odpTitle +
                  ': ' +
                  state.record.detected.radius.odpProses.toString(),
              Dictionary.odpString,
              'bg-odp-land.png',
              state.record.detected.radius.odpProses > 0),

          // Box
          Container(
            padding: const EdgeInsets.all(24.0),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  Dictionary.checkDistributionInfo,
                  style: TextStyle(
                    fontFamily: FontsFamily.productSans,
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                )),
          )
        ],
      ),
    );
  }

  Widget buildResult(
      String title, String description, String image, bool isNumberAvailable) {
    return boxContainer(
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        child: Container(
          decoration: isNumberAvailable
              ? BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('${Environment.imageAssets}/$image'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                )
              : BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    color: isNumberAvailable ? Colors.white : Colors.black,
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: FontsFamily.productSans,
                    color: isNumberAvailable ? Colors.white : Colors.grey[600],
                    fontSize: 12.0,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> _handleLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
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

          _checkdistributionBloc.add(LoadCheckDistribution(
              lat: position.latitude, long: position.longitude));

          // _checkdistributionBloc.add(LoadCheckDistribution(lat: '12312', long: '132'));
          // print(stringAddress);
        }
        // Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');

      } else {
        // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');
      }

      // AnalyticsHelper.setLogEvent(Analytics.tappedSpreadCheck);

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
                onOkPressed: () {
                  Navigator.of(context).pop();
                  PermissionHandler().requestPermissions(
                      [PermissionGroup.location]).then((status) {
                    _onStatusRequested(context, status);
                  });
                },
                onCancelPressed: () {
                  // AnalyticsHelper.setLogEvent(Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  void _onStatusRequested(BuildContext context,
      Map<PermissionGroup, PermissionStatus> statuses) async {
    final statusLocation = statuses[PermissionGroup.location];
    if (statusLocation == PermissionStatus.granted) {
      _handleLocation();
      // AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      // AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }
}
