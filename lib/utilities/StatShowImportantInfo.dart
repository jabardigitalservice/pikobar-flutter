import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';

class StatShowImportantInfo{
  static bool getStatImportantTab(RemoteConfigLoaded state) {
    if (state.remoteConfig != null &&
        state.remoteConfig.getBool(FirebaseConfig.importantinfoStatusVisible) !=
            null &&
        state.remoteConfig.getBool(FirebaseConfig.importantinfoStatusVisible)) {
      return true;
    } else {
      return false;
    }
  }
}