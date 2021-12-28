import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String adapterGenerator(ObjectGenerate obj) => '''

import '../view_model/${ReCase(obj.name).snakeCase}_view_model.dart';

abstract class ${obj.name}Adapter {

  ${obj.name}Adapter._();
  
  static ${obj.name}ViewModel fromEntity(dynamic entity) => 
    ${obj.name}ViewModel(param: '');

}

''';
