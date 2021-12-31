import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'arguments/my_page_arguments.dart';
import 'my_page_controller.dart';

class MyPagePage extends GetView<MyPageController> {
  static Future? navigateWith({required MyPageArguments arguments}) =>
      Get.toNamed('', arguments: arguments);

  const MyPagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
}
