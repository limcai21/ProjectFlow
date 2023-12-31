import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:animations/animations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'notification.dart';

const dateFormat = 'd MMM yyyy, h:mm a';
const empty_fields = "Field cannot be empty";
const something_wrong_validation = "Something wrong with validation";
const project_icon = FluentIcons.dock_panel_left_24_regular;
const task_icon = FluentIcons.note_24_regular;
const topic_icon = FluentIcons.tag_24_regular;

// COMPANY
const app_brief_long =
    "Experience seamless task management with ProjectFlow, the intuitive app that empowers you to create, organize, and track your tasks effortlessly. Stay on top of your schedule with smart reminders and due dates. Boost productivity and achieve your goals with ease. Let ProjectFlow guide your projects from start to finish, making task management a breeze.";
const company_number = "+65 64515115";
const company_feedback_email = "feedback@arnet.com.sg";
const company_name = "arnet";
const company_developer = 'Lim Cai';
const company_website = "https://wwww.arnet.com.sg";

// DESTRUCTIVE STUFF
const destructiveTitle = 'Hold On';

// REGISTER
const registerFailTitle = 'Error';
const registerDoneTitle = 'Complete';
const registerDoneDescription = 'You can now proceed to login';

// LOGIN
const loginFailTitle = "Error";
const loginFailDescription = "Invalid Username or Password";

// ACCOUNT DELETE
const accountDeletedTitle = "Account Deleted";
const accountDeletedDescription =
    "Tell us what we can do better by sending us a feedback if you don't mind";

// DELETE ACCOUNT
const deleteAccountTitle = "Delete Account";
const deleteAccountDescription =
    "Are you sure you want to delete your account?";

// LOGOUT
const logoutTitle = 'Logout';
const logoutDescription = "Are you sure you want to logout?";

// PROJECT
const project_existed = 'Project exists. Please try another name';
const projectEmptyNull = 'Project Title cannot be empty';
const themeEmptyNull = 'Theme cannot be empty';
const projectNameSame = 'Project name cannot be the same';

// TOPIC
const topicEmptyNull = 'Topic cannot be empty';

// TASK
const taskEmptyNull = 'Task Title cannot be empty';

// EMAIL
const emailEmptyNull = 'Email cannot be empty';
const emailInvalid = 'Email is not valid';
const emailRegex =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const emailUpdateTitle = 'Updated!';
const emailUpdateDescription = "Your Email Address is updated!";
const emailUpdateSameEmail =
    "New email is the same as the current email. No update needed";

// NAME
const nameEmptyNull = 'Name cannot be empty';

// PASSWORD
const passwordEmptyNull = 'Password cannot be empty';
const retpyePasswordEmptyNull = 'Retype Password cannot be empty';
const passwordAndRetypePasswordDifferent =
    'Password & Retype Password must match';

// IMAGE
const bgEmptyNull = 'Background Image cannot be empty';

// NEW PASSWORD
const currentPasswordEmptyNull = 'Current Password cannot be empty';
const newPasswordEmptyNull = 'New Password cannot be empty';
const retpyeNewPasswordEmptyNull = 'Retype New Password cannot be empty';
const newPasswordAndRetypeNewPasswordDifferent =
    'New Password & Retype New Password must match';
const passwordChangedTitle = 'Password Changed!';
const passwordChangedDescription = 'You will are now logout.\nPlease sign in';
const currentPasswordIncorrect = 'Current Password incorrect';

// DATE
const dateEmptyNull = 'Date cannot be empty';
const startDateAfterEndDate =
    'Start Date & Time has to be before End Date & Time';
const startDateSameAsEndDate =
    'Start Date & Time cannot be the same as End Date & Time';

// DELETE PROJECT
const deleteProjectTitle = "Confirm?";
const deleteProjectSubtitle = "All task and topic will be deleted";

// ALERT
const alertErrorTitle = 'Error';

// COLORS THEME
const color_list = [
  {'title': 'Aqua', 'hex': 0xFF00FFFF},
  {'title': 'Black', 'hex': 0xFF000000},
  {'title': 'Blue', 'hex': 0xFF0000FF},
  {'title': 'Fuchsia', 'hex': 0xFFFF00FF},
  {'title': 'Gray', 'hex': 0xFF808080},
  {'title': 'Green', 'hex': 0xFF008000},
  {'title': 'Lime', 'hex': 0xFF00FF00},
  {'title': 'Maroon', 'hex': 0xFF800000},
  {'title': 'Navy', 'hex': 0xFF000080},
  {'title': 'Olive', 'hex': 0xFF808000},
  {'title': 'Purple', 'hex': 0xFF800080},
  {'title': 'Red', 'hex': 0xFFFF0000},
  {'title': 'Silver', 'hex': 0xFFC0C0C0},
  {'title': 'Teal', 'hex': 0xFF008080},
  {'title': 'Yellow', 'hex': 0xFFFFFF00},
];

