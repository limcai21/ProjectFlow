import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';

class UpdatePassword extends StatefulWidget {
  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final formKey2 = GlobalKey<FormState>();
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypeNewPasswordController = TextEditingController();
    bool isCurrentPasswordCorrect = false;

    checkCurrentPasswordForm() {
      return Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(FluentIcons.lock_closed_24_regular),
                labelText: 'Current Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password.';
                }
                return null;
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    var result = await Auth().updatePassword(
                      currentPassword: currentPasswordController.text,
                      checkCurrentPassword: true,
                    );

                    if (result['status']) {
                      setState(() {
                        isCurrentPasswordCorrect = true;
                      });
                    } else {
                      currentPasswordController.text = '';
                      normalAlertDialog(
                        title: "Error",
                        description: result['message'],
                        context: context,
                      );
                    }
                  }
                },
                child: Text('Next'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      );
    }

    changePasswordForm() {
      return Form(
        key: formKey2,
        child: Column(
          children: [
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(FluentIcons.lock_closed_24_filled),
                hintText: '',
                labelText: 'New Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return newPasswordEmptyNull;
                } else if (newPasswordController.text !=
                    retypeNewPasswordController.text) {
                  return newPasswordAndRetypeNewPasswordDifferent;
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: retypeNewPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                icon: Icon(FluentIcons.lock_closed_24_filled),
                hintText: '',
                labelText: 'Retype New Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return retpyeNewPasswordEmptyNull;
                } else if (newPasswordController.text !=
                    retypeNewPasswordController.text) {
                  return newPasswordAndRetypeNewPasswordDifferent;
                }
                return null;
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    // await Auth().updatePassword(currentPassword: )
                    // await updatePassword();
                    // await nortmalAlertDialog(
                    //   passwordChangedTitle,
                    //   passwordChangedDescription,
                    //   context,
                    // );
                  }
                },
                child: Text('Change Password'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return CustomScaffold(
      layout: 2,
      title: 'Password',
      subtitle: 'Update your password',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isCurrentPasswordCorrect
              ? changePasswordForm()
              : checkCurrentPasswordForm(),
        ),
      ),
    );
  }
}
