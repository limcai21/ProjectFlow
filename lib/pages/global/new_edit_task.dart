import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'constants.dart';
import 'notification.dart';
import 'scaffold.dart';

class NewEditTask extends StatefulWidget {
  final String id;
  final bool edit;
  final Task taskData;
  final Color bg;
  NewEditTask({@required this.id, @required this.edit, this.taskData, this.bg});

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
    if (projectTopic.length == 0) {
      normalAlertDialog(
        title: alertErrorTitle,
        description:
            'You have no topic yet. Please create a topic before continuing to create task',
        context: context,
        goBackTwice: true,
      );
    }

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
        loadingCircle(context: context);
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
          var t = await Firestore().getWatchesByTaskID(id: widget.taskData.id);
          var check = false;

          if (t['status']) {
            print("IN WATCH LIST");
            print(temp);
            // CHECK FOR EXISTING NOTIFICATION TO UPDATE
            temp.forEach((n) async {
              widget.taskData.title = tTitleController.text;
              widget.taskData.description = tDescriptionController.text;
              widget.taskData.startDateTime = Timestamp.fromDate(sDateTime);
              widget.taskData.endDateTime = Timestamp.fromDate(eDateTime);
              widget.taskData.topicID = topic.id;
              var l = generateAlertOption(
                widget.taskData,
                context,
                insert: false,
              ).length;

              if (n.id == int.parse(widget.taskData.uuidNum)) {
                check = true;
                print("notification exist, updating it");
                cancelNotification(id: widget.taskData.uuidNum);

                if (l > 0) {
                  Get.back();
                  await simpleDialog(
                    title: 'Alert',
                    dismissable: false,
                    context: context,
                    children: generateAlertOption(
                      widget.taskData,
                      context,
                      insert: false,
                    ),
                  );
                  await normalAlertDialog(
                    title: result['status'] ? 'Updated!' : alertErrorTitle,
                    description: result['data'],
                    context: context,
                    goBackTwice: result['status'] ? true : false,
                    backResult: result['status'] ? 'reload' : null,
                  );
                } else {
                  Get.back();
                  normalAlertDialog(
                    title: 'Oops',
                    description:
                        "It seems like the current end date and time you set is a bit too close for me to send a notification. Don't worry, though! I'll still keep an eye on it in my watchlist",
                    context: context,
                  );
                }
              }
            });

            if (!check) {
              Get.back();
              normalAlertDialog(
                title: result['status'] ? 'Updated!' : alertErrorTitle,
                description: result['data'],
                context: context,
                goBackTwice: result['status'] ? true : false,
                backResult: result['status'] ? 'reload' : null,
              );
            }
          } else {
            print("NOT IN WATCH LIST");
            Get.back();
            normalAlertDialog(
              title: result['status'] ? 'Updated!' : alertErrorTitle,
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
              userID: Auth().getCurrentUser().uid,
              uuid: (Uuid().v4().numericOnly()).substring(0, 8),
            );
            Get.back();
            normalAlertDialog(
              title: result['status'] ? 'Created!' : alertErrorTitle,
              description: result['data'],
              context: context,
              goBackTwice: result['status'] ? true : false,
              backResult: result['status'] ? 'reload' : null,
            );
          } else {
            Get.back();
            normalAlertDialog(
              title: alertErrorTitle,
              description: 'Fail to get topics',
              context: context,
              goBackTwice: true,
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
      backgroundColor: widget.bg ?? Theme.of(context).primaryColor,
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
                        maxLength: 50,
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
                        initialDatePickerMode: DatePickerMode.day,
                        initialEntryMode: DatePickerEntryMode.calendar,
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
                        initialDatePickerMode: DatePickerMode.day,
                        initialEntryMode: DatePickerEntryMode.calendar,
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
