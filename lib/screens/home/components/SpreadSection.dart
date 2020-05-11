import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/SpreadCheckModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class SpreadSection extends StatefulWidget {

  @override
  _SpreadSectionState createState() => _SpreadSectionState();
}

class _SpreadSectionState extends State<SpreadSection> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, state) {
        return state is RemoteConfigLoaded
            ? _spreadContainer(state.remoteConfig)
            : Container();
      },
    );
  }

  Container _spreadContainer(RemoteConfig remoteConfig) {
    if (remoteConfig.getString('ceksebaran_location').isNotEmpty) {
      SpreadCheckModel _data = spreadCheckModelFromJson(
          remoteConfig.getString('ceksebaran_location'));

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
