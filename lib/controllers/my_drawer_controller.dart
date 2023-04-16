import 'package:get/get.dart';

class MyDrawerController extends GetxController {
  String selectedTabId = 'TASKS';

  void selectTab(String tabId) {
    selectedTabId = tabId;
    update();
  }
}
