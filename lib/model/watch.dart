import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/task.dart';
import 'package:flutter/material.dart';

class WatchModel {
  String id;
  String projectID;
  String taskID;
  String userID;
  int min;
  Task task;
  Project project;
  String uuidNum;
  WatchModel({
    this.id,
    @required this.taskID,
    @required this.userID,
    @required this.uuidNum,
    this.task,
    this.project,
  });

  WatchModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    taskID = data['taskID'];
    userID = data['userID'];
    projectID = data['projectID'];
    task = data['task'];
    project = data['project'];
    min = data['min'];
    uuidNum = data['uuidNum'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectID': projectID,
      'taskID': taskID,
      'userID': userID,
      'task': task,
      'project': project,
      'min': min,
      'uuidNum': uuidNum,
    };
  }
}
