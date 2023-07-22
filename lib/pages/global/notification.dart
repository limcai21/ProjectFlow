import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleNotification({
  @required String id,
  @required String projectID,
  @required String title,
  @required String endDate,
  @required String description,
}) async {
  int intID = int.parse(id.replaceAll(new RegExp(r'[^0-9]'), ''));
  DateTime dateTime = DateTime.parse(endDate);
  tz.TZDateTime tzDateTime = tz.TZDateTime.from(
    dateTime,
    tz.getLocation('Asia/Singapore'),
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    projectID,
    'ProjectFlow',
    "",
    importance: Importance.max,
    priority: Priority.high,
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    intID,
    title,
    description,
    tzDateTime.subtract(Duration(days: 1)),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );

  print("Notification Scheduled");
}

Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
  return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
}

Future<void> cancelNotification({@required String id}) async {
  int intID = int.parse(id.replaceAll(new RegExp(r'[^0-9]'), ''));
  await flutterLocalNotificationsPlugin.cancel(intID);
  print("Notification Cancelled");
}

Future<void> cancelAllNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
