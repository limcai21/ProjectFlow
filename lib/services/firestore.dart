import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

      await projectCollection.doc(docRef.id).set({
        'title': title,
        'theme': theme,
        'userID': userID,
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
}
