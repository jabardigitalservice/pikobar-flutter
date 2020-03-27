import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/SpreadCheckModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class SpreadSection extends StatefulWidget {
  final RemoteConfig remoteConfig;

  SpreadSection(this.remoteConfig);

  @override
  _SpreadSectionState createState() => _SpreadSectionState();
}

class _SpreadSectionState extends State<SpreadSection> {
  RemoteConfig get _remoteConfig => widget.remoteConfig;

  @override
  Widget build(BuildContext context) {
    return _remoteConfig != null ? _spreadContainer() : Container();
  }

  Container _spreadContainer() {
    if (_remoteConfig.getString('ceksebaran_location').isNotEmpty) {
      SpreadCheckModel _data = spreadCheckModelFromJson(
          _remoteConfig.getString('ceksebaran_location'));

      return _data.enabled
          ? Container(
              height: 98.0,
              padding: EdgeInsets.fromLTRB(
                  Dimens.padding, 0.0, Dimens.padding, Dimens.padding),
              color: ColorBase.grey,
              child: RaisedButton(
                  splashColor: Colors.green,
                  padding: EdgeInsets.all(0.0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                          '${Environment.imageAssets}people_corona.png'),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        child: Text(
                          Dictionary.spreadRedaction,
                          style: TextStyle(
                              fontFamily: FontsFamily.productSans,
                              fontSize: 14.0,
                              height: 1.2,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                      Container(
                          margin: EdgeInsets.only(right: 20.0),
                          child: Icon(Icons.chevron_right))
                    ],
                  ),
                  onPressed: () {
                    _handleLocation(_data.webViewUrl);
                  }),
            )
          : Container();
    } else {
      return Container();
    }
  }

  Future<void> _handleLocation(String url) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {

      Position position = await Geolocator().getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
      if (position != null && position.latitude != null) {
        Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');

      } else {
        Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: '$url?lat=${position.latitude}&long=${position.longitude}');
      }

      AnalyticsHelper.setLogEvent(Analytics.tappedSpreadCheck);

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
                    _onStatusRequested(status, url);
              });
            },
            onCancelPressed: () {
              AnalyticsHelper.setLogEvent(Analytics.permissionDismissLocation);
              Navigator.of(context).pop();
            },
          ));
    }
  }

  void _onStatusRequested(
      Map<PermissionGroup, PermissionStatus> statuses, String url) async {
    final statusLocation = statuses[PermissionGroup.location];
    if (statusLocation == PermissionStatus.granted) {
      _handleLocation(url);
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }

}
