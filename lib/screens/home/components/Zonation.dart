import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/checkDistribution/CheckDistributionBloc.dart';
import 'package:pikobar_flutter/blocs/zonation/zonation_cubit.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionDetailScreen.dart';
import 'package:pikobar_flutter/screens/checkDistribution/CheckDistributionOtherScreen.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';
import 'package:pikobar_flutter/utilities/flushbar_helper.dart';

class Zonation extends StatefulWidget {
  const Zonation({Key key}) : super(key: key);

  @override
  _ZonationState createState() => _ZonationState();
}

class _ZonationState extends State<Zonation> {
  String _address = '-';

  CheckDistributionBloc _checkDistributionBloc;
  ZonationCubit _zonationCubit;
  Flushbar _flushbar;

  @override
  void initState() {
    super.initState();
    _flushbar = Flushbar();
    _checkDistributionBloc = BlocProvider.of<CheckDistributionBloc>(context);
  }

  @override
  Widget build(BuildContext context) => BlocProvider<ZonationCubit>(
        create: (_) => _zonationCubit = ZonationCubit(),
        child: BlocListener<ZonationCubit, ZonationState>(
          listener: (_, state) async {
            if (state is ZonationLoading) {
              _flushbar = FlushHelper.loading()..show(context);
            } else if (state is ZonationFailure) {
              await _flushbar.dismiss();

              await showDialog(
                  context: context,
                  builder: (context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: Dictionary.ok.toUpperCase(),
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
            } else if (state is ZonationLoaded) {
              await _getAddress(state.position);

              await _flushbar.dismiss();
            } else {
              await _flushbar.dismiss();
            }
          },
          child: BlocBuilder<ZonationCubit, ZonationState>(
              builder: (BuildContext context, ZonationState state) =>
                  state is ZonationLoaded
                      ? _buildContent(state)
                      : _buildIntroContent(state)),
        ),
      );

  Widget _buildIntroContent(ZonationState state) {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: const EdgeInsets.only(
          left: Dimens.padding,
          right: Dimens.padding,
          top: Dimens.homeCardMargin),
      decoration: BoxDecoration(
          color: ColorBase.greyContainer,
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.homeCardMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 6),
                    child: Icon(
                      Icons.location_on,
                      color: ColorBase.netralGrey,
                    )),
                const SizedBox(
                  width: Dimens.padding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Dictionary.introZoneTitle,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: FontsFamily.roboto,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(Dictionary.shareZonationInfo,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: FontsFamily.roboto,
                            color: ColorBase.netralGrey)),
                    const SizedBox(
                      height: Dimens.padding,
                    ),
                  ],
                ),
              ],
            ),
            RoundedButton(
                title: state is ZonationLoading
                    ? Dictionary.loading
                    : Dictionary.checkZone,
                textStyle: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                color: ColorBase.green,
                elevation: 0,
                onPressed: state is ZonationLoading
                    ? null
                    : () async {
                        bool isGranted = await Permission
                                .locationAlways.status.isGranted ||
                            await Permission.locationWhenInUse.status.isGranted;

                        await AnalyticsHelper.setLogEvent(
                            Analytics.tappedCheckZone);

                        if (isGranted) {
                          _zonationCubit.loadZonation();
                        } else {
                          await LocationService.initializeBackgroundLocation(
                              context);
                        }
                      })
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ZonationLoaded state) {
    final Size size = MediaQuery.of(context).size;
    final CheckDistributionModel data = state.record;
    final Position position = state.position;
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

    return BlocListener<CheckDistributionBloc, CheckDistributionState>(
      listener: (BuildContext context, CheckDistributionState state) async {
        if (state is CheckDistributionLoading ||
            state is CheckDistributionLoadingIsOther) {
          _flushbar = FlushHelper.loading();
          await _flushbar.show(context);
        } else if (state is CheckDistributionFailure) {
          await _flushbar.dismiss();

          await showDialog(
              context: context,
              builder: (context) => DialogTextOnly(
                    description: state.error.toString(),
                    buttonText: Dictionary.ok.toUpperCase(),
                    onOkPressed: () {
                      Navigator.of(context).pop(); // To close the dialog
                    },
                  ));
        } else if (state is CheckDistributionLoaded) {
          await _flushbar.dismiss();

          await Navigator.push(
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
        margin: const EdgeInsets.only(
            left: Dimens.padding,
            right: Dimens.padding,
            top: Dimens.homeCardMargin),
        decoration: BoxDecoration(
            color: ColorBase.greyContainer,
            borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Icon(
                    Icons.circle,
                    size: 16,
                    color: dotColor,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                          padding: const EdgeInsets.symmetric(horizontal: 6),
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
                margin: const EdgeInsets.symmetric(vertical: Dimens.padding),
                child: RichText(
                  text: TextSpan(
                    text: description,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: FontsFamily.roboto,
                        color: ColorBase.netralGrey),
                    children: <TextSpan>[
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
              BlocBuilder<CheckDistributionBloc, CheckDistributionState>(
                  builder:
                      (BuildContext context, CheckDistributionState state) {
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: RoundedButton(
                        title: state is CheckDistributionLoading
                            ? Dictionary.loading
                            : Dictionary.checkAroundYou,
                        textStyle: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        color: ColorBase.green,
                        elevation: 0,
                        onPressed: state is CheckDistributionLoading
                            ? null
                            : () async {
                                await AnalyticsHelper.setLogEvent(
                                    Analytics.tappedArroundYouLocation);
                                _checkDistributionBloc.add(
                                    LoadCheckDistribution(
                                        lat: position.latitude,
                                        long: position.longitude,
                                        isOther: false));
                              },
                      ),
                    ),
                    const SizedBox(width: Dimens.padding),
                    Expanded(
                      child: RoundedButton(
                          title: state is CheckDistributionLoadingIsOther
                              ? Dictionary.loading
                              : Dictionary.checkOtherLocation,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ColorBase.netralGrey),
                          color: Colors.white,
                          borderSide: BorderSide(color: ColorBase.disableText),
                          elevation: 0,
                          onPressed: state is CheckDistributionLoadingIsOther
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CheckDistributionOtherScrenn()),
                                  );
                                }),
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

  Future<void> _getAddress(Position position) async {
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark pos = placemarks[0];
      _address =
          '${pos.thoroughfare}, ${pos.locality}, ${pos.subAdministrativeArea}';
    }
  }

  Future<void> _otherLocation() async {
    final LatLng result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LocationPicker()));

    /// set gecoder to show in location information
    String address = await GeocoderRepository().getAddress(result);

    if (address != null) {
      _address = address;
    }

    /// find location
    if (result != null) {
      _checkDistributionBloc.add(LoadCheckDistribution(
          lat: result.latitude, long: result.longitude, isOther: true));

      // analytics
      await AnalyticsHelper.setLogEvent(
          Analytics.tappedFindByLocation, <String, dynamic>{
        'latlong': '${result.latitude}, ${result.longitude}'
      });
    }
  }
}
