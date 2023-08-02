import 'package:ProjectFlow/model/watch.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/notification.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/project/project.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
    return CustomScaffold(
      title: 'Watches',
      subtitle: 'View all your watch task here',
      layout: 2,
      body: FutureBuilder<List<WatchModel>>(
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
                    description: data.task.description,
                    pc: Theme.of(context).primaryColor,
                    rightSide: Container(
                      width: 5,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(getHexValue(data.project.theme)),
                      ),
                    ),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "images/camera.svg",
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 20),
                    Text("You have no watch task yet"),
                    Text("Go to your project and watch one of your task"),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          return Loading();
        },
      ),
    );
  }
}
