import 'dart:io';
import 'package:ProjectFlow/model/project.dart';
import 'package:ProjectFlow/model/topic.dart';
import 'package:ProjectFlow/model/task.dart';
import 'package:ProjectFlow/model/watch.dart';
import 'package:ProjectFlow/pages/global/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class Firestore {
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('project');
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('task');
  final CollectionReference watchesCollection =
      FirebaseFirestore.instance.collection('watches');

  Future<Map> deleteAllDataFromUser({@required String id}) async {
    QuerySnapshot projectSnapshot = await projectCollection.get();
    projectSnapshot.docs.forEach((doc) async {
      Project project = Project.fromMap(doc.data());
      if (project.userID == id) {
        await deleteProject(id: doc.id);
      }
    });

    return {
      "status": true,
      "data": "Project, Topics & Task deleted successfully"
    };
  }

  // PROJECT
  Future<Map> createProject({
    @required String title,
    @required String theme,
    @required String backgroundURL,
    @required String imageID,
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
        'backgroundURL': backgroundURL,
        'userID': userID,
        'imageID': imageID,
        'createdDateTime': now,
      });

      return {'status': true, 'data': 'Project Created'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Project> getProject({@required String id}) async {
    Project output;
    QuerySnapshot snapshot = await projectCollection.get();

    for (var doc in snapshot.docs) {
      Project project = Project.fromMap(doc.data());
      if (doc.id == id) {
        project.id = doc.id;
        output = project;
        break;
      }
    }

    return output;
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

  Future<Map> updateProject({
    @required String id,
    @required String title,
    @required String theme,
    @required String backgroundURL,
    @required String imageID,
  }) async {
    try {
      await projectCollection.doc(id).update({
        'title': title,
        'theme': theme,
        'backgroundURL': backgroundURL,
        'imageID': imageID,
      });
      return {'status': true, 'data': 'Project Updated'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Map> deleteProject({@required String id}) async {
    try {
      DocumentSnapshot pi = await projectCollection.doc(id).get();
      Project data = Project.fromMap(pi.data());
      await deleteImage(id: data.imageID);
      await projectCollection.doc(id).delete();

      QuerySnapshot topicSnapshot = await topicCollection.get();
      topicSnapshot.docs.forEach((doc) async {
        Topic topic = Topic.fromMap(doc.data());
        if (topic.projectID == id) await topicCollection.doc(doc.id).delete();
      });

      QuerySnapshot taskSnapshot = await taskCollection.get();
      taskSnapshot.docs.forEach((doc) async {
        Task task = Task.fromMap(doc.data());
        if (task.projectID == id) await taskCollection.doc(doc.id).delete();
      });

      QuerySnapshot watchSnapshot = await watchesCollection.get();
      watchSnapshot.docs.forEach((doc) async {
        WatchModel watch = WatchModel.fromMap(doc.data());
        if (watch.projectID == id) {
          await watchesCollection.doc(doc.id).delete();
          await cancelNotification(id: watch.uuidNum);
        }
      });

      print("Project Deleted");
      return {'status': true, 'data': 'Project Deleted'};
    } catch (e) {
      print(e);
      return {'status': true, 'data': e};
    }
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

  Future<Map> updateTopic({
    @required String id,
    @required String title,
  }) async {
    try {
      await topicCollection.doc(id).update({'title': title});
      return {'status': true, 'data': 'Topic Updated'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Map> deleteTopic({@required String id}) async {
    try {
      await topicCollection.doc(id).delete();

      QuerySnapshot taskSnapshot = await taskCollection.get();
      taskSnapshot.docs.forEach((doc) async {
        Task task = Task.fromMap(doc.data());
        if (task.topicID == id) await taskCollection.doc(doc.id).delete();
      });

      return {'status': true, 'data': 'Topic Deleted'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  // TASK
  Future<Map> createTask({
    @required String title,
    @required String description,
    @required Timestamp startDateTime,
    @required Timestamp endDateTime,
    @required String topicID,
    @required String projectID,
    @required String userID,
    @required String uuid,
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
        'userID': userID,
        'uuidNum': uuid,
        'status': 'Created',
      });

      return {'status': true, 'data': 'Task Created'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<List<Task>> getTaskByUserID({@required String id}) async {
    List<Task> output = [];
    QuerySnapshot snapshot = await taskCollection.get();
    snapshot.docs.forEach((doc) {
      Task task = Task.fromMap(doc.data());
      if (task.userID == id) {
        task.id = doc.id;
        output.add(task);
      }
    });

    return output;
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

  Future<Task> getTask({@required String id}) async {
    Task output;
    QuerySnapshot snapshot = await taskCollection.get();

    for (var doc in snapshot.docs) {
      Task task = Task.fromMap(doc.data());
      if (doc.id == id) {
        task.id = doc.id;
        output = task;
        break;
      }
    }

    return output;
  }

  Future<Map> updateTask({
    @required String id,
    @required String title,
    @required String description,
    @required Timestamp startDateTime,
    @required Timestamp endDateTime,
    @required String topicID,
  }) async {
    try {
      await taskCollection.doc(id).update({
        'title': title,
        'description': description,
        'startDateTime': startDateTime,
        'endDateTime': endDateTime,
        'topicID': topicID,
      });
      return {'status': true, 'data': 'Task Updated'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Map> updateTaskStatus({
    @required String id,
    @required String status,
  }) async {
    try {
      await taskCollection.doc(id).update({'status': status});
      return {'status': true, 'data': 'Task Status Updated'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Map> deleteTask({@required String id}) async {
    try {
      await taskCollection.doc(id).delete();
      return {'status': true, 'data': 'Task Deleted'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  // WATCHES
  Future<List<WatchModel>> getWatchesByUserID({@required String id}) async {
    List<WatchModel> watchList = [];
    QuerySnapshot snapshot = await watchesCollection.get();

    for (var doc in snapshot.docs) {
      WatchModel watch = WatchModel.fromMap(doc.data());
      if (watch.userID == id) {
        watch.id = doc.id;
        watch.task = await getTask(id: watch.taskID);
        watch.project = await getProject(id: watch.projectID);
        watchList.add(watch);
      }
    }

    return watchList;
  }

  Future<Map> getWatchesByTaskID({@required String id}) async {
    Map output = {'status': false};
    QuerySnapshot snapshot = await watchesCollection.get();

    snapshot.docs.forEach((doc) {
      WatchModel watch = WatchModel.fromMap(doc.data());
      if (watch.taskID == id) {
        output = {'status': true, 'id': doc.id, 'min': watch.min};
      }
    });
    return output;
  }

  Future<Map> watchTask({
    @required String projectID,
    @required String taskID,
    @required String userID,
    @required int minute,
    @required String uuidNum,
  }) async {
    try {
      var docRef = Firestore().watchesCollection.doc();
      print("Create Watch docRef:" + docRef.id);

      await watchesCollection.doc(docRef.id).set(
        {
          'taskID': taskID,
          'userID': userID,
          'projectID': projectID,
          'min': minute,
          'uuidNum': uuidNum,
        },
      );

      return {'status': true, 'data': 'Added to watch list'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  Future<Map> unwatchTask({@required String id}) async {
    try {
      await watchesCollection.doc(id).delete();
      return {'status': true, 'data': 'Remove from watch list!'};
    } catch (e) {
      print(e.message);
      return {'status': true, 'data': e.message};
    }
  }

  // UPLOAD IMAGE
  Future<Map> uploadImage({@required String path}) async {
    try {
      if (path == null) {
        return {"status": false, "msg": "No Image"};
      }

      final fileName = Uuid().v4();
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(File(path));
      String downloadURL = await ref.getDownloadURL();
      return {
        "status": true,
        'msg': 'Image Uploaded',
        "url": downloadURL,
        "imageID": fileName
      };
    } catch (e) {
      // Handle any errors that occur during the image upload process.
      print('Error uploading image: $e');
      return {"status": false, "msg": e.message};
    }
  }

  Future<Map> deleteImage({@required String id}) async {
    bool isUrl(String urlString) {
      Uri uri = Uri.tryParse(urlString);
      return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    }

    try {
      if (isUrl(id)) {
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref();
        firebase_storage.ListResult data = await ref.listAll();
        List<firebase_storage.Reference> allImg = data.items;

        for (var img in allImg) {
          if (await img.getDownloadURL() == id) {
            firebase_storage.FullMetadata temp = await img.getMetadata();
            id = temp.name;
            break;
          }
        }
      }

      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref(id);
      await ref.delete();
      print("Image deleted based on ID");
      return {"status": true, "msg": "Image deleted"};
    } catch (e) {
      print('Error deleting image: $e');
      return {"status": false, "msg": e.message};
    }
  }
}
