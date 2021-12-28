import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String useCaseTestGenerator(ObjectGenerate objectGenerate) {
  final nameCamelCase = ReCase(objectGenerate.name).camelCase;
  return '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ${objectGenerate.name}UseCase $nameCamelCase;

  setUp(() {
    configureInjection();
    $nameCamelCase = getIt();
  });

  test('${objectGenerate.name} usecase test', () async {
    //final result = await $nameCamelCase();
    //expect(result, match);
  });
}
''';
}
