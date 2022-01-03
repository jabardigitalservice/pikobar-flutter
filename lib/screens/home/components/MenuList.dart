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
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/SliverGrideDelegate.dart';
import 'package:pedantic/pedantic.dart';

class MenuList extends StatefulWidget {
  MenuList({Key key}) : super(key: key);

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
      // Data Covid
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}data_covid.png',
        defaultLabel: Dictionary.covidData,
        firebaseConfigLabel: FirebaseConfig.covidDataCaption,
        route: NavigationConstrants.CovidData,
        firebaseConfigArguments: FirebaseConfig.pikobarUrl,
        remoteMenuLoginKey: FirebaseConfig.covidDataMenu,
      ),

      // Informasi Vaksinasi
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_informasi_vaksin.png',
        defaultLabel: Dictionary.vaccinInformation,
        firebaseConfigLabel: FirebaseConfig.vaccinationInformationCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlVaccinInformation,
        firebaseConfigArguments: FirebaseConfig.vaccinationInformationUrl,
        remoteMenuLoginKey: FirebaseConfig.vaccinInformationMenu,
      ),

      // Keterisian Bed RS
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_keterisian_bed_rs.png',
        defaultLabel: Dictionary.hospitalBedOccupancy,
        firebaseConfigLabel: FirebaseConfig.hospitalBedOccupancyCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlHospitalBedOccupancy,
        firebaseConfigArguments: FirebaseConfig.hospitalBedOccupancyUrl,
        remoteMenuLoginKey: FirebaseConfig.hospitalBedOccipancyMenu,
      ),

      // Aduan Pikobar
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_aduan_bansos.png',
        defaultLabel: Dictionary.pikobarComplaints,
        route: NavigationConstrants.LaunchUrl,
        defaultArguments: kUrlPikobarHotline,
        firebaseConfigArguments: FirebaseConfig.reportHotlineUrl,
        remoteMenuLoginKey: FirebaseConfig.reportHotlineEnabled,
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
        route: NavigationConstrants.PikobarComplaints,
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

      // Keterisian Bed RS
      BuildButtonMenu(
        remoteConfig: remoteConfig,
        iconPath: '${Environment.iconAssets}menu_terapi_oksigen.png',
        defaultLabel: Dictionary.oxygenTherapy,
        firebaseConfigLabel: FirebaseConfig.oxygenTherapyCaption,
        route: NavigationConstrants.Browser,
        defaultArguments: kUrlOxygenTherapy,
        firebaseConfigArguments: FirebaseConfig.oxygenTherapyUrl,
        remoteMenuLoginKey: FirebaseConfig.oxygenTherapyMenu,
      ),
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

      // Periksa Mandiri (Added automatically)

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

      // Daftar Relawan (Added automatically)
    ];

    // if (remoteConfig.getBool(FirebaseConfig.selfDiagnoseEnabled)) {
    //   otherMenus.insert(
    //       1,
    //       BuildButtonMenu(
    //         remoteConfig: remoteConfig,
    //         iconPath: '${Environment.iconAssets}menu_periksa_mandiri.png',
    //         defaultLabel: Dictionary.selfDiagnose,
    //         firebaseConfigLabel: FirebaseConfig.selfDiagnoseCaption,
    //         route: NavigationConstrants.Browser,
    //         defaultArguments: kUrlSelfDiagnose,
    //         firebaseConfigArguments: FirebaseConfig.selfDiagnoseUrl,
    //         remoteMenuLoginKey: FirebaseConfig.selfDiagnoseMenu,
    //       ));
    // }

    if (remoteConfig.getBool(FirebaseConfig.volunteerEnabled)) {
      otherMenus.insert(
          5,
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
          1,
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
        Row(
          children: [
            Text(
              '${Dictionary.menus}',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16),
            ),
            Text(
              ' (${menus.length})',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 16),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        GridView.builder(
          itemCount: menus.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
            crossAxisCount: 4,
            crossAxisSpacing: Dimens.padding,
            mainAxisSpacing: Dimens.padding,
            height: 120,
          ),
          itemBuilder: (context, index) {
            return menus[index];
          },
        ),
        Theme(
          data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent, accentColor: Colors.black),
          child: ExpansionTile(
            onExpansionChanged: (bool isExpand) {
              if (isExpand) {
                AnalyticsHelper.setLogEvent(Analytics.tappedOthers);
              }
            },
            tilePadding: EdgeInsets.zero,
            title: Row(
              children: [
                Text(
                  '${Dictionary.otherMenus}',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 16),
                ),
                Text(
                  ' (${otherMenus.length})',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16),
                ),
              ],
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
                  height: 120,
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
      {Key key,
      @required this.remoteConfig,
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
        assert(route != null),
        super(key: key);

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
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                color: Colors.grey[50]),
            child: Image.asset(iconPath),
          ),
          Expanded(
            child: Text(
              label.replaceFirst(' ', '\n'),
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: FontsFamily.roboto, fontSize: 12),
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

                  unawaited(Navigator.pushNamed(context, route,
                      arguments: combinedArguments));
                }
              } else {
                combinedArguments = await userDataUrlAppend(
                    RemoteConfigHelper.getString(
                        remoteConfig: remoteConfig,
                        firebaseConfig: firebaseConfigArguments,
                        defaultValue: defaultArguments));

                unawaited(Navigator.pushNamed(context, route,
                    arguments: combinedArguments));
              }
            } else {
              combinedArguments = await userDataUrlAppend(
                  RemoteConfigHelper.getString(
                      remoteConfig: remoteConfig,
                      firebaseConfig: firebaseConfigArguments,
                      defaultValue: defaultArguments));

              unawaited(Navigator.pushNamed(context, route,
                  arguments: combinedArguments));
            }
          } else {
            combinedArguments = await userDataUrlAppend(
                RemoteConfigHelper.getString(
                    remoteConfig: remoteConfig,
                    firebaseConfig: firebaseConfigArguments,
                    defaultValue: defaultArguments));

            unawaited(Navigator.pushNamed(context, route,
                arguments: combinedArguments));
          }

          // record event to analytics
          if (defaultLabel == Dictionary.phoneBookEmergency) {
            await AnalyticsHelper.setLogEvent(
                Analytics.tappedphoneBookEmergency);
          } else if (defaultLabel == Dictionary.saberHoax) {
            await AnalyticsHelper.setLogEvent(Analytics.tappedJabarSaberHoax);
          } else if (defaultLabel == Dictionary.titleSelfReport) {
            await AnalyticsHelper.setLogEvent(Analytics.tappedSelfReports);
          } else if (iconPath == '${Environment.iconAssets}pikobar.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedInfoCorona);
          } else if (iconPath == '${Environment.iconAssets}indo_flag.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedKawalCovid19);
          } else if (iconPath == '${Environment.iconAssets}world.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedWorldInfo);
          } else if (defaultLabel == Dictionary.survey) {
            await AnalyticsHelper.setLogEvent(Analytics.tappedSurvey);
          } else if (iconPath == '${Environment.iconAssets}self_diagnose.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedSelfDiagnose);
          } else if (iconPath == '${Environment.iconAssets}logistics.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedLogistic);
          } else if (iconPath ==
              '${Environment.iconAssets}relawan_active.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedVolunteer);
          } else if (iconPath ==
              '${Environment.iconAssets}report_case_active.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedCaseReport);
          } else if (iconPath == '${Environment.iconAssets}help.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedDonasi);
          } else if (iconPath ==
              '${Environment.iconAssets}conversation_active.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedQna);
          } else if (defaultLabel == Dictionary.bansos) {
            await AnalyticsHelper.setLogEvent(Analytics.tappedBansos);
          } else if (defaultLabel == Dictionary.massiveTestRegistration) {
            await AnalyticsHelper.setLogEvent(Analytics.tappedMassiveTest);
          } else if (iconPath ==
              '${Environment.iconAssets}menu_informasi_vaksin.png') {
            await AnalyticsHelper.setLogEvent(
                Analytics.tappedVaccinInformation);
          } else if (iconPath ==
              '${Environment.iconAssets}menu_keterisian_bed_rs.png') {
            await AnalyticsHelper.setLogEvent(
                Analytics.tappedHospitalBedOccupancy);
          } else if (iconPath ==
              '${Environment.iconAssets}menu_terapi_oksigen.png') {
            await AnalyticsHelper.setLogEvent(Analytics.tappedOxygenTherapy);
          }
        }
      },
    );
  }
}
