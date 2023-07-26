import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project {
  String id;
  String title;
  String theme;
  String userID;
  String backgroundURL;
  String imageID;
  Timestamp createdDateTime;
  Project({
    this.id,
    @required this.title,
    @required this.theme,
    @required this.backgroundURL,
    @required this.imageID,
    @required this.userID,
    @required this.createdDateTime,
  });

  Project.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    theme = data['theme'];
    backgroundURL = data['backgroundURL'];
    imageID = data['imageID'];
    userID = data['userID'];
    createdDateTime = data['createdDateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'theme': theme,
      'backgroundURL': backgroundURL,
      'imageID': imageID,
      'userID': userID,
      'createdDateTime': createdDateTime,
    };
  }
}
