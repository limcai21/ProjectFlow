import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  checkRetypePasswordAndPasswordAreSame() {
    final password =
        passwordController.text != null ? passwordController.text : "";
    final retypePassword = confirmPasswordController.text != null
        ? confirmPasswordController.text
        : "";
    if (password != retypePassword) {
      return passwordAndRetypePasswordDifferent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Sign Up",
      subtitle: "Start getting productivity",
      layout: 2,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.person_24_regular),
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return nameEmptyNull;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.mail_24_regular),
                  labelText: 'Email',
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
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.password_24_regular),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return passwordEmptyNull;
                  } else {
                    return checkRetypePasswordAndPasswordAreSame();
                  }
                },
              ),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.password_24_regular),
                  labelText: 'Retype Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return retpyePasswordEmptyNull;
                  } else {
                    return checkRetypePasswordAndPasswordAreSame();
                  }
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    loadingCircle(context: context);
                    var signUpResult = await Auth().signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      name: nameController.text,
                    );
                    Get.back();
                    if (signUpResult['status']) {
                      normalAlertDialog(
                        title: registerDoneTitle,
                        context: context,
                        description: signUpResult['data'],
                        goBackTwice: true,
                      );
                    } else {
                      normalAlertDialog(
                        title: registerFailTitle,
                        context: context,
                        description: signUpResult['data'],
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text('Sign Up', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
