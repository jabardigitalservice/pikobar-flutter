import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsHelper {
  static Timer _debounceAnalytics;

  static Future<void> setCurrentScreen(String screenName,
      {String screenClassOverride}) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride != null
          ? screenClassOverride
          : '${screenName.replaceAll(RegExp("\\s+"), "")}Screen',
    );
  }

  static Future<void> setLogEvent(String eventName,
      [Map<String, dynamic> source]) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics();

    await analytics.logEvent(
      name: eventName,
      parameters: source,
    );
  }

  static void analyticSearch(
      {@required TextEditingController searchController,
      @required String event}) {
    if (_debounceAnalytics?.isActive ?? false) _debounceAnalytics.cancel();
    _debounceAnalytics = Timer(const Duration(seconds: 1), () async {
      if (searchController.text.trim().isNotEmpty) {
        await setLogEvent(event, <String, dynamic>{
          'search': searchController.text.trim(),
        });
      }
    });
  }
}
