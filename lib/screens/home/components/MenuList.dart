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
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteConfigBloc>(
        create: (_) => RemoteConfigBloc()..add(RemoteConfigLoad()),
        child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, state) {
            return state is RemoteConfigLoaded
                ? _buildContent(state.remoteConfig)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ));
  }

  _buildContent(RemoteConfig remoteConfig) {
    List<Widget> menus = <Widget>[
      // Data Jabar
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_data_jabar.png',
        defaultLabel: Dictionary.pikobar,
        firebaseConfigLabel: FirebaseConfig.pikobarCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlCoronaInfo,
        firebaseConfigArguments: FirebaseConfig.pikobarUrl,
        remoteMenuLoginKey: FirebaseConfig.pikobarInfoMenu,
      ),

      // Data Nasional
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_data_nasional.png',
        defaultLabel: Dictionary.nationalInfo,
        firebaseConfigLabel: FirebaseConfig.nationalInfoCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlCoronaEscort,
        firebaseConfigArguments: FirebaseConfig.nationalInfoUrl,
        remoteMenuLoginKey: FirebaseConfig.nationalInfoMenu,
      ),

      // Data Dunia
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_data_dunia.png',
        defaultLabel: Dictionary.worldInfo,
        firebaseConfigLabel: FirebaseConfig.worldInfoCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlWorldCoronaInfo,
        firebaseConfigArguments: FirebaseConfig.worldInfoUrl,
        remoteMenuLoginKey: FirebaseConfig.worldInfoMenu,
      ),

      // Aduan Bansos (Added automatically)
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_aduan_bansos.png',
        defaultLabel: Dictionary.pikobarComplaints,
        route: NavigationConstrants.PikobarComplaints,
        defaultArguments: kUrlCaseReport,
        firebaseConfigArguments: FirebaseConfig.reportUrl,
        remoteMenuLoginKey: FirebaseConfig.reportMenu,
      ),

      // Nomor Darurat
      BuildButtonMenu(
          remoteConfig: remoteConfig,
          iconPath: '${Environment.iconAssets}menu_nomor_darurat.png',
          defaultLabel: Dictionary.phoneBookEmergency,
          route: NavigationConstrants.Phonebook),

      // Bantuan Sosial
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_bantuan_sosial.png',
        defaultLabel: Dictionary.bansos,
        firebaseConfigLabel: FirebaseConfig.bansosCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlBansos,
        firebaseConfigArguments: FirebaseConfig.bansosUrl,
        remoteMenuLoginKey: FirebaseConfig.bansosMenu,
      ),

      // Lapor Mandiri
      BuildButtonMenu(
          remoteConfig: remoteConfig,
          iconPath: '${Environment.iconAssets}menu_lapor_mandiri.png',
          defaultLabel: Dictionary.titleSelfReport,
          route: NavigationConstrants.SelfReports),

      // Periksa Mandiri (Added automatically)
    ];

    List<Widget> otherMenus = <Widget>[
      // Daftar Test Masif
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_test_masif.png',
        defaultLabel: Dictionary.massiveTestRegistration,
        firebaseConfigLabel: FirebaseConfig.massiveTestCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlMassiveTest,
        firebaseConfigArguments: FirebaseConfig.massiveTestUrl,
        remoteMenuLoginKey: FirebaseConfig.massiveTestMenu,
      ),

      // Daftar Relawan (Added automatically)

      // Tanya Jawab (Added automatically)

      // Permohonan Logistik
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_logistik.png',
        defaultLabel: Dictionary.logistic,
        firebaseConfigLabel: FirebaseConfig.logisticCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlLogisticsInfo,
        firebaseConfigArguments: FirebaseConfig.logisticUrl,
        remoteMenuLoginKey: FirebaseConfig.logisticMenu,
      ),

      // Survei Pikobar
      BuildButtonMenu(
          remoteConfig: remoteConfig,
          iconPath: '${Environment.iconAssets}menu_survei.png',
          defaultLabel: Dictionary.survey,
          route: NavigationConstrants.Survey),

      // Donasi Covid-19
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_donasi.png',
        defaultLabel: Dictionary.donation,
        firebaseConfigLabel: FirebaseConfig.donationCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlDonation,
        firebaseConfigArguments: FirebaseConfig.donationUrl,
        remoteMenuLoginKey: FirebaseConfig.donationMenu,
      ),

      // Saber Hoax
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_saber_hoax.png',
        defaultLabel: Dictionary.saberHoax,
        firebaseConfigLabel: FirebaseConfig.jshCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlIGSaberHoax,
        firebaseConfigArguments: FirebaseConfig.jshUrl,
        remoteMenuLoginKey: FirebaseConfig.jshMenu,
      ),
    ];

    if (remoteConfig.getBool(FirebaseConfig.selfDiagnoseEnabled)) {
      menus.add(BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_periksa_mandiri.png',
        defaultLabel: Dictionary.selfDiagnose,
        firebaseConfigLabel: FirebaseConfig.selfDiagnoseCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlSelfDiagnose,
        firebaseConfigArguments: FirebaseConfig.selfDiagnoseUrl,
        remoteMenuLoginKey: FirebaseConfig.selfDiagnoseMenu,
      ));
    }

    if (remoteConfig.getBool(FirebaseConfig.volunteerEnabled)) {
      otherMenus.insert(
          1,
          BuildButtonMenu(
            remoteConfig: remoteConfig,
            iconPath: '${Environment.iconAssets}menu_relawan.png',
            defaultLabel: Dictionary.volunteer,
            firebaseConfigLabel: FirebaseConfig.volunteerCaption,
            route: NavigationConstrants.Browser,
            defaultArguments: kUrlVolunteer,
            firebaseConfigArguments: FirebaseConfig.volunteerUrl,
            remoteMenuLoginKey: FirebaseConfig.volunteerMenu,
          ));
    }

    if (remoteConfig.getBool(FirebaseConfig.qnaEnabled)) {
      otherMenus.insert(
          2,
          BuildButtonMenu(
            remoteConfig: remoteConfig,
            iconPath: '${Environment.iconAssets}menu_qna.png',
            defaultLabel: Dictionary.qna,
            firebaseConfigLabel: FirebaseConfig.qnaCaption,
            route: NavigationConstrants.Browser,
            defaultArguments: kUrlQNA,
            firebaseConfigArguments: FirebaseConfig.qnaUrl,
            remoteMenuLoginKey: FirebaseConfig.qnaMenu,
          ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Dictionary.menus} (${menus.length})',
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
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
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
          data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, accentColor: Colors.black),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              '${Dictionary.otherMenus} (${otherMenus.length})',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            children: <Widget>[
              GridView.builder(
                itemCount: otherMenus.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                  crossAxisCount: 4,
                  crossAxisSpacing: Dimens.padding,
                  mainAxisSpacing: Dimens.padding,
                  height: 120.0,
                ),
                itemBuilder: (context, index) {
                  return otherMenus[index];
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BuildButtonMenu extends StatelessWidget {
  final RemoteConfig remoteConfig;
  final String iconPath;
  final String defaultLabel;
  final String firebaseConfigLabel;
  final String route;
  final Object defaultArguments;
  final Object firebaseConfigArguments;
  final String remoteMenuLoginKey;

  const BuildButtonMenu(
      {@required this.remoteConfig,
      @required this.iconPath,
      @required this.defaultLabel,
      this.firebaseConfigLabel,
      @required this.route,
      this.defaultArguments,
      this.firebaseConfigArguments,
      this.remoteMenuLoginKey})
      : assert(remoteConfig != null),
        assert(iconPath != null),
        assert(defaultLabel != null),
        assert(route != null);

  @override
  Widget build(BuildContext context) {
    final label = firebaseConfigLabel != null
        ? RemoteConfigHelper.getString(
            remoteConfig: remoteConfig,
            firebaseConfig: firebaseConfigLabel,
            defaultValue: defaultLabel)
        : defaultLabel;

    String combinedArguments = firebaseConfigArguments ??
        RemoteConfigHelper.getString(
            remoteConfig: remoteConfig,
            firebaseConfig: firebaseConfigArguments,
            defaultValue: defaultArguments);

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
          Expanded(
            child: Text(
              label.replaceFirst(' ', '\n'),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontsFamily.roboto, fontSize: 12.0),
            ),
          )
        ],
      ),
      onTap: () async {
        if (route != null) {
          if (remoteConfig.getString(FirebaseConfig.loginRequired) != null) {
            Map<String, dynamic> _loginRequiredMenu = RemoteConfigHelper.decode(
                remoteConfig: remoteConfig,
                firebaseConfig: FirebaseConfig.loginRequired,
                defaultValue: FirebaseConfig.loginRequiredDefaultVal);

            if (_loginRequiredMenu[remoteMenuLoginKey] != null &&
                _loginRequiredMenu[remoteMenuLoginKey]) {
              bool hasToken = await AuthRepository().hasToken();

              if (!hasToken) {
                bool isLoggedIn = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen(title: label)));

                if (isLoggedIn != null && isLoggedIn) {
                  combinedArguments = await userDataUrlAppend(
                      RemoteConfigHelper.getString(
                          remoteConfig: remoteConfig,
                          firebaseConfig: firebaseConfigArguments,
                          defaultValue: defaultArguments));

                  if (route == NavigationConstrants.Browser) {
                    openChromeSafariBrowser(url: combinedArguments);
                  } else {
                    Navigator.pushNamed(context, route,
                        arguments: combinedArguments);
                  }
                }
              } else {
                combinedArguments = await userDataUrlAppend(
                    RemoteConfigHelper.getString(
                        remoteConfig: remoteConfig,
                        firebaseConfig: firebaseConfigArguments,
                        defaultValue: defaultArguments));

                if (route == NavigationConstrants.Browser) {
                  openChromeSafariBrowser(url: combinedArguments);
                } else {
                  Navigator.pushNamed(context, route,
                      arguments: combinedArguments);
                }
              }
            } else {
              combinedArguments = await userDataUrlAppend(
                  RemoteConfigHelper.getString(
                      remoteConfig: remoteConfig,
                      firebaseConfig: firebaseConfigArguments,
                      defaultValue: defaultArguments));

              if (route == NavigationConstrants.Browser) {
                openChromeSafariBrowser(url: combinedArguments);
              } else {
                Navigator.pushNamed(context, route,
                    arguments: combinedArguments);
              }
            }
          } else {
            combinedArguments = await userDataUrlAppend(
                RemoteConfigHelper.getString(
                    remoteConfig: remoteConfig,
                    firebaseConfig: firebaseConfigArguments,
                    defaultValue: defaultArguments));

            if (route == NavigationConstrants.Browser) {
              openChromeSafariBrowser(url: combinedArguments);
            } else {
              Navigator.pushNamed(context, route, arguments: combinedArguments);
            }
          }

          // record event to analytics
          if (defaultLabel == Dictionary.phoneBookEmergency) {
            AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergency);
          } else if (defaultLabel == Dictionary.saberHoax) {
            AnalyticsHelper.setLogEvent(Analytics.tappedJabarSaberHoax);
          } else if (defaultLabel == Dictionary.titleSelfReport) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSelfReports);
          } else if (iconPath == '${Environment.iconAssets}pikobar.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedInfoCorona);
          } else if (iconPath == '${Environment.iconAssets}indo_flag.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedKawalCovid19);
          } else if (iconPath == '${Environment.iconAssets}world.png') {
            AnalyticsHelper.setLogEvent(Analytics.tappedWorldInfo);
          } else if (defaultLabel == Dictionary.survey) {
            AnalyticsHelper.setLogEvent(Analytics.tappedSurvey);
          } else if (iconPath == '${Environment.iconAssets}self_diagnose.png') {
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
