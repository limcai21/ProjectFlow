import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> scheduleNotification({
  @required int id,
  @required String title,
  @required String description,
}) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    "project_id",
    'project_name',
    'project_description',
    importance: Importance.max,
    priority: Priority.high,
  );
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id, // A unique ID for the notification
    title,
    description,
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
  return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
}

Future<void> cancelNotification({@required int id}) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> cancelAllNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
