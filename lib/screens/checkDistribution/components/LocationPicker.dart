import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/geocoder/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';

class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _controller = Completer();
  GeocoderBloc _geocoderBloc;

  Map<String, Marker> markers = <String, Marker>{};
  LatLng _currentPosition = LatLng(-6.902735, 107.618782);

  String primaryAddress = '';
  String secondaryAddress = '';

  @override
  void initState() {
    _checkPermission();
    markers["new"] = Marker(
      markerId: MarkerId("Bandung"),
      position: _currentPosition,
      icon: BitmapDescriptor.defaultMarker,
    );
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: 15.5),
      ),
    );

    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.searchLocation),
      body: BlocProvider<GeocoderBloc>(
        create: (context) => _geocoderBloc =
            GeocoderBloc(geocoderRepository: GeocoderRepository()),
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 16.0,
              ),
              markers: Set<Marker>.of(markers.values),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onCameraMove: _updatePosition,
              onCameraIdle: _cameraIdle,
            ),
            Positioned(
              bottom: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.all(0.0),
                  elevation: 5.0,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: Dimens.padding,
                        right: Dimens.padding,
                        top: Dimens.padding),
                    child: BlocBuilder<GeocoderBloc, GeocoderState>(
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          state is GeocoderLoading
                              ? CupertinoActivityIndicator()
                              : state is GeocoderLoaded
                                  ? _buildLocation(state)
                                  : state is GeocoderFailure
                                      ? Container(child: Text(state.error))
                                      : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 20.0, top: 10.0),
                            child: RaisedButton(
                              child: Text('Set Lokasi'),
                              color: ColorBase.green,
                              textColor: Colors.white,
                              onPressed: state is GeocoderLoading
                                  ? null
                                  : state is GeocoderLoaded
                                      ? () {
                                          Navigator.pop(
                                              context, _currentPosition);
                                        }
                                      : null,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildLocation(GeocoderLoaded state) {
    return Text(
      state.address,
      style: TextStyle(
          // fontSize: 14.0,
          fontWeight: FontWeight.w600,
          fontFamily: FontsFamily.productSans),
    );
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
        latitude: _position.target.latitude,
        longitude: _position.target.longitude);
    Marker marker = markers["new"];

    setState(() {
      markers["new"] = marker.copyWith(
          positionParam:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
      _currentPosition =
          LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude);
    });
  }

  _cameraIdle() async {
    _geocoderBloc.add(GeocoderGetLocation(coordinate: _currentPosition));
  }

  void _checkPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.granted) {
      final GoogleMapController controller = await _controller.future;
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 15.5),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationMap,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  PermissionHandler().requestPermissions(
                      [PermissionGroup.location]).then(_onStatusRequested);
                },
              ));
    }
  }

  void _onStatusRequested(
      Map<PermissionGroup, PermissionStatus> statusPermission) async {
    final status = statusPermission[PermissionGroup.location];
    if (status == PermissionStatus.granted) {
      final GoogleMapController controller = await _controller.future;
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      LatLng currentLocation = LatLng(position.latitude, position.longitude);

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 15.5),
        ),
      );

      _geocoderBloc.add(GeocoderGetLocation(coordinate: currentLocation));
    }
  }

  @override
  void dispose() {
    _geocoderBloc.close();
    super.dispose();
  }
}
