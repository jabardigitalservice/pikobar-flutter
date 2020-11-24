import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/blocs/locationPermission/location_permission_bloc.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionDetailScreen.dart';

class Zonation extends StatefulWidget {
  @override
  _ZonationState createState() => _ZonationState();
}

class _ZonationState extends State<Zonation> {
  String address = '-';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
        builder: (context, state) {
      return state is LocationPermissionLoaded
          ? state.isGranted
              ? _buildZonationBloc(context)
              : Container()
          : Container();
    });
  }

  _buildZonationBloc(BuildContext context) {
    return FutureBuilder<Position>(
      future:
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _getAddress(snapshot.data);

          BlocProvider.of<CheckDistributionBloc>(context).add(
              LoadCheckDistribution(
                  lat: snapshot.data.latitude,
                  long: snapshot.data.longitude,
                  isOther: false));

          return BlocBuilder<CheckDistributionBloc, CheckdistributionState>(
              builder: (context, state) {
            return state is CheckDistributionLoaded
                ? _buildContent(state)
                : Container();
          });
        } else {
          return Container();
        }
      },
    );
  }

  Container _buildContent(CheckDistributionLoaded state) {
    CheckDistributionModel data = state.record;
    Color dotColor = Colors.transparent;
    String zone = '';
    String description;

    switch (data.zonaResiko.toUpperCase()) {
      case Dictionary.zoneHighRisk:
        dotColor = Colors.red;
        zone = Dictionary.zoneColorRed;
        description = Dictionary.zoneRedDescription;
        break;
      case Dictionary.zoneMediumRisk:
        dotColor = Colors.orange;
        zone = Dictionary.zoneColorOrange;
        description = Dictionary.zoneOrangeDescription;
        break;
      case Dictionary.zoneLowRisk:
        dotColor = Colors.yellow;
        zone = Dictionary.zoneColorYellow;
        description = Dictionary.zoneYellowDescription;
        break;
      case Dictionary.zoneNotAffected:
        dotColor = Colors.green;
        zone = Dictionary.zoneColorGreen;
        description = Dictionary.zoneGreenDescription;
        break;
    }

    return Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Container(
          width: (MediaQuery.of(context).size.width),
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: ColorBase.greyContainer,
              borderRadius: BorderRadius.circular(8.0)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 16,
                      color: dotColor,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text(
                        '${Dictionary.youAreIn} $zone',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontsFamily.roboto,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimens.padding),
                  child: RichText(
                    text: TextSpan(
                      text: description,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontsFamily.roboto,
                          color: ColorBase.netralGrey),
                      children: [
                        TextSpan(
                          text: Dictionary.zoneOther,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontsFamily.roboto,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        title: Dictionary.checkAroundYou,
                        textStyle: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        color: ColorBase.green,
                        elevation: 0.0,
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckDistributionDetail(state, address),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: Dimens.padding),
                    Expanded(
                      child: RoundedButton(
                          title: Dictionary.checkOtherLocation,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.netralGrey),
                          color: Colors.white,
                          borderSide: BorderSide(color: ColorBase.disableText),
                          elevation: 0.0,
                          onPressed: () {}),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  _getAddress(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      final stringAddress = pos.thoroughfare +
          ', ' +
          pos.locality +
          ', ' +
          pos.subAdministrativeArea;

      address = stringAddress;
    }
  }
}
