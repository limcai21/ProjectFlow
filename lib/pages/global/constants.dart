import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const dateFormat = 'dd MMM yyyy, h:mm a';
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
const company_website = "arnet.com.sg";

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

// FUNCTIONS AND WIDGET
int getHexValue(String colorTitle) {
  for (var color in color_list) {
    if (color['title'] == colorTitle) {
      return color['hex'];
    }
  }
  return null;
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
    @required this.bgColor,
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
        color: bgColor,
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
    return Center(
      child: SvgPicture.asset(
        "images/clock.svg",
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

simpleDialog({
  @required String title,
  @required BuildContext context,
  @required List<Widget> children,
}) {
  showDialog(
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
            color: Theme.of(context).primaryColor,
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
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
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
              print(backResult);
              if (goBackTwice) Get.back();
              Get.back(result: backResult);
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
