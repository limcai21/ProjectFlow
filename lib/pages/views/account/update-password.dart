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
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypeNewPasswordController = TextEditingController();

    return CustomScaffold(
      layout: 2,
      title: 'Password',
      subtitle: 'Update your password',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
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
                      return currentPasswordEmptyNull;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        var result = await Auth().updatePassword(
                          currentPassword: currentPasswordController.text,
                          newPassword: retypeNewPasswordController.text,
                        );

                        if (result['status']) {
                          normalAlertDialog(
                            title: "Updated!",
                            description: result['message'],
                            context: context,
                            goBackTwice: true,
                          );
                        } else {
                          normalAlertDialog(
                            title: "Error",
                            description: result['message'],
                            context: context,
                          );
                        }
                      }
                    },
                    child: Text('Update'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
