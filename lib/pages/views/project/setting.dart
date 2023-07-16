import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:flutter/material.dart';

class ProjectSettings extends StatelessWidget {
  final String id;
  ProjectSettings({@required this.id});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      layout: 2,
      title: 'Settings',
      body: Text("Hi"),
    );
  }
}
