// import 'dart:developer';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'cd_noti',
//     'cd_noti',
//     'Countdown notification channel',
//     priority: Priority.max,
//     importance: Importance.high,
//     groupKey: 'cd_notification',
//   );

//   final iOSPlatformChannelSpecifics = IOSNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//     threadIdentifier: 'cd_notification',
//   );

//   Future<void> init() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );

//     tz.initializeTimeZones();

//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required DateTime time,
//     required bool isRepeat,
//   }) async {
//     var platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       'Countdown has ended',
//       tz.TZDateTime.from(time, tz.local),
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: isRepeat ? DateTimeComponents.dayOfWeekAndTime : null,
//     );
//     log("notification schedule at $time");
//   }

//   Future<void> cancelNotification(int idNotification) async {
//     await flutterLocalNotificationsPlugin.cancel(idNotification);
//   }
// }

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:countdown/config/color.dart';

class NotificationService {
  void init() {
    AwesomeNotifications().initialize(
      'resource://drawable/app_icon',
      [
        NotificationChannel(
          channelKey: 'schedule_channel',
          channelName: 'Schedule Channel',
          defaultColor: MColor.green,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
    );
  }

  void clearBadge() {
    AwesomeNotifications()
        .getGlobalBadgeCounter()
        .then((value) => AwesomeNotifications().setGlobalBadgeCounter(0));
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required DateTime datetime,
    required bool isRepeat,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'schedule_channel',
        title: title,
        body: 'Countdown has ended',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: isRepeat
          ? NotificationCalendar(
              weekday: datetime.weekday,
              hour: datetime.hour,
              minute: datetime.minute,
              second: 0,
              millisecond: 0,
              allowWhileIdle: true,
              repeats: true,
            )
          : NotificationCalendar.fromDate(
              date: datetime,
              allowWhileIdle: true,
            ),
    );
  }

  Future<void> cancelNotification(int idNotification) async {
    await AwesomeNotifications().cancel(idNotification);
  }
}
