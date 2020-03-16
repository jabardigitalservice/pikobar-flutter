import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/BrowserScreen.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';

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
    // case NavigationConstrants.NotificationList:
    //   return buildRoute(settings, NotificationListScreen());
    // case NavigationConstrants.SubProfile:
    //   return buildRoute(settings, SubProfileScreen());
    // case NavigationConstrants.SubContact:
    //   return buildRoute(settings, SubContactScreen());
    //   case NavigationConstrants.SubAddress:
    //   return buildRoute(settings, SubAdressScreen());
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
