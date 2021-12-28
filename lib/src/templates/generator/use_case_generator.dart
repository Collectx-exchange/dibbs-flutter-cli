import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String useCaseGenerator(ObjectGenerate objectGenerate) {
  return '''
import 'package:${objectGenerate.packageName}/domain/usecases/base/base_future_use_case.dart';
import 'package:injectable/injectable.dart';

@injectable
class ${objectGenerate.name}UseCase implements BaseFutureUseCase<void, void> {
  const ${objectGenerate.name}UseCase();

  @override
  Future<void> call([void params]) {
    // TODO: implement call
    throw UnimplementedError();
  }
}
''';
}
