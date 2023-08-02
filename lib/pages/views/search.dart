import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_edit_task.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Task> taskList;
  bool loading = true;

  startup() async {
    List<Task> temp =
        await Firestore().getTaskByUserID(id: Auth().getCurrentUser().uid);
    setState(() {
      taskList = temp;
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
    return CustomScaffold(
      layout: 2,
      title: "Search",
      subtitle: "All your task is here",
      actionBtn: [
        IconButton(
          icon: Icon(FluentIcons.search_24_regular),
          onPressed: () async {
            await showSearch(
              context: context,
              delegate: TaskSearch(data: taskList),
            );
            startup();
          },
        ),
      ],
      body: loading
          ? Loading()
          : taskList.length > 0
              ? Hero(
                  tag: 'lv',
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    physics: BouncingScrollPhysics(),
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return CustomCard(
                        topTitle: taskList[index].status,
                        title: taskList[index].title,
                        description: taskList[index].description,
                        pc: Theme.of(context).primaryColor,
                        onTap: () async {
                          await Get.to(
                            () => NewEditTask(
                              edit: true,
                              id: taskList[index].projectID,
                              taskData: taskList[index],
                            ),
                          );
                          startup();
                        },
                        onLongPress: () {},
                      );
                    },
                  ),
                )
              : DoodleOutput(
                  svgPath: "images/arrowDownLeft.svg",
                  title: "You have not create a task yet",
                  subtitle: "Add or create project in the project tab",
                ),
    );
  }
}

class TaskSearch extends SearchDelegate<String> {
  final List<Task> data;
  TaskSearch({@required this.data});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(FluentIcons.dismiss_24_filled, size: 22),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  List<Task> search() {
    List<Task> temp = [];
    data.forEach((t) {
      if (t.title.toUpperCase().contains(query.toUpperCase())) {
        temp.add(t);
      }
    });

    return temp;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var searchData = search();
    if (searchData.length > 0) {
      return Hero(
        tag: "lv",
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          itemCount: search().length,
          itemBuilder: (context, index) {
            return CustomCard(
              topTitle: searchData[index].status,
              title: searchData[index].title,
              description: searchData[index].description,
              pc: Theme.of(context).primaryColor,
              onTap: () {
                close(context, null);
                Get.to(
                  () => NewEditTask(
                    edit: true,
                    id: searchData[index].projectID,
                    taskData: searchData[index],
                  ),
                );
              },
              onLongPress: () {},
            );
          },
        ),
      );
    } else {
      return DoodleOutput(
        svgPath: 'images/emptyNote.svg',
        title: 'No result found',
        subtitle: 'Maybe try searching something else?',
      );
    }
  }
}
