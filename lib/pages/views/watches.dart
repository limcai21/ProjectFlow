import 'package:ProjectFlow/model/watch.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/notification.dart';
import 'package:ProjectFlow/pages/views/project/project.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Watches extends StatefulWidget {
  @override
  State<Watches> createState() => _WatchesState();
}

class _WatchesState extends State<Watches> {
  Future<List<WatchModel>> watchesFuture;

  Future<List<WatchModel>> fetchWatches() async {
    final watches =
        await Firestore().getWatchesByUserID(id: Auth().getCurrentUser().uid);
    return watches;
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  startup() async {
    var temp = fetchWatches();
    setState(() {
      watchesFuture = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WatchModel>>(
      future: watchesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                WatchModel data = snapshot.data[index];

                return CustomCard(
                  topTitle: data.project.title,
                  title: data.task.title,
                  description: "Due on " +
                      DateFormat(dateFormat)
                          .format(data.task.endDateTime.toDate()),
                  pc: Theme.of(context).primaryColor,
                  rightSide: data.task.status != 'Created'
                      ? Chip(
                          backgroundColor: getTaskColor(data.task.status),
                          padding: const EdgeInsets.all(3),
                          label: Icon(
                            getTaskIcon(data.task.status),
                            color: Colors.white,
                            size: 16,
                          ),
                        )
                      : null,
                  onTap: () async {
                    await Get.to(
                      () => NewEditTask(
                        id: data.projectID,
                        edit: true,
                        taskData: data.task,
                      ),
                    );
                    startup();
                  },
                  onLongPress: () => simpleDialog(
                    title: 'Quick Actions',
                    context: context,
                    children: [
                      simpleDialogOption(
                        child: Text("Unwatch Task"),
                        icon: FluentIcons.eye_hide_24_regular,
                        onPressed: () async {
                          await cancelNotification(id: data.task.uuidNum);
                          await Firestore().unwatchTask(id: data.id);
                          Get.back();
                          startup();
                        },
                      ),
                      simpleDialogOption(
                        child: Text("To Project"),
                        icon: project_icon,
                        onPressed: () async {
                          Get.back();
                          await Get.to(
                            () => ProjectPage(id: data.projectID),
                          );
                          startup();
                        },
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return DoodleOutput(
              svgPath: "images/camera.svg",
              title: 'You have no watch task yet',
              subtitle: 'Go to your project and watch one of your task',
            );
          }
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return Loading();
      },
    );
  }
}
