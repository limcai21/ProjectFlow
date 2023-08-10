import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/contacts_launcher.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/account/update-email.dart';
import 'package:ProjectFlow/pages/views/account/update-password.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../main.dart';
import 'about-us.dart';

class Account extends StatefulWidget {
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User user;

  void refreshUserDetails() {
    setState(() {
      user = Auth().getCurrentUser();
    });
  }

  @override
  void initState() {
    super.initState();
    refreshUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    const t = 1.0;
    const borderRadius = 8.0;
    Color bgColor = Color.lerp(
      Colors.white,
      Theme.of(context).primaryColor,
      0.125,
    );

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
                Container(
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
                            user.displayName.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email.toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .fontSize,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          simpleDialog(
                              title: 'Profile Picture',
                              context: context,
                              children: [
                                simpleDialogOption(
                                  child: Text("View Profile Picture"),
                                  icon: FluentIcons.image_24_regular,
                                  onPressed: () {
                                    Get.back();
                                    imagePreview(
                                      local:
                                          user.photoURL != null ? false : true,
                                      url: user.photoURL != null
                                          ? user.photoURL
                                          : "images/defaultProfilePic.png",
                                      context: context,
                                    );
                                  },
                                ),
                                simpleDialogOption(
                                  icon: FluentIcons.image_edit_24_regular,
                                  child: Text("Change Profile Picture"),
                                  onPressed: () async {
                                    Get.back();
                                    loadingCircle(context: context);
                                    final ImagePicker picker = ImagePicker();
                                    PickedFile pickedFile = await picker
                                        .getImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      var ur = await Firestore()
                                          .uploadImage(path: pickedFile.path);
                                      if (ur['status']) {
                                        var result = await Auth()
                                            .updateProfilePic(url: ur['url']);
                                        Get.back();
                                        normalAlertDialog(
                                          title: result['status']
                                              ? 'Updated'
                                              : alertErrorTitle,
                                          context: context,
                                          description: result['data'],
                                          goBackTwice:
                                              result['status'] ? true : null,
                                          backResult: result['status']
                                              ? 'reload'
                                              : null,
                                        );

                                        if (result['status'])
                                          refreshUserDetails();
                                      } else {
                                        Get.back();
                                        normalAlertDialog(
                                          title: alertErrorTitle,
                                          description: ur['data'],
                                          context: context,
                                        );
                                      }
                                    } else {
                                      Get.back();
                                    }
                                  },
                                )
                              ]);
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL)
                              : AssetImage("images/defaultProfilePic.png"),
                        ),
                      )
                    ],
                  ),
                ),
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
                    refreshUserDetails();
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
                        var result = await Firestore()
                            .deleteAllDataFromUser(id: user.uid);
                        if (result['status']) {
                          Get.back();
                          var r = await Auth().deleteAccount();
                          Get.back();
                          normalAlertDialog(
                            title: r['status'] ? 'Deleted!' : alertErrorTitle,
                            description: r['data'],
                            context: context,
                            onTap: () async {
                              if (r['status']) {
                                await Auth().logout(false);
                                Get.off(() => Home());
                              } else {
                                Get.back();
                              }
                            },
                          );
                        } else {
                          Get.back();
                          normalAlertDialog(
                            title: alertErrorTitle,
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
                    await Auth().logout(true),
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
