import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/screens/phonebook/Phonebook.dart';

Route generateRoutes(RouteSettings settings) {
  // getting arguments passed
  final args = settings.arguments;

  switch (settings.name) {
  /*case NavigationConstrants.Browser:
     return buildRoute(
         settings,
         BrowserScreen(
           url: args,
         ));*/
    case NavigationConstrants.Pikobar:
      return buildRoute(settings, News());
    case NavigationConstrants.Phonebook:
      return buildRoute(settings, Phonebook());

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
