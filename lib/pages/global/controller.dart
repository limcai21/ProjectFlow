import 'package:get/get.dart';

class Controller extends GetxController {
  final _refreshHomePage = false.obs;
  get refreshHomePage => _refreshHomePage;

  void setRefreshHomePage(bool v) {
    _refreshHomePage.value = v;
  }
}
