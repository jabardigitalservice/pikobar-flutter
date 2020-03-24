import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/BrowserScreen.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/screens/phonebook/Phonebook.dart';
import 'package:pikobar_flutter/screens/survey/surveysScreen.dart';
import 'package:pikobar_flutter/screens/videos/videosScreen.dart';

Route generateRoutes(RouteSettings settings) {
  // getting arguments passed
  final args = settings.arguments;

  switch (settings.name) {
    case NavigationConstrants.Browser:
      return buildRoute(
          settings,
          BrowserScreen(
            url: args,
          ));
    case NavigationConstrants.News:
      return buildRoute(settings, News());
    case NavigationConstrants.Phonebook:
      return buildRoute(settings, Phonebook());
    case NavigationConstrants.BroadcastDetail:
      return buildRoute(
          settings,
          MessageDetailScreen(
            document: args,
          ));

    case NavigationConstrants.Survey:
      return buildRoute(settings, SurveysScreen());

    case NavigationConstrants.VideoList:
      return buildRoute(settings, VideosScreen());

    default:
      return null;
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => builder,
  );
}
