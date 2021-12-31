import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String useCaseGenerator(ObjectGenerate objectGenerate) {
  return '''
import 'package:${objectGenerate.packageName}/core/data/model/resource.dart';

import '../base/base_use_case.dart';

class ${objectGenerate.name}UseCase implements BaseFutureResourceUseCase<dynamic, dynamic> {
  
  final dynamic _repository;
  
  const ${objectGenerate.name}UseCase(this._repository);

  @override
  Future<dynamic> call(dynamic params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
''';
}

String useCaseWithParamsGenerator(ObjectGenerate objectGenerate) {
  return '''
import 'package:${objectGenerate.packageName}/core/data/model/resource.dart';

import '../base/base_use_case.dart';

class ${objectGenerate.name}Params {
  
  final dynamic param;
  
  const ${objectGenerate.name}Params({required this.param});
  
  ${objectGenerate.name}Params copyWith({dynamic? param}) {
    return ${objectGenerate.name}Params(
      param: param?? this.param
    );
  }

}

class ${objectGenerate.name}UseCase implements BaseFutureResourceUseCase<${objectGenerate.name}Params, dynamic> {
  
  final dynamic _repository;
  
  const ${objectGenerate.name}UseCase(this._repository);

  @override
  Future<dynamic> call(${objectGenerate.name}Params params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
''';
}
