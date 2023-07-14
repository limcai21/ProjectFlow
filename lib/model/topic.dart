import 'package:flutter/material.dart';

class Topic {
  String id;
  String title;
  String projectID;

  Topic({this.id, @required this.title, @required this.projectID});

  Topic.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    projectID = data['projectID'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'projectID': projectID};
  }
}
