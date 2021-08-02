import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'cd_noti',
    'cd_noti',
    'Countdown notification channel',
    priority: Priority.max,
    importance: Importance.high,
    groupKey: 'cd_notification',
  );

  final iOSPlatformChannelSpecifics = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    threadIdentifier: 'cd_notification',
  );

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    tz.initializeTimeZones();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime time,
  }) async {
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (time.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        'You can watch it now',
        tz.TZDateTime.from(time, tz.local),
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      log("notification schedule at $time");
    }
  }

  Future<void> cancelNotification(int idNotification) async {
    await flutterLocalNotificationsPlugin.cancel(idNotification);
  }
}
