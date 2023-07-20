import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class NewEditProject extends StatefulWidget {
  final bool edit;
  final String id;
  final Project projectData;
  NewEditProject({@required this.edit, this.id, this.projectData});

  @override
  State<NewEditProject> createState() => _NewEditProjectState();
}

class _NewEditProjectState extends State<NewEditProject> {
  var formKey = GlobalKey<FormState>();
  final pTitleController = TextEditingController();
  final pColorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.edit) {
      pTitleController.text = widget.projectData.title;
      pColorController.text = widget.projectData.theme;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map> temp = [];
    color_list.forEach((element) {
      temp.add(element);
    });

    Future submitForm() async {
      final isValid = formKey.currentState.validate();
      if (!isValid) {
        return;
      } else {
        if (widget.edit) {
          var result = await Firestore().updateProjectTitle(
            id: widget.id,
            title: pTitleController.text,
            theme: pColorController.text,
          );
          normalAlertDialog(
            title: result['status'] ? 'Done' : 'Error',
            description: result['data'],
            context: context,
            goBackTwice: result['status'] ? true : null,
            backResult: 'reload',
          );
        } else {
          var userID = Auth().getCurrentUser().uid;
          var result = await Firestore().createProject(
            title: pTitleController.text,
            theme: pColorController.text,
            userID: userID,
          );

          if (result['status']) {
            normalAlertDialog(
              title: 'Created!',
              context: context,
              description: result['data'],
              goBackTwice: true,
              backResult: 'reload',
            );
          } else {
            normalAlertDialog(
              title: 'Error',
              context: context,
              description: result['data'],
            );
          }
        }
      }
    }

    return CustomScaffold(
      title: widget.edit ? 'Edit Project' : "New Project",
      subtitle: widget.edit
          ? 'Make some adjustment to your project'
          : "Start a new project here",
      layout: 2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: pTitleController,
                decoration: InputDecoration(
                  suffixIcon: Icon(project_icon),
                  labelText: 'Project Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return projectEmptyNull;
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: pColorController,
                decoration: InputDecoration(
                  labelText: 'Theme',
                  suffixIcon: Icon(FluentIcons.color_24_regular),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return themeEmptyNull;
                  }
                  return null;
                },
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
                        pColorController.text = title,
                        Navigator.pop(context),
                      },
                    );
                  }).toList(),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () => submitForm(),
                  child: Text(widget.edit ? 'Update' : 'Create'),
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
