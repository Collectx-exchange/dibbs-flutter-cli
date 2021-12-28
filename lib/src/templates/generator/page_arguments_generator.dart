import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String pageArgumentsGenerator(ObjectGenerate obj) => '''

class ${obj.name}Arguments {

  final String param;
  
  const ${obj.name}Arguments({required this.param});
  
  ${obj.name}Arguments copyWith({
    String? param
  }) => ${obj.name}Arguments(
    param: param?? this.param
    );

}

''';