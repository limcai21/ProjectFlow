import 'package:ProjectFlow/model/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  final CollectionReference projectCollection =
      FirebaseFirestore.instance.collection('project');
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('topic');
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('task');

  Future<void> createProject(String title, String theme, String userID) async {
    var docRef = Firestore().projectCollection.doc();
    print("Create Project docRef:" + docRef.id);

    await projectCollection.doc(docRef.id).set({
      'title': title,
      'theme': theme,
      'userID': userID,
    });
  }

  Future<List<Project>> getAllProject(String userID) async {
    List<Project> projectList = [];
    QuerySnapshot snapshot = await projectCollection.get();

    snapshot.docs.forEach((doc) {
      Project project = Project.fromMap(doc.data());
      if (project.userID == "zWdssph3KZSjgBQRpyfMtVN7DRN2") {
        projectList.add(project);
      }
    });

    return projectList;
  }
}
