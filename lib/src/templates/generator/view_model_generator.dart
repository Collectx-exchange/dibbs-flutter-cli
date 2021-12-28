import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String viewModelGenerator(ObjectGenerate obj) => '''

class ${obj.name}ViewModel {

  final String param;
  
  const ${obj.name}ViewModel({required this.param});
  
  ${obj.name}ViewModel copyWith({
    String? param
  }) => ${obj.name}ViewModel(
    param: param?? this.param
    );

}

''';
