import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  RemoteConfig _remoteConfig;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteConfigBloc>(
        create: (_) => RemoteConfigBloc()..add(RemoteConfigLoad()),
        child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, state) {
            return state is RemoteConfigLoaded
                ? _buildContent(state.remoteConfig)
                : Center(child: CircularProgressIndicator(),);
          },
        ));
  }

  _buildContent(RemoteConfig remoteConfig) {
    _remoteConfig = remoteConfig;

    List<Widget> menus = <Widget>[
      _buildButtonColumn('${Environment.iconAssets}report_case_active.png',
          Dictionary.pikobar, NavigationConstrants.Browser,
          arguments: kUrlCoronaInfo),
      _buildButtonColumn('${Environment.iconAssets}report_case_active.png',
          Dictionary.nationalInfo, NavigationConstrants.Browser,
          arguments: kUrlCoronaEscort),
      _buildButtonColumn('${Environment.iconAssets}report_case_active.png',
          Dictionary.worldInfo, NavigationConstrants.Browser,
          arguments: kUrlWorldCoronaInfo),
      _buildButtonColumn('${Environment.iconAssets}bansos.png',
          Dictionary.bansos, NavigationConstrants.Browser,
          arguments: kUrlBansos),
      _buildButtonColumn('${Environment.iconAssets}emergency_numbers.png',
          Dictionary.phoneBookEmergency, NavigationConstrants.Phonebook),
      _buildButtonColumn('${Environment.iconAssets}bansos.png',
          Dictionary.aduanBansos, NavigationConstrants.Browser,
          arguments: kUrlBansos),
      _buildButtonColumn('${Environment.iconAssets}report.png',
        Dictionary.titleSelfReport, NavigationConstrants.SelfReports),
      _buildButtonColumn('${Environment.iconAssets}self_diagnose.png',
          Dictionary.selfDiagnose, NavigationConstrants.Browser,
          arguments: kUrlSelfDiagnose),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pusat Layanan & Informasi (8)',
          style: TextStyle(
              fontFamily: FontsFamily.lato,
              fontWeight: FontWeight.bold,
              fontSize: 16.0),
        ),
        SizedBox(
          height: 24.0,
        ),
        GridView.builder(
          itemCount: menus.length,
          shrinkWrap: true,
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
            crossAxisCount: 4,
            crossAxisSpacing: Dimens.padding,
            mainAxisSpacing: Dimens.padding,
            height: 120.0,
          ),
          itemBuilder: (context, index) {
            return menus[index];
          },
        ),

        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Colors.black),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              'Menu Lainnya (7)',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            children: <Widget>[
              GridView.builder(
                itemCount: 8,
                shrinkWrap: true,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: 4,
                  crossAxisSpacing: Dimens.padding,
                  mainAxisSpacing: Dimens.padding,
                  height: 120.0,
                ),
                itemBuilder: (context, int) {
                  return Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.grey[50]),
                          child: Image.asset(
                              '${Environment.iconAssets}stayhome.png'),
                        ),
                        Text(
                          'Data Jabar',
                          style: TextStyle(fontFamily: FontsFamily.roboto),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonColumn(String iconPath, String label, String route,
      {Object arguments,
        String remoteMenuLoginKey}) {

    return GestureDetector(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[50]),
            child: Image.asset(iconPath),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontsFamily.roboto, fontSize: 12.0),
            ),
          )
        ],
      ),
      onTap: () async {
        if (route != null) {
          if (_remoteConfig != null &&
              _remoteConfig.getString(FirebaseConfig.loginRequired) != null) {
            Map<String, dynamic> _loginRequiredMenu = json.decode(
                _remoteConfig.getString(FirebaseConfig.loginRequired));

            if (_loginRequiredMenu[remoteMenuLoginKey] != null &&
                _loginRequiredMenu[remoteMenuLoginKey]) {
              bool hasToken = await AuthRepository().hasToken();

              if (!hasToken) {
                bool isLoggedIn = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(title: label)));

                if (isLoggedIn != null && isLoggedIn) {
                  arguments = await userDataUrlAppend(arguments);

                  if (route == NavigationConstrants.Browser) {
                    openChromeSafariBrowser(url: arguments);
                  } else {
                    Navigator.pushNamed(context, route, arguments: arguments);
                  }
                }
              } else {
                arguments = await userDataUrlAppend(arguments);

                if (route == NavigationConstrants.Browser) {
                  openChromeSafariBrowser(url: arguments);
                } else {
                  Navigator.pushNamed(context, route, arguments: arguments);
                }
              }
            } else {
              arguments = await userDataUrlAppend(arguments);

              if (route == NavigationConstrants.Browser) {
                openChromeSafariBrowser(url: arguments);
              } else {
                Navigator.pushNamed(context, route, arguments: arguments);
              }
            }
          } else {
            arguments = await userDataUrlAppend(arguments);

            if (route == NavigationConstrants.Browser) {
              openChromeSafariBrowser(url: arguments);
            } else {
              Navigator.pushNamed(context, route, arguments: arguments);
            }
          }

          // record event to analytics
          if (label == Dictionary.phoneBookEmergency) {
            AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergency);
          } else if (label == Dictionary.saberHoax) {
            AnalyticsHelper.setLogEvent(Analytics.tappedJabarSaberHoax);
          } else if (label == Dictionary.titleSelfReport) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSelfReports);
          } else if (iconPath == '${Environment.iconAssets}pikobar.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedInfoCorona);
          } else if (iconPath == '${Environment.iconAssets}indo_flag.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedKawalCovid19);
          } else if (iconPath == '${Environment.iconAssets}world.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedWorldInfo);
          } else if (label == Dictionary.survey) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSurvey);
          } else if (iconPath ==
              '${Environment.iconAssets}self_diagnose.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedSelfDiagnose);
          } else if (iconPath == '${Environment.iconAssets}logistics.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedLogistic);
          } else if (iconPath ==
              '${Environment.iconAssets}relawan_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedVolunteer);
          } else if (iconPath ==
              '${Environment.iconAssets}report_case_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedCaseReport);
          } else if (iconPath == '${Environment.iconAssets}help.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedDonasi);
          } else if (iconPath ==
              '${Environment.iconAssets}conversation_active.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedQna);
          }
        }
      },
    );
  }
}
