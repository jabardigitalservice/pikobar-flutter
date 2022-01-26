import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

class CovidDataScreen extends StatelessWidget {
  const CovidDataScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.animatedAppBar(
          showTitle: false,
          title: Dictionary.covidData,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider<RemoteConfigBloc>(
          create: (_) => RemoteConfigBloc()..add(RemoteConfigLoad()),
          child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
            builder: (context, state) {
              return state is RemoteConfigLoaded
                  ? _buildContent(state.remoteConfig, context)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          ),
        ));
  }

  _buildContent(RemoteConfig remoteConfig, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: Dimens.contentPadding),
          child: Text(
            Dictionary.covidData,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 20,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: Dimens.contentPadding),
          child: Text(
            Dictionary.covidDataDesc,
            style: TextStyle(
              fontFamily: FontsFamily.roboto,
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            children: [
              _buildButtonMenu(
                  context: context,
                  remoteConfig: remoteConfig,
                  iconPath: '${Environment.iconAssets}menu_data_jabar.png',
                  defaultLabel: Dictionary.pikobar,
                  firebaseConfigLabel: FirebaseConfig.pikobarCaption,
                  route: NavigationConstrants.Browser,
                  defaultArguments: kUrlCoronaInfo,
                  firebaseConfigArguments: FirebaseConfig.pikobarUrl,
                  remoteMenuLoginKey: FirebaseConfig.pikobarInfoMenu,
                  analytics: Analytics.tappedInfoCorona),
              _buildButtonMenu(
                  context: context,
                  remoteConfig: remoteConfig,
                  iconPath: '${Environment.iconAssets}menu_data_nasional.png',
                  defaultLabel: Dictionary.nationalInfo,
                  firebaseConfigLabel: FirebaseConfig.nationalInfoCaption,
                  route: NavigationConstrants.Browser,
                  defaultArguments: kUrlCoronaEscort,
                  firebaseConfigArguments: FirebaseConfig.nationalInfoUrl,
                  remoteMenuLoginKey: FirebaseConfig.nationalInfoMenu,
                  analytics: Analytics.tappedKawalCovid19),
              _buildButtonMenu(
                  context: context,
                  remoteConfig: remoteConfig,
                  iconPath: '${Environment.iconAssets}menu_data_dunia.png',
                  defaultLabel: Dictionary.worldInfo,
                  firebaseConfigLabel: FirebaseConfig.worldInfoCaption,
                  route: NavigationConstrants.Browser,
                  defaultArguments: kUrlWorldCoronaInfo,
                  firebaseConfigArguments: FirebaseConfig.worldInfoUrl,
                  remoteMenuLoginKey: FirebaseConfig.worldInfoMenu,
                  analytics: Analytics.tappedWorldInfo),
            ],
          ),
        )
      ],
    );
  }

  /// Function for build widget button
  _buildButtonMenu(
      {BuildContext context,
      RemoteConfig remoteConfig,
      String iconPath,
      String defaultLabel,
      String firebaseConfigLabel,
      String route,
      Object defaultArguments,
      Object firebaseConfigArguments,
      String remoteMenuLoginKey,
      String analytics}) {
    final label = firebaseConfigLabel != null
        ? RemoteConfigHelper.getString(
            remoteConfig: remoteConfig,
            firebaseConfig: firebaseConfigLabel,
            defaultValue: defaultLabel)
        : defaultLabel;

    return Expanded(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: RaisedButton(
                elevation: 0,
                padding: const EdgeInsets.all(0),
                color: ColorBase.greyContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                ),
                child: Container(
                  width: (MediaQuery.of(context).size.width),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 15, bottom: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 30, child: Image.asset(iconPath)),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 15, left: 5, right: 10),
                        child: Text(label.replaceFirst(' ', '\n'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14,
                                color: ColorBase.grey800,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontsFamily.roboto)),
                      )
                    ],
                  ),
                ),
                onPressed: () async {
                  final String combinedArguments = await userDataUrlAppend(
                      RemoteConfigHelper.getString(
                          remoteConfig: remoteConfig,
                          firebaseConfig: firebaseConfigArguments,
                          defaultValue: defaultArguments));
                  Navigator.pushNamed(context, NavigationConstrants.Browser,
                      arguments: combinedArguments);
                  await AnalyticsHelper.setLogEvent(analytics);
                })));
  }
}
