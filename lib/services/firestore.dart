import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/model/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Firestore {
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('project');
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('task');

  // PROJECT
  Future<Map> createProject({
    @required String title,
    @required String theme,
    @required String userID,
  }) async {
    try {
      var docRef = Firestore().projectCollection.doc();
      print("Create Project docRef:" + docRef.id);

      tz.initializeTimeZones();
      final singapore = tz.getLocation('Asia/Singapore');
      final now = tz.TZDateTime.now(singapore);

      await projectCollection.doc(docRef.id).set({
        'title': title,
        'theme': theme,
        'userID': userID,
        'createdDateTime': now,
      });

      return {'status': true, 'data': 'Project Created'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<List<Project>> getProjectByUserID({@required String id}) async {
    List<Project> projectList = [];
    QuerySnapshot snapshot = await projectCollection.get();

    snapshot.docs.forEach((doc) {
      Project project = Project.fromMap(doc.data());
      if (project.userID == id) {
        project.id = doc.id;
        projectList.add(project);
      }
    });

    return projectList;
  }

  Future<Project> getProjectByProjectID({@required String id}) async {
    Project output;
    QuerySnapshot snapshot = await projectCollection.get();
    snapshot.docs.forEach((doc) {
      Project project = Project.fromMap(doc.data());
      if (doc.id == id) {
        project.id = doc.id;
        output = project;
      }
    });

    return output;
  }

  // TOPIC
  Future<Map> createTopic({
    @required String title,
    @required String projectID,
  }) async {
    try {
      var docRef = Firestore().topicCollection.doc();
      print("Create Topic docRef:" + docRef.id);
      await topicCollection.doc(docRef.id).set({
        'title': title,
        'projectID': projectID,
      });
      return {'status': true, 'data': 'Topic Created'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<List<Topic>> getTopicByProjectID({@required String id}) async {
    List<Topic> topicList = [];
    QuerySnapshot snapshot = await topicCollection.get();

    snapshot.docs.forEach((doc) {
      Topic topic = Topic.fromMap(doc.data());
      if (topic.projectID == id) {
        topic.id = doc.id;
        topicList.add(topic);
      }
    });
    return topicList;
  }

  // TASK
  Future<Map> createTask({
    @required String title,
    @required String description,
    @required Timestamp startDateTime,
    @required Timestamp endDateTime,
    @required String topicID,
    @required String projectID,
  }) async {
    try {
      var docRef = Firestore().taskCollection.doc();
      print("Create Task docRef:" + docRef.id);

      await taskCollection.doc(docRef.id).set({
        'title': title,
        'description': description,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'topicID': topicID,
        'projectID': projectID,
      });

      return {'status': true, 'data': 'Task Created'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<List<Task>> getTaskByProjectID({@required String id}) async {
    List<Task> output = [];
    QuerySnapshot snapshot = await taskCollection.get();
    snapshot.docs.forEach((doc) {
      Task task = Task.fromMap(doc.data());
      if (task.projectID == id) {
        task.id = doc.id;
        output.add(task);
      }
    });

    return output;
  }

  Future<List<Task>> getTaskByTopicID({@required String id}) async {
    List<Task> output = [];
    QuerySnapshot snapshot = await taskCollection.get();
    snapshot.docs.forEach((doc) {
      Task task = Task.fromMap(doc.data());
      if (task.topicID == id) {
        task.id = doc.id;
        output.add(task);
      }
    });

    return output;
  }
}
