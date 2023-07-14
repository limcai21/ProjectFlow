import 'package:flutter/material.dart';

class Project {
  String id;
  String title;
  String theme;
  String userID;

  Project({
    this.id,
    @required this.title,
    @required this.theme,
    @required this.userID,
  });

  Project.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    theme = data['theme'];
    userID = data['userID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'theme': theme,
      'userID': userID,
    };
  }
}
