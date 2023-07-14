import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_project.dart';
import 'package:ProjectFlow/pages/global/new_task.dart';
import 'package:ProjectFlow/pages/global/new_topic.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/project.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return CustomScaffold(
      layout: 2,
      title: 'Projects',
      subtitle: "Manage your project",
      actionBtn: [
        IconButton(
          onPressed: () => Get.to(() => NewProject()),
          icon: Icon(FluentIcons.add_24_filled),
        )
      ],
      body: FutureBuilder<List<Project>>(
        // future: Firestore().getAllProject(Auth().getCurrentUser().uid),
        future: Firestore().getProjectByUserID(
          id: 'Ba01ymc1JsdGifUlRGF1GvM20VW2',
        ),
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
                    onTap: () => Get.to(
                      () => ProjectPage(id: snapshot.data[index].id),
                    ),
                    onLongPress: () => {
                      simpleDialog(
                        title: 'Quick Actions',
                        context: context,
                        children: [
                          simpleDialogOption(
                            onPressed: () => Get.to(
                              () => NewTask(id: snapshot.data[index].id),
                            ),
                            child: Row(
                              children: [
                                Icon(task_icon, size: 18),
                                SizedBox(width: 10),
                                Text('Add Task'),
                              ],
                            ),
                          ),
                          simpleDialogOption(
                            onPressed: () => Get.to(
                              () => NewTopic(id: snapshot.data[index].id),
                            ),
                            child: Row(
                              children: [
                                Icon(topic_icon, size: 18),
                                SizedBox(width: 10),
                                Text('Add Topic'),
                              ],
                            ),
                          ),
                          simpleDialogOption(
                            onPressed: () => print("Delete Project"),
                            child: Row(
                              children: [
                                Icon(FluentIcons.delete_24_regular, size: 18),
                                SizedBox(width: 10),
                                Text('Delete Project'),
                              ],
                            ),
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
