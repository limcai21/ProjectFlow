import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String id;
  String title;
  String description;
  String topicID;
  String projectID;
  Timestamp startDateTime;
  Timestamp endDateTime;
  Task({
    this.id,
    @required this.title,
    @required this.startDateTime,
    @required this.endDateTime,
    @required this.topicID,
    @required this.projectID,
    this.description,
  });

  Task.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    topicID = data['topicID'];
    projectID = data['projectID'];
    startDateTime = data['startDateTime'];
    endDateTime = data['endDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'topicID': topicID,
      'projectID': projectID,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
    };
  }
}
