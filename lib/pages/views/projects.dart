import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/pages/global/constants.dart';
import 'package:ProjectFlow/pages/global/new_project.dart';
import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:ProjectFlow/services/auth.dart';
import 'package:ProjectFlow/services/firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Projects extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        future: Firestore().getAllProject(Auth().getCurrentUser().uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              padding: const EdgeInsets.all(20),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: List.generate(snapshot.data.length, (index) {
                return GestureDetector(
                  onTap: () => print("Tap On: " + snapshot.data[index].title),
                  child: ProjectCard(
                    title: snapshot.data[index].title,
                    theme: snapshot.data[index].theme,
                  ),
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error);
          }

          return Lottie.network(
            "https://assets5.lottiefiles.com/packages/lf20_x62chJ.json",
          );
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
