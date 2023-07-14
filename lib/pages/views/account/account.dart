import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/contacts_launcher.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/account/update-email.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import 'about-us.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const t = 1.0;
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
                  icon: FluentIcons.mail_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_regular,
                  bgColor: Colors.orange,
                  onTap: () => Get.to(
                    () => UpdateEmail(currentEmail: user.email),
                  ),
                ),
                CustomListTile(
                  title: "Password",
                  subtitle: "Change your password",
                  t: t,
                  icon: FluentIcons.password_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_regular,
                  bgColor: Colors.brown,
                  // onTap: () => Get.to(()=>UpdatePassword(currentPassword: user.updatePassword(newPassword))),
                ),
                CustomListTile(
                  title: "Delete Account",
                  subtitle: "Once you delete, it's gone",
                  t: t,
                  icon: FluentIcons.delete_24_filled,
                  bgColor: Colors.red,
                  onTap: () => print("a"),
                ),
                CustomListTile(
                  title: "Logout",
                  subtitle: "You can always sign back in",
                  t: t,
                  icon: FluentIcons.sign_out_24_filled,
                  bgColor: Colors.blueGrey,
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
                  icon: FluentIcons.info_24_filled,
                  trailingIcon: FluentIcons.chevron_right_24_filled,
                  bgColor: Colors.green,
                  onTap: () => Get.to(AboutUs()),
                ),
                CustomListTile(
                  title: 'Feedback',
                  subtitle: 'Tell us if you encounter something odd',
                  t: t,
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
