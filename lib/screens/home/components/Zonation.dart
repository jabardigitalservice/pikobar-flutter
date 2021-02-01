import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/blocs/locationPermission/location_permission_bloc.dart';
import 'package:pikobar_flutter/blocs/zonation/zonation_cubit.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionDetailScreen.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';
import 'package:pikobar_flutter/utilities/flushbar_helper.dart';

class Zonation extends StatefulWidget {
  Zonation({Key key}) : super(key: key);

  @override
  _ZonationState createState() => _ZonationState();
}

class _ZonationState extends State<Zonation> {
  String _address = '-';

  CheckDistributionBloc _checkDistributionBloc;
  Flushbar _flushbar = Flushbar();

  @override
  void initState() {
    super.initState();
    _checkDistributionBloc = BlocProvider.of<CheckDistributionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
        builder: (context, state) {
      return state is LocationPermissionLoaded
          ? state.isGranted
              ? _buildZonationBloc(context)
              : _buildDeniedContent()
          : Container();
    });
  }

  _buildDeniedContent() {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: EdgeInsets.only(
          left: Dimens.padding,
          right: Dimens.padding,
          top: Dimens.homeCardMargin),
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: EdgeInsets.all(Dimens.homeCardMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Dictionary.zonation,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Dimens.padding),
              child: Text(
                Dictionary.shareZonationInfo,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: FontsFamily.roboto,
                    color: ColorBase.netralGrey),
              ),
            ),
            RoundedButton(
                title: Dictionary.shareLocation,
                textStyle: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                color: ColorBase.green,
                elevation: 0.0,
                onPressed: () async {
                  AnalyticsHelper.setLogEvent(Analytics.tappedShareLocation);
                  await LocationService.initializeBackgroundLocation(context);
                })
          ],
        ),
      ),
    );
  }

  _buildZonationBloc(BuildContext context) {
    return FutureBuilder<Position>(
      future:
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          _getAddress(snapshot.data);

          return BlocProvider<ZonationCubit>(
            create: (_) => ZonationCubit()..loadZonation(snapshot.data),
            child: BlocBuilder<ZonationCubit, ZonationState>(
                builder: (context, state) {
              return state is ZonationLoading
                  ? _buildLoading()
                  : state is ZonationLoaded
                      ? _buildContent(state, snapshot.data)
                      : Container();
            }),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildLoading() {
    Size size = MediaQuery.of(context).size;
    return Skeleton(
      child: Container(
        width: size.width,
        height: 150.0,
        margin: EdgeInsets.only(
            left: Dimens.padding,
            right: Dimens.padding,
            top: Dimens.homeCardMargin),
        decoration: BoxDecoration(
            color: ColorBase.greyContainer,
            borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  _buildContent(ZonationLoaded state, Position position) {
    Size size = MediaQuery.of(context).size;
    CheckDistributionModel data = state.record;
    Color dotColor = Colors.transparent;
    String zone = '';
    String description;

    switch (data.zonaResiko.toUpperCase().replaceAll('RESIKO', 'RISIKO')) {
      case Dictionary.zoneHighRisk:
        dotColor = Colors.red;
        zone = StringUtils.capitalizeWord(Dictionary.zoneHighRisk);
        description = Dictionary.zoneRedDescription;
        break;
      case Dictionary.zoneMediumRisk:
        dotColor = Colors.orange;
        zone = StringUtils.capitalizeWord(Dictionary.zoneMediumRisk);
        description = Dictionary.zoneOrangeDescription;
        break;
      case Dictionary.zoneLowRisk:
        dotColor = Colors.yellow;
        zone = StringUtils.capitalizeWord(Dictionary.zoneLowRisk);
        description = Dictionary.zoneYellowDescription;
        break;
      case Dictionary.zoneNotAffected:
        dotColor = Colors.green;
        zone = StringUtils.capitalizeWord(Dictionary.zoneNotAffected);
        description = Dictionary.zoneGreenDescription;
        break;
    }

    return BlocListener<CheckDistributionBloc, CheckdistributionState>(
      listener: (context, state) async {
        if (state is CheckDistributionLoading ||
            state is CheckDistributionLoadingIsOther) {
          _flushbar = FlushHelper.loading()..show(context);
        } else if (state is CheckDistributionFailure) {
          await _flushbar.dismiss();

          showDialog(
              context: context,
              builder: (BuildContext context) => DialogTextOnly(
                    description: state.error.toString(),
                    buttonText: Dictionary.ok.toUpperCase(),
                    onOkPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                  ));
        } else if (state is CheckDistributionLoaded) {
          await _flushbar.dismiss();

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CheckDistributionDetail(state: state, address: _address)),
          );
        } else {
          await _flushbar.dismiss();
        }
      },
      child: Container(
        width: size.width,
        margin: EdgeInsets.only(
            left: Dimens.padding,
            right: Dimens.padding,
            top: Dimens.homeCardMargin),
        decoration: BoxDecoration(
            color: ColorBase.greyContainer,
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Icon(
                    Icons.circle,
                    size: 16,
                    color: dotColor,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${Dictionary.youAreIn} $zone',
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontsFamily.roboto,
                            fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Icon(
                            Icons.help_outline_outlined,
                            size: 16,
                            color: ColorBase.netralGrey,
                          ),
                        ),
                        onTap: () {
                          showTextBottomSheet(
                              context: context,
                              title: Dictionary.zonationSource,
                              message: Dictionary.sourceZonationInfo);
                        },
                      ),
                    ],
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
              BlocBuilder<CheckDistributionBloc, CheckdistributionState>(
                  builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: RoundedButton(
                        title: state is CheckDistributionLoading
                            ? Dictionary.loading
                            : Dictionary.checkAroundYou,
                        textStyle: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        color: ColorBase.green,
                        elevation: 0.0,
                        onPressed: state is CheckDistributionLoading
                            ? null
                            : () async {
                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedArroundYouLocation);
                                _checkDistributionBloc.add(
                                    LoadCheckDistribution(
                                        lat: position.latitude,
                                        long: position.longitude,
                                        isOther: false));
                              },
                      ),
                    ),
                    SizedBox(width: Dimens.padding),
                    Expanded(
                      child: RoundedButton(
                          title: state is CheckDistributionLoadingIsOther
                              ? Dictionary.loading
                              : Dictionary.checkOtherLocation,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.netralGrey),
                          color: Colors.white,
                          borderSide: BorderSide(color: ColorBase.disableText),
                          elevation: 0.0,
                          onPressed: state is CheckDistributionLoadingIsOther
                              ? null
                              : _otherLocation),
                    ),
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
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

      _address = stringAddress;
    }
  }

  _otherLocation() async {
    LatLng result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));

    /// set gecoder to show in location information
    final String address = await GeocoderRepository().getAddress(result);

    if (address != null) {
      _address = address;
    }

    /// find location
    if (result != null) {
      _checkDistributionBloc.add(LoadCheckDistribution(
          lat: result.latitude, long: result.longitude, isOther: true));

      // analytics
      AnalyticsHelper.setLogEvent(
          Analytics.tappedFindByLocation, <String, dynamic>{
        'latlong': '${result.latitude}, ${result.longitude}'
      });
    }
  }
}
