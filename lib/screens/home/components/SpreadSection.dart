import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
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
                    Navigator.pushNamed(
                        context, NavigationConstrants.CheckDistribution);

                    AnalyticsHelper.setLogEvent(Analytics.tappedSpreadCheck);
                  }),
            )
          : Container();
    } else {
      return Container();
    }
  }
}
