import 'package:flutter/material.dart';

class Project {
  String title;
  String theme;
  String userID;

  Project({@required this.title, @required this.theme, @required this.userID});

  Project.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    theme = data['theme'];
    userID = data['userID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'theme': theme,
      'userID': userID,
    };
  }
}
