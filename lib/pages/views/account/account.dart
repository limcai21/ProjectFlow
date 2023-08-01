import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/contacts_launcher.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/account/update-email.dart';
import 'package:ProjectFlow/pages/views/account/update-password.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import 'about-us.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    const t = 1.0;
    const borderRadius = 10.0;
    var user = Auth().getCurrentUser();

    return CustomScaffold(
      title: "Account",
      subtitle: "Manage all your information here",
      layout: 2,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileCard(name: user.displayName ?? "", email: user.email),
                ListViewHeader(title: 'My Info'),
                CustomListTile(
                  title: "Email",
                  subtitle: "Update your email address",
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.mail_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_regular,
                  bgColor: Colors.orange,
                  onTap: () async {
                    await Get.to(
                      () => UpdateEmail(currentEmail: user.email),
                    );
                    print(Auth().getCurrentUser());
                    user = Auth().getCurrentUser();
                  },
                ),
                CustomListTile(
                  title: "Password",
                  subtitle: "Change your password",
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.password_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_regular,
                  bgColor: Colors.brown,
                  onTap: () {
                    Get.to(() => UpdatePassword());
                  },
                ),
                CustomListTile(
                  title: "Delete Account",
                  subtitle: "Once you delete, it's gone",
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.delete_24_filled,
                  bgColor: Colors.red,
                  onTap: () async {
                    normalAlertDialog(
                      title: destructiveTitle,
                      description:
                          'Are you sure you want to delete your account? All projects, topics & tasks will be gone',
                      context: context,
                      closeTitle: 'Delete',
                      additionalActions: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                            Color.lerp(
                              Theme.of(context).primaryColor,
                              Colors.white,
                              0.9,
                            ),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      onTap: () async {
                        Get.back();
                        loadingCircle(context: context);
                        var result = await Firestore().deleteAllDataFromUser(
                          id: Auth().getCurrentUser().uid,
                        );
                        if (result['status']) {
                          result = await Auth().deleteAccount();
                          if (result['status']) {
                            await Auth().logout();
                            Get.off(() => Home());
                          } else {
                            normalAlertDialog(
                              title: 'Error',
                              description: result['data'],
                              context: context,
                            );
                          }
                        } else {
                          normalAlertDialog(
                            title: 'Error',
                            description: result['data'],
                            context: context,
                          );
                        }
                      },
                    );
                  },
                ),
                CustomListTile(
                  title: "Logout",
                  subtitle: "You can always login again",
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.sign_out_24_filled,
                  bgColor: Colors.blue[700],
                  onTap: () async => {
                    await Auth().logout(),
                    Get.off(() => Home()),
                  },
                ),
                ListViewHeader(title: 'Company'),
                CustomListTile(
                  title: 'About Us',
                  subtitle: 'Find out more about us',
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.info_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_filled,
                  bgColor: Colors.green,
                  onTap: () => Get.to(() => AboutUs()),
                ),
                CustomListTile(
                  title: 'Feedback',
                  subtitle: 'Tell us if you encounter something odd',
                  t: t,
                  borderRadius: borderRadius,
                  icon: FluentIcons.person_feedback_24_filled,
                  trailingIcon: FluentIcons.open_24_filled,
                  bgColor: Colors.purple,
                  onTap: () => launchEmail(
                    company_feedback_email,
                    'Feedback on ProjectFlow',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  ProfileCard({@required this.name, @required this.email});

  @override
  Widget build(BuildContext context) {
    Color bgColor =
        Color.lerp(Colors.white, Theme.of(context).primaryColor, 0.125);

    return Container(
      padding: EdgeInsets.all(20),
      color: bgColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("images/defaultProfilePic.png"),
          ),
        ],
      ),
    );
  }
}
