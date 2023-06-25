import 'package:get/get.dart';

class Controller extends GetxController {
  final _selectedNewProjectTheme = "Blue".obs;

  get selectedNewProjectTheme => _selectedNewProjectTheme;

  void setNewProjectTheme(String color) {
    _selectedNewProjectTheme.value = color;
  }
}
