import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/new_edit_topic.dart';
import 'package:ProjectFlow/pages/global/notification.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/project/setting.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectPage extends StatefulWidget {
  final String id;
  ProjectPage({@required this.id});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool loading = true;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  Project projectDetails;
  List<Topic> projectTopics = [];
  List<Task> projectTask = [];
  List<Task> outputProjectTask = [];
  Map<String, List<Task>> output = {};

  startup() async {
    Map<String, List<Task>> tempOutput = {};
    Project pTemp = await Firestore().getProjectByProjectID(id: widget.id);
    List<Topic> tTemp = await Firestore().getTopicByProjectID(id: widget.id);
    List<Task> taskTemp = await Firestore().getTaskByProjectID(id: widget.id);

    tTemp.forEach((topic) {
      List<Task> temp = [];
      taskTemp.forEach((task) {
        if (task.topicID == topic.id) {
          temp.add(task);
        }
      });
      tempOutput[topic.id] = temp;
    });

    setState(() {
      projectDetails = pTemp;
      projectTopics = tTemp;
      projectTask = taskTemp;
      output = tempOutput;
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
    int tabIndex = 0;

    return CustomScaffold(
      layout: 2,
      title: loading
          ? 'Title'
          : projectDetails != null
              ? projectDetails.title
              : "",
      subtitle: loading && projectDetails != null
          ? 'Subtitle'
          : projectDetails != null
              ? 'Created on: ' +
                  DateFormat(dateFormat)
                      .format(projectDetails.createdDateTime.toDate())
              : "",
      tab: true,
      actionBtn: [
        if (!loading)
          IconButton(
            icon: Icon(
              FluentIcons.settings_24_regular,
              color: Colors.white,
            ),
            onPressed: () async {
              await Get.to(() => ProjectSettings(id: widget.id));
              startup();
            },
          ),
      ],
      fab: loading
          ? null
          : SpeedDial(
              marginBottom: 20,
              marginEnd: 20,
              overlayOpacity: 0.5,
              icon: FluentIcons.add_24_filled,
              activeIcon: FluentIcons.dismiss_24_filled,
              openCloseDial: isDialOpen,
              children: [
                if (projectTopics.length > 0)
                  SpeedDialChild(
                    label: 'Task',
                    labelStyle: TextStyle(color: Colors.white),
                    child: Icon(task_icon),
                    onTap: () async {
                      final result = await Get.to(
                        () => NewEditTask(
                          id: widget.id,
                          edit: false,
                        ),
                      );
                      if (result == 'reload') startup();
                    },
                  ),
                SpeedDialChild(
                  label: 'Topic',
                  labelStyle: TextStyle(color: Colors.white),
                  child: Icon(topic_icon),
                  onTap: () async {
                    final result = await Get.to(
                      () => NewEditTopic(
                        id: widget.id,
                        edit: false,
                      ),
                    );
                    if (result == 'reload') startup();
                  },
                )
              ],
            ),
      body: loading
          ? Loading()
          : projectTopics.length > 0
              ? DefaultTabController(
                  length: projectTopics.length,
                  initialIndex: tabIndex,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Theme.of(context).primaryColor,
                        child: TabBar(
                          isScrollable: true,
                          indicatorColor: Colors.white,
                          physics: BouncingScrollPhysics(),
                          onTap: (i) => tabIndex = i,
                          tabs: List.generate(
                            projectTopics.length,
                            (i) => GestureDetector(
                              child: Tab(text: projectTopics[i].title),
                              onLongPress: () {
                                return simpleDialog(
                                  title: 'Quick Actions',
                                  context: context,
                                  children: [
                                    simpleDialogOption(
                                      icon: FluentIcons.edit_24_regular,
                                      child: Text('Edit Topic'),
                                      onPressed: () async {
                                        Get.back();
                                        final result = await Get.to(
                                          () => NewEditTopic(
                                            id: widget.id,
                                            edit: true,
                                            topicData: projectTopics[i],
                                          ),
                                        );
                                        if (result == 'reload') startup();
                                      },
                                    ),
                                    simpleDialogOption(
                                      icon: FluentIcons.delete_24_regular,
                                      child: Text('Delete Topic'),
                                      onPressed: () async {
                                        await Firestore().deleteTopic(
                                          id: projectTopics[i].id,
                                        );
                                        startup();
                                        Get.back();
                                      },
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: List.generate(output.length, (i) {
                            if (output[projectTopics[i].id].length > 0) {
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: output[projectTopics[i].id].length,
                                itemBuilder: (context, index) {
                                  final current = projectTopics[i].id;
                                  final content = output[current][index];
                                  final sDateTime = DateFormat(dateFormat)
                                      .format(content.startDateTime.toDate());
                                  final eDateTime = DateFormat(dateFormat)
                                      .format(content.endDateTime.toDate());
                                  final subtitle =
                                      sDateTime + ' - ' + eDateTime;

                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    trailing: Icon(
                                      FluentIcons.chevron_right_24_filled,
                                      size: 18,
                                    ),
                                    title: Text(content.title),
                                    subtitle: Text(subtitle),
                                    onTap: () async {
                                      var result = await Get.to(
                                        () => NewEditTask(
                                          id: content.projectID,
                                          edit: true,
                                          taskData: content,
                                        ),
                                      );

                                      if (result == 'reload') startup();
                                    },
                                    onLongPress: () async {
                                      var userID = Auth().getCurrentUser().uid;
                                      var result = await Firestore()
                                          .getWatchesByTaskID(id: content.id);

                                      return simpleDialog(
                                        title: 'Quick Actions',
                                        context: context,
                                        children: [
                                          !result['status']
                                              ? simpleDialogOption(
                                                  icon: FluentIcons
                                                      .eye_show_24_regular,
                                                  child: Text('Watch Task'),
                                                  onPressed: () async {
                                                    await Firestore().watchTask(
                                                      projectID:
                                                          content.projectID,
                                                      taskID: content.id,
                                                      userID: userID,
                                                    );

                                                    var start = DateTime.now();
                                                    var end = DateTime.parse(
                                                      content.endDateTime
                                                          .toDate()
                                                          .toString(),
                                                    );
                                                    int difference = end
                                                        .difference(start)
                                                        .inDays;

                                                    if (difference == 1) {
                                                      await scheduleNotification(
                                                        id: content.id,
                                                        endDate: content
                                                            .endDateTime
                                                            .toDate()
                                                            .toString(),
                                                        projectID:
                                                            content.projectID,
                                                        title: content.title,
                                                        description:
                                                            'Due in one day',
                                                      );

                                                      Get.back();
                                                    } else {
                                                      Get.back();

                                                      normalAlertDialog(
                                                        title: 'Oops',
                                                        description:
                                                            "Unable to schedule notification as it's less than a day. But don't worry, you can still see it in your watch list",
                                                        context: context,
                                                      );
                                                    }
                                                  },
                                                )
                                              : simpleDialogOption(
                                                  icon: FluentIcons
                                                      .eye_hide_24_regular,
                                                  child: Text('Unwatch Task'),
                                                  onPressed: () async {
                                                    await Firestore()
                                                        .unwatchTask(
                                                      id: result['id'],
                                                    );
                                                    await cancelNotification(
                                                      id: content.id,
                                                    );
                                                    Get.back();
                                                  },
                                                ),
                                          simpleDialogOption(
                                              icon: FluentIcons.edit_24_regular,
                                              child: Text('Edit Task'),
                                              onPressed: () async {
                                                Get.back();
                                                var result = await Get.to(
                                                  () => NewEditTask(
                                                    id: content.projectID,
                                                    edit: true,
                                                    taskData: content,
                                                  ),
                                                );

                                                if (result == 'reload')
                                                  startup();
                                              }),
                                          simpleDialogOption(
                                            icon: FluentIcons.delete_24_regular,
                                            child: Text('Delete Task'),
                                            onPressed: () async {
                                              await Firestore().deleteTask(
                                                id: content.id,
                                              );
                                              startup();
                                              Get.back();
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "images/arrowDown.svg",
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(height: 20),
                                    Text("You have no task in this topic yet"),
                                    Text(
                                        "Create one at the bottom right corner"),
                                  ],
                                ),
                              );
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "images/arrowDown.svg",
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 20),
                      Text("You have no topic yet"),
                      Text("Create one at the bottom right corner"),
                    ],
                  ),
                ),
    );
  }
}
