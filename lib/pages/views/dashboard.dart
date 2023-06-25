import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_project.dart';
import 'package:ProjectFlow/pages/global/new_task.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now).toString();
    String formattedDay = DateFormat('EEEE').format(now).toString();

    return CustomScaffold(
      layout: 2,
      title: 'Dashboard',
      subtitle: "Everything you ever need is here",
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DATETIME AND ADD BTN
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDay,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyText2.fontSize,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: Icon(FluentIcons.add_24_regular),
                    label: Text("Create"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () => simpleDialog(
                      title: "Create",
                      context: context,
                      children: [
                        simpleDialogOption(
                          child: Row(
                            children: [
                              Icon(project_icon, size: 20),
                              SizedBox(width: 10),
                              Text("New Project")
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Get.to(NewProject());
                          },
                        ),
                        simpleDialogOption(
                          child: Row(
                            children: [
                              Icon(task_icon, size: 20),
                              SizedBox(width: 10),
                              Text("New Task")
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Get.to(NewTask());
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Projects",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.subtitle1.fontWeight,
                    ),
                  ),
                  SizedBox(height: 5),
                  ProjectCard(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shared Projects",
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight:
                          Theme.of(context).textTheme.subtitle1.fontWeight,
                    ),
                  ),
                  SizedBox(height: 5),
                  ProjectCard()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(width: 5),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) => Container(
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(
                  image: AssetImage("images/ls.jpg"),
                  fit: BoxFit.cover,
                  height: 125,
                  width: 225,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      "Project Title",
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
          ),
        ),
      ),
    );
  }
}
