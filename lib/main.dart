import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/views/skeleton.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages/views/login.dart';
import 'pages/views/signup.dart';

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
      const login = false;
      // login = true;
      login ? Get.off(() => MainSkeleton()) : Get.off(() => Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    navigateToMainSkeleton();
    return GetMaterialApp(
      title: 'ProjectFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.grey[850]),
      home: Scaffold(body: Loading()),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          // BACKGROUND
          Lottie.asset(
            "images/lottie/bg.json",
            fit: BoxFit.cover,
            frameRate: FrameRate(60),
          ),

          // LOGIN/SIGN UP BTN
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'images/icons/text.svg',
                  semanticsLabel: 'ProjectFlow',
                  height: 30,
                ),
                SizedBox(height: 30),
                // LOGIN
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.to(() => Login()),
                    icon: Icon(
                      FluentIcons.mail_24_filled,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                      'Login with Email',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Theme.of(context).primaryColor,
                      minimumSize: Size(200, 45),
                      side: const BorderSide(width: 1.0, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                // CONTINUE WITH GOOGLE
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: OutlinedButton.icon(
                    onPressed: null,
                    // onPressed: () async => await Auth().loginWithGoogle(),
                    icon: Icon(
                      FluentIcons.store_microsoft_24_filled,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Continue with Google',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 45),
                      onPrimary: Colors.white,
                      side: const BorderSide(width: 1.0, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // SIGNUP BTN
                FractionallySizedBox(
                  widthFactor: 0.7,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => SignUp()),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 45),
                      primary: Colors.transparent,
                      onPrimary: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 3.0),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }
}
