import 'package:get/get.dart';
import '../my_page_controller.dart';

class MyPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyPageController());
  }
}