const task_status = [
  {
    "title": "Cancelled",
    "color": Colors.red,
    "icon": FluentIcons.dismiss_24_regular,
    "filled_icon": FluentIcons.dismiss_24_filled,
  },
  {
    "title": "Doing",
    "color": Colors.blueGrey,
    "icon": FluentIcons.protocol_handler_24_regular,
    "filled_icon": FluentIcons.protocol_handler_24_filled,
  },
  {
    "title": "On Hold",
    "color": Colors.orange,
    "icon": FluentIcons.hand_right_24_regular,
    "filled_icon": FluentIcons.hand_right_24_filled,
  },
  {
    "title": "Done",
    "color": Colors.green,
    "icon": FluentIcons.checkmark_24_regular,
    "filled_icon": FluentIcons.checkmark_24_filled,
  },
];

const alert_duration = [
  {"name": '5 minutes before', 'min': 5, 'msg': 'in 5 minutes'},
  {"name": '10 minutes before', 'min': 10, 'msg': 'in 10 minutes'},
  {"name": '15 minutes before', 'min': 15, 'msg': 'in 15 minutes'},
  {"name": '30 minutes before', 'min': 30, 'msg': 'in 30 minutes'},
  {"name": '1 hour before', 'min': 60, 'msg': 'in 1 hour'},
  {"name": '2 hours before', 'min': 120, 'msg': 'in 2 hours'},
  {"name": '1 day before', 'min': 1440, 'msg': 'in 1 day'},
  {"name": '2 days before', 'min': 2880, 'msg': 'in 2 days'},
  {"name": '1 week before', 'min': 10080, 'msg': 'in 1 week'},
];

Future<Color> getDominantColorFromImage(String imageUrl) async {
  final ByteData data = await NetworkAssetBundle(Uri.parse(imageUrl)).load('');
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.Image image = (await codec.getNextFrame()).image;

  // Resize the image to 1x1 pixel to get its dominant color
  final ByteData pixelData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final List<int> pixelBytes = pixelData.buffer.asUint8List();
  final int dominantColor =
      Color.fromRGBO(pixelBytes[0], pixelBytes[1], pixelBytes[2], 1).value;

  return Color(dominantColor);
}

// FUNCTIONS AND WIDGET
int getHexValue(String colorTitle) {
  for (var color in color_list) {
    if (color['title'] == colorTitle) {
      return color['hex'];
    }
  }
  return null;
}

Color getTaskColor(String statusV) {
  for (var status in task_status) {
    if (status['title'] == statusV) {
      print(status);
      return status['color'];
    }
  }
  return null;
}

IconData getTaskIcon(String statusV) {
  for (var status in task_status) {
    if (status['title'] == statusV) {
      return status['filled_icon'];
    }
  }
  return null;
}

List<Widget> generateAlertOption(Task content, BuildContext context,
    {bool insert = true}) {
  List<Widget> output = [];

  alert_duration.forEach((v) {
    var start = DateTime.now();
    var end = DateTime.parse(content.endDateTime.toDate().toString()).subtract(
      Duration(minutes: v['min']),
    );
    int difference = end.difference(start).inMinutes;

    if (difference > 0) {
      output.add(simpleDialogOption(
        child: Text(v['name']),
        onPressed: () async {
          if (insert) {
            var r = await scheduleNotification(
              id: content.uuidNum.toString(),
              endDate: content.endDateTime.toDate().toString(),
              minutes: v['min'],
              projectID: content.projectID,
              title: content.title,
              description: 'Due ' + v['msg'],
            );

            if (r['status']) {
              var rr = await Firestore().watchTask(
                minute: v['min'],
                projectID: content.projectID,
                taskID: content.id,
                userID: Auth().getCurrentUser().uid,
                uuidNum: content.uuidNum,
              );

              Get.back();
              if (!rr['status']) {
                normalAlertDialog(
                  title: alertErrorTitle,
                  description: rr['msg'],
                  context: context,
                );
              }
            } else {
              normalAlertDialog(
                title: alertErrorTitle,
                description: r['msg'],
                context: context,
              );
            }
          }
        },
      ));
    }
  });
  return output;
}

loadingCircle({@required BuildContext context}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          // Return false to prevent the back button from closing the modal
          return false;
        },
        child: Dialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class CustomLeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double t;
  final double borderRadius;
  final Color iconColor;
  CustomLeadingIcon({
    @required this.icon,
    @required this.color,
    @required this.t,
    this.borderRadius,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.lerp(Colors.white, color, t),
        borderRadius: BorderRadius.circular(borderRadius ?? 100),
      ),
      child: Icon(
        icon,
        size: 24,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final IconData trailingIcon;
  final Color bgColor;
  final Function onTap;
  final double t;
  final double borderRadius;

  CustomListTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.trailingIcon,
    this.iconColor,
    this.borderRadius,
    this.bgColor,
    this.onTap,
    @required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Icon(trailingIcon, size: 18),
      leading: CustomLeadingIcon(
        color: bgColor ?? Theme.of(context).primaryColor,
        iconColor: iconColor,
        icon: icon,
        t: t,
        borderRadius: borderRadius,
      ),
      onTap: onTap,
    );
  }
}

