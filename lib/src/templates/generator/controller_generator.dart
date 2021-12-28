import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String getXControllerGenerator(ObjectGenerate obj) => '''
import 'package:get/get.dart';

class _${obj.name}Controller extends GetxController {
  //region Private
  //endregion

  //region Public
  //endregion

  //region Functions
  //endregion
}
  ''';
