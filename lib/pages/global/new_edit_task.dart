import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'notification.dart';
import 'scaffold.dart';

class NewEditTask extends StatefulWidget {
  final String id;
  final bool edit;
  final Task taskData;
  NewEditTask({@required this.id, @required this.edit, this.taskData});

  @override
  State<NewEditTask> createState() => _NewEditTaskState();
}

class _NewEditTaskState extends State<NewEditTask> {
  bool loading = true;
  bool readOnlyTopic = false;
  List<Topic> projectTopic = [];
  final formKey = GlobalKey<FormState>();
  final tTopicController = TextEditingController();
  final tTitleController = TextEditingController();
  final tDescriptionController = TextEditingController();
  final tStartDateController = TextEditingController();
  final tEndDateController = TextEditingController();

  startup() async {
    projectTopic = await Firestore().getTopicByProjectID(id: widget.id);
    setState(() {
      loading = false;
    });

    if (widget.edit) {
      var data = widget.taskData;
      tTitleController.text = data.title;
      tDescriptionController.text = data.description;
      tStartDateController.text = data.startDateTime.toDate().toString();
      tEndDateController.text = data.endDateTime.toDate().toString();
      projectTopic.forEach((v) {
        if (v.id == widget.taskData.topicID) {
          tTopicController.text = v.title;
          readOnlyTopic = true;
        }
      });
    } else {
      readOnlyTopic = true;
    }
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    Future onSubmit() async {
      if (formKey.currentState.validate()) {
        if (widget.edit) {
          final sDateTime = DateTime.parse(tStartDateController.text);
          final eDateTime = DateTime.parse(tEndDateController.text);
          final topic = projectTopic.firstWhere(
            (t) => t.title == tTopicController.text,
            orElse: () => null,
          );

          // UPDATE TASK
          final result = await Firestore().updateTask(
            id: widget.taskData.id,
            title: tTitleController.text,
            description: tDescriptionController.text,
            startDateTime: Timestamp.fromDate(sDateTime),
            endDateTime: Timestamp.fromDate(eDateTime),
            topicID: topic.id,
          );

          // GET ALL NOTIFICATION
          var temp = await getScheduledNotifications();
          int intID = notificationID(widget.taskData.id);
          var t = await Firestore().getWatchesByTaskID(id: widget.taskData.id);

          if (t['status']) {
            print("IN WATCH LIST");
            print(temp);
            // CHECK FOR EXISTING NOTIFICATION TO UPDATE
            temp.forEach((n) async {
              print(n.id);
              widget.taskData.title = tTitleController.text;
              widget.taskData.description = tDescriptionController.text;
              widget.taskData.startDateTime = Timestamp.fromDate(sDateTime);
              widget.taskData.endDateTime = Timestamp.fromDate(eDateTime);
              widget.taskData.topicID = topic.id;
              var l = generateAlertOption(widget.taskData, context).length;

              if (n.id == intID) {
                print("notification exist, updating it");
                cancelNotification(id: widget.taskData.id);

                if (l > 0) {
                  await simpleDialog(
                    title: 'Alert',
                    dismissable: false,
                    context: context,
                    children: generateAlertOption(widget.taskData, context),
                    then: (v) {
                      normalAlertDialog(
                        title: result['status'] ? 'Updated!' : 'Error',
                        description: result['data'],
                        context: context,
                        goBackTwice: result['status'] ? true : false,
                        backResult: result['status'] ? 'reload' : null,
                      );
                    },
                  );
                } else {
                  normalAlertDialog(
                    title: 'Oops',
                    description:
                        "It seems like the current end date and time you set is a bit too close for me to send a notification. Don't worry, though! I'll still keep an eye on it in my watchlist",
                    context: context,
                  );
                }
              } else {
                print("no notification but in watch list");
              }
            });
          } else {
            print("NOT IN WATCH LIST");
            normalAlertDialog(
              title: result['status'] ? 'Updated!' : 'Error',
              description: result['data'],
              context: context,
              goBackTwice: result['status'] ? true : false,
              backResult: result['status'] ? 'reload' : null,
            );
          }
        } else {
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
    }

    return CustomScaffold(
      title: widget.edit ? 'Edit Task' : "New Task",
      subtitle: widget.edit
          ? 'Make some adjustment to your task'
          : "Create task and add them to your topic",
      layout: 2,
      body: loading
          ? Loading()
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TOPIC
                      TextFormField(
                        controller: tTopicController,
                        readOnly: readOnlyTopic,
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
                        firstDate: DateTime(DateTime.now().year - 99),
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
                            return 'Start: ' + dateEmptyNull;
                          }

                          return null;
                        },
                      ),
                      // END DATE
                      DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        dateMask: dateFormat,
                        controller: tEndDateController,
                        firstDate: DateTime(DateTime.now().year - 99),
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
                            var start =
                                DateTime.parse(tStartDateController.text);
                            var end = DateTime.parse(val);
                            int result = end.compareTo(start);
                            if (result < 0) {
                              return startDateAfterEndDate;
                            } else if (result == 0) {
                              return startDateSameAsEndDate;
                            }
                          }
                          return null;
                        },
                      ),
                      // CREATE BTN
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          onPressed: () => onSubmit(),
                          child: Text(widget.edit ? 'Save' : 'Create'),
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