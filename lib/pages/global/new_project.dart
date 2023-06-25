import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class NewProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final pTitleController = TextEditingController();
    final pColorConroller = TextEditingController();
    final Controller controller = Get.find<Controller>();
    List<Map> temp = [];

    color_list.forEach((element) {
      temp.add(element);
    });

    void submitForm() {
      final isValid = formKey.currentState.validate();
      if (!isValid) {
        return;
      } else {
        print("Create Project (In submit_form())");
      }
    }

    return CustomScaffold(
      title: "New Project",
      subtitle: "Start a new project here",
      layout: 2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                controller: pTitleController,
                icon: project_icon,
                labelText: 'Project Title',
                validator: (value) => {
                  // CHECK IF PROJECT EXIST
                  print("check if project exist")
                },
              ),
              Obx(
                () => CustomTextFormField(
                  initalValue: controller.selectedNewProjectTheme.toString(),
                  controller: pColorConroller,
                  icon: FluentIcons.color_24_regular,
                  labelText: 'Theme',
                  readOnly: true,
                  onTap: () => simpleDialog(
                    context: context,
                    title: "Select Theme",
                    children: color_list.map<Widget>((element) {
                      String title = element['title'].toString();
                      int hex = element['hex'];
                      return simpleDialogOption(
                        child: Row(
                          children: [
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Color(hex),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(title),
                          ],
                        ),
                        onPressed: () => {
                          Navigator.pop(context),
                          controller.setNewProjectTheme(title),
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () => submitForm(),
                  child: Text('Create'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
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
