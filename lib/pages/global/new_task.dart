import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'constants.dart';
import 'new_topic.dart';
import 'scaffold.dart';

class NewTask extends StatefulWidget {
  final String id;
  NewTask({@required this.id});

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  bool loading = true;
  List<Topic> projectTopic = [];

  startup() async {
    projectTopic = await Firestore().getTopicByProjectID(id: widget.id);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final tTopicController = TextEditingController();
    final tTitleController = TextEditingController();
    final tDescriptionController = TextEditingController();
    final tStartDateController = TextEditingController();
    final tEndDateController = TextEditingController();

    return CustomScaffold(
      title: "New Task",
      subtitle: "Create task and add them to your topic",
      layout: 2,
      body: loading
          ? Loading()
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOPIC
                    CustomTextFormField(
                        controller: tTopicController,
                        labelText: 'Select Topic',
                        readOnly: true,
                        validator: (val) => print("Topic: " + val),
                        onTap: () {
                          if (projectTopic.length > 0) {
                            return simpleDialog(
                              title: "Select Topic",
                              context: context,
                              children: projectTopic.map<Widget>((t) {
                                String title = t.title;
                                return simpleDialogOption(
                                  child: Text(title),
                                  onPressed: () => {
                                    tTopicController.text = title,
                                    Navigator.pop(context),
                                  },
                                );
                              }).toList(),
                            );
                          } else {
                            Get.off(() => NewTopic(id: widget.id));
                          }
                        }),
                    // TITLE
                    CustomTextFormField(
                      controller: tTitleController,
                      // icon: FluentIcons.slide_multiple_24_regular,
                      labelText: 'Task',
                      validator: (val) => print("Task: " + val),
                    ),
                    // DESCRIPTION
                    CustomTextFormField(
                      controller: tDescriptionController,
                      // icon: task_icon,
                      labelText: 'Description',
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 100,
                      validator: (val) => print("Task Description: " + val),
                    ),

                    // START DATE
                    DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      dateMask: dateFormat,
                      controller: tStartDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 99),
                      initialEntryMode: DatePickerEntryMode.input,
                      errorFormatText: "Invalid format",
                      // icon: Icon(Icons.event),
                      dateLabelText: 'Start Date & Time',
                      use24HourFormat: false,
                      scrollPhysics: BouncingScrollPhysics(),
                      validator: (val) {
                        if (val == "") {
                          return dateEmptyNull;
                        } else {
                          print("Start Date & Time: " + val);
                          return null;
                        }
                      },
                    ),

                    // END DATE
                    DateTimePicker(
                      type: DateTimePickerType.dateTime,
                      dateMask: dateFormat,
                      controller: tEndDateController,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 99),
                      initialEntryMode: DatePickerEntryMode.input,
                      errorFormatText: "Invalid format",
                      // icon: Icon(Icons.event),
                      dateLabelText: 'End Date & Time',
                      use24HourFormat: false,
                      scrollPhysics: BouncingScrollPhysics(),
                      validator: (val) {
                        if (val == "") {
                          return dateEmptyNull;
                        } else {
                          print("End Date & Time: " + val);
                          return null;
                        }
                      },
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            print("Create Task");
                          }
                        },
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
