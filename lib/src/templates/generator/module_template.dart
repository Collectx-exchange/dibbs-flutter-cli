import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String getXBindingsGenerator(ObjectGenerate obj) {
  var path = obj.pathModule?.replaceFirst('lib/', '');
  var pkg = obj.packageName;

  var import =
      pkg.isNotEmpty ? "import 'package:$pkg/${path}_controller.dart';" : '';

  return '''
import 'package:get/get.dart';
${import.replaceFirst('$pkg/$pkg', pkg)}
class ${obj.name}Binding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => ${obj.name}Controller());
  }
}
  ''';
}
