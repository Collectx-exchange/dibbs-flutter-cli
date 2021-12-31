import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';
import 'package:recase/recase.dart';

String useCaseTestGenerator(ObjectGenerate objectGenerate) {
  final nameCamelCase = ReCase(objectGenerate.name).camelCase;
  return '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/core/data/enum/status.dart';
import 'package:${objectGenerate.packageName}/core/data/model/app_exception.dart';
import 'package:${objectGenerate.packageName}/core/data/model/resource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  late ${objectGenerate.name}UseCase $nameCamelCase;

  setUp(() {
    $nameCamelCase = ${objectGenerate.name}UseCase(dynamic);
  });

  test('${objectGenerate.name} usecase test', () async {
    //arrange
    final dynamic match;
    //act
    final result = await $nameCamelCase();
    //assert
    expect(result, match);
  });
}
''';
}
