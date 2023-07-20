import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_project.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/new_edit_topic.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/project/project.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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
    var primaryColor = Theme.of(context).primaryColor;

    return CustomScaffold(
      layout: 2,
      title: 'Projects',
      subtitle: "Manage your project",
      actionBtn: [
        IconButton(
          onPressed: () async {
            final result = await Get.to(() => NewEditProject(edit: false));
            if (result == 'reload') {
              setState(() {
                projectFuture = fetchProjects();
              });
            }
          },
          icon: Icon(FluentIcons.add_24_filled),
        )
      ],
      body: FutureBuilder<List<Project>>(
        future: projectFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return GridView.count(
                padding: const EdgeInsets.all(20),
                physics: BouncingScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5 / 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(snapshot.data.length, (index) {
                  return GestureDetector(
                    onTap: () async {
                      await Get.to(
                          () => ProjectPage(id: snapshot.data[index].id));
                      startup();
                    },
                    onLongPress: () => {
                      simpleDialog(
                        title: 'Quick Actions',
                        context: context,
                        children: [
                          simpleDialogOption(
                            onPressed: () => Get.to(
                              () => NewEditTask(
                                id: snapshot.data[index].id,
                                edit: false,
                              ),
                            ),
                            icon: task_icon,
                            child: Text('Add Task'),
                          ),
                          simpleDialogOption(
                            onPressed: () => Get.to(
                              () => NewEditTopic(
                                id: snapshot.data[index].id,
                                edit: false,
                              ),
                            ),
                            icon: topic_icon,
                            child: Text('Add Topic'),
                          ),
                          simpleDialogOption(
                            onPressed: () => print("Delete Project"),
                            icon: FluentIcons.delete_24_regular,
                            child: Text('Delete Project'),
                          ),
                        ],
                      )
                    },
                    child: ProjectCard(
                      title: snapshot.data[index].title,
                      theme: snapshot.data[index].theme,
                    ),
                  );
                }),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("images/arrowUp.svg", color: primaryColor),
                    SizedBox(height: 20),
                    Text("You have no project yet"),
                    Text("Create one at the top right corner"),
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

class ProjectCard extends StatelessWidget {
  final String title;
  final String theme;
  ProjectCard({@required this.title, @required this.theme});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(color: Color(getHexValue(theme))),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
