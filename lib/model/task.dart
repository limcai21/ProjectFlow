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
  String userID;
  Task({
    this.id,
    @required this.title,
    @required this.startDateTime,
    @required this.endDateTime,
    @required this.topicID,
    @required this.projectID,
    @required this.userID,
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
    userID = data['userID'];
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
      'userID': userID,
    };
  }
}
