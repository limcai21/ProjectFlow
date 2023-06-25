import 'package:ProjectFlow/pages/views/account/account.dart';
import 'package:ProjectFlow/pages/views/watches.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages/views/dashboard.dart';
import 'pages/global/controller.dart';

void main() async {
  // INITIALIZE NOTIFICATION
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 0;

  final data = [
    [
      "Dashboard",
      FluentIcons.board_24_regular,
      FluentIcons.board_24_filled,
      Dashboard(),
    ],
    [
      "Search",
      FluentIcons.search_24_regular,
      FluentIcons.search_24_filled,
      Text("b"),
    ],
    [
      "Watches",
      FluentIcons.eye_show_24_regular,
      FluentIcons.eye_show_24_filled,
      Watches(),
    ],
    [
      "Account",
      FluentIcons.person_24_regular,
      FluentIcons.person_24_filled,
      Account(),
    ]
  ];

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final Controller controller = Get.put(Controller());

    return GetMaterialApp(
      title: 'ProjectFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromRGBO(0, 87, 146, 1)),
      home: Scaffold(
        body: data[_currentIndex][3],
        bottomNavigationBar: SalomonBottomBar(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          selectedColorOpacity: 0.15,
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: data.map((data) {
            return SalomonBottomBarItem(
              title: Text(data[0]),
              icon: Icon(data[1]),
              activeIcon: Icon(data[2]),
            );
          }).toList(),
        ),
      ),
    );
  }
}
