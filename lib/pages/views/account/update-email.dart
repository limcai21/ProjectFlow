import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:get/get.dart';

class UpdateEmail extends StatelessWidget {
  final String currentEmail;
  UpdateEmail({@required this.currentEmail});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();

    return CustomScaffold(
      layout: 2,
      title: 'Email',
      subtitle: 'Update your Email',
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.mail_24_regular),
                  helperText: 'e.g: projecflow@arnet.com',
                  labelText: 'Email',
                  hintText: currentEmail,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emailEmptyNull;
                  } else if (!RegExp(emailRegex).hasMatch(value)) {
                    return emailInvalid;
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState.validate()) {
                      loadingCircle(context: context);
                      var result = await Auth()
                          .updateEmail(newEmail: emailController.text);
                      Get.back();
                      normalAlertDialog(
                        title: result['status'] ? emailUpdateTitle : alertErrorTitle,
                        description: result['data'],
                        context: context,
                        goBackTwice: result['status'] ? true : false,
                      );
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
    );
  }
}
