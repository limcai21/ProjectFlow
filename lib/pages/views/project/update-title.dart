import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:ProjectFlow/pages/global/constants.dart';

class UpdateProjectTitle extends StatelessWidget {
  final String currentProjectName;
  final String projectID;
  UpdateProjectTitle(
      {@required this.projectID, @required this.currentProjectName});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();

    return CustomScaffold(
      layout: 2,
      title: 'Project Title',
      subtitle: 'Update your Project Title',
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  icon: Icon(FluentIcons.text_24_regular),
                  helperText: 'e.g: ProjectFlow',
                  labelText: 'Project Title',
                  hintText: currentProjectName,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emailEmptyNull;
                  } else if (value == currentProjectName) {
                    return projectNameSame;
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
                      var result = await Firestore().updateProjectTitle(
                        id: projectID,
                        title: nameController.text,
                      );
                      normalAlertDialog(
                        title: result['status'] ? 'Done' : 'Error',
                        description: result['data'],
                        context: context,
                        goBackTwice: result['status'] ? true : null,
                        backResult: 'reload',
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
