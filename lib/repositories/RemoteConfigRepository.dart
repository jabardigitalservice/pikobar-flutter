import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';

class RemoteConfigRepository {

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      FirebaseConfig.jshCaption: Dictionary.saberHoax,
      FirebaseConfig.jshUrl: UrlThirdParty.urlIGSaberHoax,
      FirebaseConfig.pikobarCaption: Dictionary.pikobar,
      FirebaseConfig.pikobarUrl: UrlThirdParty.urlCoronaInfo,
      FirebaseConfig.worldInfoCaption: Dictionary.worldInfo,
      FirebaseConfig.worldInfoUrl: UrlThirdParty.urlWorldCoronaInfo,
      FirebaseConfig.nationalInfoCaption: Dictionary.nationalInfo,
      FirebaseConfig.nationalInfoUrl: UrlThirdParty.urlCoronaEscort,
      FirebaseConfig.donationCaption: Dictionary.donation,
      FirebaseConfig.donationUrl: UrlThirdParty.urlDonation,
      FirebaseConfig.logisticCaption: Dictionary.logistic,
      FirebaseConfig.logisticUrl: UrlThirdParty.urlLogisticsInfo,
      FirebaseConfig.reportEnabled: false,
      FirebaseConfig.reportCaption: Dictionary.caseReport,
      FirebaseConfig.reportUrl: UrlThirdParty.urlCaseReport,
      FirebaseConfig.qnaEnabled: false,
      FirebaseConfig.qnaCaption: Dictionary.qna,
      FirebaseConfig.qnaUrl: UrlThirdParty.urlQNA,
      FirebaseConfig.selfTracingEnabled: false,
      FirebaseConfig.selfTracingCaption: Dictionary.selfTracing,
      FirebaseConfig.selfTracingUrl: UrlThirdParty.urlSelfTracing,
      FirebaseConfig.volunteerEnabled: false,
      FirebaseConfig.volunteerCaption: Dictionary.volunteer,
      FirebaseConfig.volunteerUrl: UrlThirdParty.urlVolunteer,
      FirebaseConfig.selfDiagnoseEnabled: false,
      FirebaseConfig.selfDiagnoseCaption: Dictionary.selfDiagnose,
      FirebaseConfig.selfDiagnoseUrl: UrlThirdParty.urlSelfDiagnose,
      FirebaseConfig.spreadCheckLocation: '',
      FirebaseConfig.announcement: false,
      FirebaseConfig.loginRequired: FirebaseConfig.loginRequiredDefaultVal,
      FirebaseConfig.rapidTestInfo: false,
      FirebaseConfig.rapidTestEnable: false,
      FirebaseConfig.groupHomeBanner:false
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