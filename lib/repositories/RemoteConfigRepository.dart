import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';

class RemoteConfigRepository {
  static final RemoteConfigRepository _instance = RemoteConfigRepository._app();

  RemoteConfigRepository._app();

  factory RemoteConfigRepository() {
    return _instance;
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      FirebaseConfig.jshCaption: Dictionary.saberHoax,
      FirebaseConfig.jshUrl: kUrlIGSaberHoax,
      FirebaseConfig.pikobarCaption: Dictionary.pikobar,
      FirebaseConfig.pikobarUrl: kUrlCoronaInfo,
      FirebaseConfig.worldInfoCaption: Dictionary.worldInfo,
      FirebaseConfig.worldInfoUrl: kUrlWorldCoronaInfo,
      FirebaseConfig.nationalInfoCaption: Dictionary.nationalInfo,
      FirebaseConfig.nationalInfoUrl: kUrlCoronaEscort,
      FirebaseConfig.donationCaption: Dictionary.donation,
      FirebaseConfig.donationUrl: kUrlDonation,
      FirebaseConfig.logisticCaption: Dictionary.logistic,
      FirebaseConfig.logisticUrl: kUrlLogisticsInfo,
      FirebaseConfig.reportEnabled: false,
      FirebaseConfig.reportCaption: Dictionary.caseReport,
      FirebaseConfig.reportUrl: kUrlCaseReport,
      FirebaseConfig.qnaEnabled: false,
      FirebaseConfig.qnaCaption: Dictionary.qna,
      FirebaseConfig.qnaUrl: kUrlQNA,
      FirebaseConfig.selfTracingEnabled: false,
      FirebaseConfig.selfTracingCaption: Dictionary.selfTracing,
      FirebaseConfig.selfTracingUrl: kUrlSelfTracing,
      FirebaseConfig.volunteerEnabled: false,
      FirebaseConfig.volunteerCaption: Dictionary.volunteer,
      FirebaseConfig.volunteerUrl: kUrlVolunteer,
      FirebaseConfig.selfDiagnoseEnabled: false,
      FirebaseConfig.selfDiagnoseCaption: Dictionary.selfDiagnose,
      FirebaseConfig.selfDiagnoseUrl: kUrlSelfDiagnose,
      FirebaseConfig.spreadCheckLocation: '',
      FirebaseConfig.announcement: false,
      FirebaseConfig.loginRequired: FirebaseConfig.loginRequiredDefaultVal,
      FirebaseConfig.rapidTestInfo: false,
      FirebaseConfig.rapidTestEnable: false,
      FirebaseConfig.groupHomeBanner: false,
      FirebaseConfig.importantinfoStatusVisible: false,
      FirebaseConfig.termsConditions: false,
      FirebaseConfig.contactHistoryForm:
          FirebaseConfig.contactHistoryFormDefaultValue,
      FirebaseConfig.labels: FirebaseConfig.labelsDefaultValue,
      FirebaseConfig.statisticsSwitch: false
    });

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    return remoteConfig;
  }
}
