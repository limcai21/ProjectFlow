import 'package:ProjectFlow/model/watch.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/project/project.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  WatchModel data = snapshot.data[index];

                  return Dismissible(
                    key: Key(data.id),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await Firestore().unwatchTask(id: data.id);
                        startup();
                      }

                      return false;
                    },
                    secondaryBackground: Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            FluentIcons.eye_hide_20_filled,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Unwatch",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    background: Container(color: Colors.transparent),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 5,
                        top: 10,
                      ),
                      onLongPress: () {
                        return simpleDialog(
                          title: 'Quck Actions',
                          context: context,
                          children: [
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
                        );
                      },
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
                      trailing: Container(
                        width: 5,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(getHexValue(data.project.theme)),
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.project.title.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(data.task.title),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                FluentIcons.clock_24_regular,
                                size: 12,
                              ),
                              SizedBox(width: 5),
                              Text(
                                DateFormat(dateFormat)
                                    .format(data.task.endDateTime.toDate())
                                    .toString(),
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
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
