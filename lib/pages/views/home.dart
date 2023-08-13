import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_project.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/new_edit_topic.dart';
import 'package:ProjectFlow/pages/views/project/project.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Projects extends StatefulWidget {
  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Future<List<Project>> projectFuture;

  Future<List<Project>> fetchProjects() async {
    final projects =
        await Firestore().getProjectByUserID(id: Auth().getCurrentUser().uid);
    // final projects = await Firestore().getProjectByUserID(
    //   id: 'Ba01ymc1JsdGifUlRGF1GvM20VW2',
    // );
    return projects;
  }

  startup() async {
    var temp = fetchProjects();
    setState(() {
      projectFuture = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    startup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(FluentIcons.add_24_filled),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          final result = await Get.to(() => NewEditProject(edit: false));
          if (result == 'reload') {
            setState(() {
              projectFuture = fetchProjects();
            });
          }
        },
      ),
      body: FutureBuilder<List<Project>>(
        future: projectFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.count(
                padding: const EdgeInsets.all(20),
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.8 / 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(snapshot.data.length, (index) {
                  return GestureDetector(
                    onTap: () async {
                      await Get.to(
                        () => ProjectPage(id: snapshot.data[index].id),
                      );
                      startup();
                    },
                    onLongPress: () => {
                      simpleDialog(
                        title: 'Quick Actions',
                        context: context,
                        children: [
                          simpleDialogOption(
                            onPressed: () {
                              Get.back();
                              Get.to(
                                () => NewEditTask(
                                  id: snapshot.data[index].id,
                                  edit: false,
                                ),
                              );
                            },
                            icon: task_icon,
                            child: Text('Add Task'),
                          ),
                          simpleDialogOption(
                            onPressed: () {
                              Get.back();
                              Get.to(
                                () => NewEditTopic(
                                  id: snapshot.data[index].id,
                                  edit: false,
                                ),
                              );
                            },
                            icon: topic_icon,
                            child: Text('Add Topic'),
                          ),
                          simpleDialogOption(
                            icon: FluentIcons.delete_24_regular,
                            child: Text('Delete Project'),
                            onPressed: () async {
                              Get.back();
                              normalAlertDialog(
                                title: deleteProjectTitle,
                                description: deleteProjectSubtitle,
                                context: context,
                                closeTitle: 'DELETE',
                                additionalActions: TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    "CLOSE",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                      Color.lerp(
                                        Theme.of(context).primaryColor,
                                        Colors.white,
                                        0.9,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  Get.back();
                                  loadingCircle(context: context);
                                  var result = await Firestore().deleteProject(
                                    id: snapshot.data[index].id,
                                  );
                                  Get.back();
                                  await normalAlertDialog(
                                    title: result['status']
                                        ? 'Done'
                                        : alertErrorTitle,
                                    description: result['data'],
                                    context: context,
                                    goBackTwice:
                                        result['status'] ? true : false,
                                  );
                                  startup();
                                },
                              );
                            },
                          ),
                        ],
                      )
                    },
                    child: ProjectCard(data: snapshot.data[index]),
                  );
                }),
              );
            } else {
              return DoodleOutput(
                svgPath: "images/arrowUp.svg",
                title: 'You have no project yet',
                subtitle: 'Create one at the top right corner',
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

class ProjectCard extends StatelessWidget {
  final Project data;
  ProjectCard({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(
            tag: data.backgroundURL,
            child: Container(
              decoration: BoxDecoration(
                color: Color(getHexValue(data.theme)),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(data.backgroundURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.2),
                Colors.black.withOpacity(0.7),
                Colors.black,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                DateFormat(dateFormat).format(data.createdDateTime.toDate()),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