class ListViewHeader extends StatelessWidget {
  final title;
  ListViewHeader({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> data = [
      "Did you know that a group of flamingos is called a 'flamboyance'?",
      "The average person spends about six months of their life waiting for red lights to turn green",
      "Honey never spoils",
      "There are more possible iterations of a game of chess than there are atoms in the known universe",
      "Sneezes can travel up to 100 miles per hour",
      "The dot over the letter 'i' or 'j' is called a 'tittle.'",
      "Octopuses have three hearts: two for pumping blood to the gills and one for the rest of the body",
      "Cows have best friends and can get stressed when separated from them",
      "The shortest war in history was between Britain and Zanzibar on August 27, 1896. Zanzibar surrendered after 38 minutes",
      "Astronauts' height can change in space due to the absence of gravity"
    ];

    final random = Random();
    final randomIndex = random.nextInt(data.length);

    return DoodleOutput(
      svgPath: "images/clock.svg",
      title: 'Loading',
      subtitle: data[randomIndex],
    );
  }
}

class DoodleOutput extends StatelessWidget {
  final String svgPath;
  final String title;
  final String subtitle;
  final Color bg;
  DoodleOutput({
    @required this.svgPath,
    @required this.title,
    @required this.subtitle,
    this.bg = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width / 0.5,
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, color: Theme.of(context).primaryColor),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final Color pc;
  final Function onTap;
  final Function onLongPress;
  final Color bg;
  final String topTitle;
  final Widget rightSide;
  CustomCard({
    @required this.title,
    @required this.description,
    @required this.pc,
    this.topTitle,
    @required this.onTap,
    @required this.onLongPress,
    this.rightSide,
    this.bg = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    double br = 8.0;

    return Card(
      color: bg,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(br)),
      child: InkWell(
        borderRadius: BorderRadius.circular(br),
        splashColor: Color.lerp(pc, Colors.white, 0.7),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(br)),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (topTitle != null) ...[
                      Text(
                        topTitle,
                        style: TextStyle(fontSize: 10),
                      ),
                      SizedBox(height: 5),
                    ],
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (description != "") ...[
                      SizedBox(height: 2),
                      Text(
                        description,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (rightSide != null) ...[SizedBox(width: 20), rightSide],
            ],
          ),
        ),
        onTap: () async {
          onTap();
        },
        onLongPress: () async {
          onLongPress();
        },
      ),
    );
  }
}

imagePreview({
  @required String url,
  bool local = false,
  @required BuildContext context,
}) {
  EdgeInsets padding = const EdgeInsets.all(0);
  double br = 10;

  return showModal(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          titlePadding: padding,
          buttonPadding: padding,
          actionsPadding: padding,
          contentPadding: padding,
          insetPadding: const EdgeInsets.all(30),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(br)),
          ),
          content: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(br),
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: local ? AssetImage(url) : NetworkImage(url),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

simpleDialog({
  @required String title,
  @required BuildContext context,
  @required List<Widget> children,
  Color bg,
  bool dismissable = true,
}) async {
  await showModal(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        title: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: Text(title, style: TextStyle(color: Colors.white)),
          decoration: BoxDecoration(
            color: bg ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
        ),
        children: children,
      );
    },
  );
}

 simpleDialogOption({
  IconData icon,
  @required Widget child,
  @required Function onPressed,
}) {
  return SimpleDialogOption(
    child: icon != null
        ? Row(children: [Icon(icon, size: 18), SizedBox(width: 10), child])
        : child,
    onPressed: () => onPressed(),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  );
}

normalAlertDialog({
  @required String title,
  @required String description,
  @required BuildContext context,
  TextButton additionalActions,
  String closeTitle = 'CLOSE',
  bool goBackTwice = false,
  dynamic backResult,
  Function onTap,
}) async {
  await showModal(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        titlePadding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 2, 20, 20),
        actionsPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(description)),
        actions: [
          additionalActions,
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).primaryColor,
              ),
              overlayColor: MaterialStateProperty.all(
                Color.lerp(Colors.white, Theme.of(context).primaryColor, 0.9),
              ),
            ),
            child: Text(
              closeTitle.toUpperCase(),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (onTap != null) {
                onTap();
              } else {
                if (goBackTwice) Get.back();
                Get.back(result: backResult);
              }
            },
          ),
        ],
      );
    },
  );
}

int getColorHex(String title) {
  int temp = 0;
  color_list.forEach((element) {
    if (element['title'] == title) {
      temp = element['hex'];
    }
  });

  return temp;
}
