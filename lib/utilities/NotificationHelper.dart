import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

typedef SelectNotificationCallback = Future<dynamic> Function(String payload);

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  showNotification(String title, String body,
      {String payload,
      @required SelectNotificationCallback onSelectNotification}) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'pikobar_channel_id', 'pikobar_channel', 'pikobar_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        visibility: NotificationVisibility.public);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(android:
        androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  NotificationHelper() {
    this.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }
}
