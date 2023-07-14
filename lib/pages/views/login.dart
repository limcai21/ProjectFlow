import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/skeleton.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Login",
      subtitle: "Sign in to view all your projects",
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
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                // initialValue: 'test@example.com',
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.mail_24_filled),
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
                // initialValue: "P@ssw0rd!",
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.password_24_filled),
                  labelText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return passwordEmptyNull;
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    Map loginResult = await Auth().login(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    if (loginResult['status']) {
                      Get.back();
                      Get.off(() => MainSkeleton());
                    } else {
                      normalAlertDialog(
                        context: context,
                        title: loginFailTitle,
                        description: loginResult['data'],
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
