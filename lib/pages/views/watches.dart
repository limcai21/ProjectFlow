import 'package:ProjectFlow/pages/global/scaffold.dart';
import 'package:flutter/material.dart';

class Watches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Watches',
      subtitle: 'View all your watch task here',
      body: Padding(padding: const EdgeInsets.all(20), child: Text("All")),
      layout: 2,
    );
  }
}
