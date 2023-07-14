import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_task.dart';
import 'package:ProjectFlow/pages/global/new_topic.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

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
  List<Topic> projectTopics;

  startup() async {
    Project pTemp = await Firestore().getProjectByProjectID(id: widget.id);
    List<Topic> tTemp = await Firestore().getTopicByProjectID(id: widget.id);

    setState(() {
      projectDetails = pTemp;
      projectTopics = tTemp;
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
      title: loading ? 'Title' : projectDetails.title,
      subtitle: '14 Task',
      tab: true,
      actionBtn: [
        if (!loading)
          IconButton(
            icon: Icon(
              FluentIcons.settings_24_regular,
              color: Colors.white,
            ),
            onPressed: null,
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
                SpeedDialChild(
                  label: 'Task',
                  labelStyle: TextStyle(color: Colors.white),
                  child: Icon(task_icon),
                  onTap: () => Get.to(() => NewTask(id: widget.id)),
                ),
                SpeedDialChild(
                  label: 'Topic',
                  labelStyle: TextStyle(color: Colors.white),
                  child: Icon(topic_icon),
                  onTap: () => Get.to(() => NewTopic(id: widget.id)),
                )
              ],
            ),
      body: loading
          ? Loading()
          : DefaultTabController(
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
                      onTap: (i) => tabIndex = i,
                      tabs: List.generate(
                        projectTopics.length,
                        (i) => Tab(text: projectTopics[i].title),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: BouncingScrollPhysics(),
                      children: List.generate(
                        projectTopics.length,
                        (i) => Text(projectTopics[i].title + " Content"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
