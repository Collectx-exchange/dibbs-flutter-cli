import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String getXBindingsGenerator(ObjectGenerate obj) {
  return '''
import 'package:get/get.dart';
import '../${ReCase(obj.name).snakeCase}_controller.dart';

class ${obj.name}Bindings extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ${obj.name}Controller());
  }
}
  ''';
}
