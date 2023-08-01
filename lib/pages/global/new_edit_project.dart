import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final pImageController = TextEditingController();

  imagePreview({@required String url, bool local = false}) {
    double br = 10;

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(br),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(br),
                      topRight: Radius.circular(br),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: 20,
                  ),
                  child: Text(
                    "Image Preview",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(br),
                      bottomRight: Radius.circular(br),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: local ? AssetImage(url) : NetworkImage(url),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
                title: 'Error',
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
              title: result['status'] ? 'Done' : 'Error',
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
              title: result['status'] ? 'Created!' : 'Error',
              context: context,
              description: result['data'],
              goBackTwice: result['status'] ? true : null,
              backResult: result['status'] ? 'reload' : null,
            );
          } else {
            Get.back();
            normalAlertDialog(
              title: 'Error',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
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
                  maxLength: 50,
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
                        imagePreview(url: pImageController.text, local: true);
                      } else {
                        imagePreview(
                          url: widget.projectData.backgroundURL,
                          local: false,
                        );
                      }
                    } else {
                      if (pImageController.text != "") {
                        imagePreview(url: pImageController.text, local: true);
                      } else {
                        normalAlertDialog(
                          title: 'Error',
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
                        Theme.of(context).primaryColor,
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
