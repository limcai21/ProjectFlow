import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_project.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/pages/views/skeleton.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectSettings extends StatefulWidget {
  final String id;
  ProjectSettings({@required this.id});

  @override
  State<ProjectSettings> createState() => _ProjectSettingsState();
}

class _ProjectSettingsState extends State<ProjectSettings> {
  bool loading = true;
  Project projectDetails;
  List<Topic> projectTopics = [];
  List<Task> projectTask = [];
  List<Task> outputProjectTask = [];

  startup() async {
    Project pTemp = await Firestore().getProjectByProjectID(id: widget.id);
    List<Topic> tTemp = await Firestore().getTopicByProjectID(id: widget.id);
    List<Task> taskTemp = await Firestore().getTaskByProjectID(id: widget.id);

    setState(() {
      projectDetails = pTemp;
      projectTopics = tTemp;
      projectTask = taskTemp;
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
    const t = 1.0;
    const br = 8.0;

    return CustomScaffold(
      layout: 2,
      title: 'Settings',
      subtitle: 'Make some tweaks and turn here',
      body: loading
          ? Loading()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    physics: BouncingScrollPhysics(),
                    children: [
                      ListViewHeader(title: 'General'),
                      CustomListTile(
                        title: "Project",
                        subtitle: 'Change title & theme',
                        t: t,
                        icon: project_icon,
                        trailingIcon: FluentIcons.chevron_right_24_regular,
                        borderRadius: br,
                        iconColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor,
                        onTap: () async {
                          var result = await Get.to(
                            () => NewEditProject(
                              id: projectDetails.id,
                              edit: true,
                              projectData: projectDetails,
                            ),
                          );
                          if (result == "reload") startup();
                        },
                      ),
                      CustomListTile(
                        title: "Topics",
                        subtitle: '${projectTopics.length} topics',
                        t: t,
                        icon: topic_icon,
                        trailingIcon: FluentIcons.chevron_right_24_regular,
                        borderRadius: br,
                        iconColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor,
                        onTap: () => Get.back(result: 'reload'),
                      ),
                      CustomListTile(
                        title: "Task",
                        subtitle: '${projectTask.length} tasks',
                        t: t,
                        icon: task_icon,
                        trailingIcon: FluentIcons.chevron_right_24_regular,
                        borderRadius: br,
                        iconColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor,
                        onTap: () => Get.back(result: 'reload'),
                      ),
                      ListViewHeader(title: 'Danger Zone'),
                      CustomListTile(
                        title: "Delete",
                        subtitle: "Are you sure you want to delete?",
                        t: t,
                        icon: FluentIcons.delete_24_regular,
                        trailingIcon: FluentIcons.chevron_right_24_regular,
                        borderRadius: br,
                        iconColor: Colors.white,
                        bgColor: Theme.of(context).primaryColor,
                        onTap: () async {
                          var result = await Firestore()
                              .deleteProject(id: projectDetails.id);
                          await normalAlertDialog(
                            title: result['status'] ? 'Done' : 'Error',
                            description: result['data'],
                            context: context,
                            goBackTwice: result['status'] ? true : false,
                          );
                          Get.offAll(() => MainSkeleton());
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
