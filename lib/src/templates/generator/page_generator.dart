import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String statelessPageGenerator(ObjectGenerate obj) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ${obj.name}Page extends StatelessWidget {

  static Future? get navigateTo => Get.toNamed('');

  const ${obj.name}Page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
  
}
  ''';

String pageGeneratorGetX(ObjectGenerate obj) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '${ReCase(obj.name).snakeCase}_controller.dart';

class ${obj.name}Page extends GetView<${obj.name}Controller> {

  static Future? get navigateTo => Get.toNamed('');

  const ${obj.name}Page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
}
  ''';

String pageGeneratorGetXWithArguments(ObjectGenerate obj) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'arguments/${ReCase(obj.name).snakeCase}_arguments.dart';
import '${ReCase(obj.name).snakeCase}_controller.dart';

class ${obj.name}Page extends GetView<${obj.name}Controller> {

  static Future? navigateWith({required ${obj.name}Arguments arguments}) => 
    Get.toNamed('', arguments: arguments);

  const ${obj.name}Page({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();
}
  ''';
