import 'package:ProjectFlow/pages/views/skeleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages/global/controller.dart';
import 'pages/views/loginAndRegister.dart';

void main() async {
  // INIT FIREBASE
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // INIT NOTIFICATION
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  void navigateToMainSkeleton() {
    Future.delayed(Duration(seconds: 1), () {
      const login = true;
      if (login) {
        Get.off(() => MainSkeleton());
      } else {
        Get.off(() => LoginAndRegister());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final Controller controller = Get.put(Controller());

    navigateToMainSkeleton();

    return GetMaterialApp(
      title: 'ProjectFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromRGBO(0, 87, 146, 1)),
      home: Scaffold(body: Text("Loading")),
    );
  }
}
