import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
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

    Future onSubmit() async {
      if (formKey.currentState.validate()) {
        final topic = projectTopic.firstWhere(
          (t) => t.title == tTopicController.text,
          orElse: () => null,
        );

        final topicID = topic?.id ?? 0;

        if (topicID != 0) {
          final sDateTime = DateTime.parse(tStartDateController.text);
          final eDateTime = DateTime.parse(tEndDateController.text);
          final result = await Firestore().createTask(
            title: tTitleController.text,
            description: tDescriptionController.text,
            startDateTime: Timestamp.fromDate(sDateTime),
            endDateTime: Timestamp.fromDate(eDateTime),
            topicID: topicID,
            projectID: widget.id,
          );

          normalAlertDialog(
            title: result['status'] ? 'Created!' : 'Error',
            description: result['data'],
            context: context,
            goBackTwice: result['status'] ? true : false,
            backResult: result['status'] ? 'reload' : null,
          );
        } else {
          normalAlertDialog(
            title: 'Error',
            description: 'Fail to get topic',
            context: context,
          );
        }
      }
    }

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
                    TextFormField(
                      controller: tTopicController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Select Topic',
                        suffixIcon: Icon(topic_icon),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return topicEmptyNull;
                        }
                        return null;
                      },
                      onTap: () {
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
                      },
                    ),
                    // TITLE
                    TextFormField(
                      controller: tTitleController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(task_icon),
                        labelText: 'Task',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return taskEmptyNull;
                        }
                        return null;
                      },
                    ),
                    // DESCRIPTION
                    TextFormField(
                      controller: tDescriptionController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(FluentIcons.list_24_regular),
                        labelText: 'Description',
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 100,
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
                      use24HourFormat: false,
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(
                        labelText: 'Start Date & Time',
                        suffixIcon: Icon(FluentIcons.clock_24_regular),
                      ),
                      validator: (val) {
                        if (val == "") {
                          return 'Start ' + dateEmptyNull;
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
                      firstDate: DateTime.now().add(Duration(minutes: 1)),
                      lastDate: DateTime(DateTime.now().year + 99),
                      initialEntryMode: DatePickerEntryMode.input,
                      errorFormatText: "Invalid format",
                      use24HourFormat: false,
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(
                        labelText: 'End Date & Time',
                        suffixIcon: Icon(FluentIcons.clock_24_regular),
                      ),
                      validator: (val) {
                        if (val == "") {
                          return 'End ' + dateEmptyNull;
                        } else {
                          print("End Date & Time: " + val);
                          return null;
                        }
                      },
                    ),
                    // CREATE BTN
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: () => onSubmit(),
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
