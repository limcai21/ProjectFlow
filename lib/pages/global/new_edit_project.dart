import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:animations/animations.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewEditProject extends StatefulWidget {
  final bool edit;
  final String id;
  final Project projectData;
  final Color bg;
  NewEditProject({@required this.edit, this.id, this.projectData, this.bg});

  @override
  State<NewEditProject> createState() => _NewEditProjectState();
}

class _NewEditProjectState extends State<NewEditProject> {
  var formKey = GlobalKey<FormState>();
  final pTitleController = TextEditingController();
  final pColorController = TextEditingController();
  final pImageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.edit) {
      pTitleController.text = widget.projectData.title;
      pColorController.text = widget.projectData.theme;
      pImageController.text = widget.projectData.imageID;
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
        loadingCircle(context: context);
        if (widget.edit) {
          var uploadedImg = true;
          var bgURL = widget.projectData.backgroundURL;
          var imageID = widget.projectData.imageID;

          if (imageID != pImageController.text) {
            await Firestore().deleteImage(id: imageID);
            final iResult =
                await Firestore().uploadImage(path: pImageController.text);
            if (iResult['status']) {
              bgURL = iResult['url'];
              imageID = iResult['imageID'];
              uploadedImg = true;
            } else {
              Get.back();
              uploadedImg = false;
              return normalAlertDialog(
                title: alertErrorTitle,
                description: iResult['msg'],
                context: context,
              );
            }
          }

          if (uploadedImg) {
            var result = await Firestore().updateProject(
              id: widget.id,
              title: pTitleController.text,
              theme: pColorController.text,
              backgroundURL: bgURL,
              imageID: imageID,
            );
            Get.back();
            normalAlertDialog(
              title: result['status'] ? 'Done' : alertErrorTitle,
              description: result['data'],
              context: context,
              goBackTwice: result['status'] ? true : null,
              backResult: 'reload',
            );
          }
        } else {
          var userID = Auth().getCurrentUser().uid;
          final iResult =
              await Firestore().uploadImage(path: pImageController.text);

          if (iResult['status']) {
            var result = await Firestore().createProject(
              title: pTitleController.text,
              theme: pColorController.text,
              backgroundURL: iResult['url'],
              imageID: iResult['imageID'],
              userID: userID,
            );
            Get.back();
            normalAlertDialog(
              title: result['status'] ? 'Created!' : alertErrorTitle,
              context: context,
              description: result['data'],
              goBackTwice: result['status'] ? true : null,
              backResult: result['status'] ? 'reload' : null,
            );
          } else {
            Get.back();
            normalAlertDialog(
              title: alertErrorTitle,
              context: context,
              description: iResult['data'],
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
      backgroundColor: widget.bg ?? Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 20,
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
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onLongPress: () {
                    if (widget.edit) {
                      if (pImageController.text != widget.projectData.imageID) {
                        imagePreview(
                          url: pImageController.text,
                          local: true,
                          context: context,
                        );
                      } else {
                        imagePreview(
                          url: widget.projectData.backgroundURL,
                          context: context,
                          local: false,
                        );
                      }
                    } else {
                      if (pImageController.text != "") {
                        imagePreview(
                          url: pImageController.text,
                          local: true,
                          context: context,
                        );
                      } else {
                        normalAlertDialog(
                          title: alertErrorTitle,
                          description: 'Select an image first',
                          context: context,
                        );
                      }
                    }
                  },
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    PickedFile pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    pImageController.text = pickedFile.path;
                  },
                  child: IgnorePointer(
                    ignoring: true,
                    child: TextFormField(
                      enableInteractiveSelection: false,
                      controller: pImageController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return bgEmptyNull;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(FluentIcons.image_24_regular),
                        labelText: 'Background Image',
                        helperText: 'Hold to preview image',
                      ),
                    ),
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
                        widget.bg ?? Theme.of(context).primaryColor,
                      ),
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
