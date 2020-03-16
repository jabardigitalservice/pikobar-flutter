import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

typedef SelectNotificationCallback = Future<dynamic> Function(String payload);

class NotificationHelper {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  showNotification(String title, String body, {String payload, @required SelectNotificationCallback onSelectNotification}) async {

    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'sapawarga_channel_id', 'sapawarga_channel', 'sapawarga_channel_description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: payload);
  }

  NotificationHelper() {
    this.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

}