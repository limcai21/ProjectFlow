import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<Map> scheduleNotification({
  @required String id,
  @required String projectID,
  @required String title,
  @required String endDate,
  @required int minutes,
  @required String description,
}) async {
  try {
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
      int.parse(id),
      title,
      description,
      tzDateTime.subtract(Duration(minutes: minutes)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("Notification Scheduled at " +
        tzDateTime.subtract(Duration(minutes: minutes)).toString());
    return {"status": true, "msg": "Scheduled!"};
  } catch (e) {
    return {
      "status": false,
      "msg":
          "Something went wrong when scheduling your notification, try again later"
    };
  }
}

Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
  return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
}

Future<void> cancelNotification({@required String id}) async {
  await flutterLocalNotificationsPlugin.cancel(int.parse(id));
  print("Notification Cancelled");
}

Future<void> cancelAllNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
