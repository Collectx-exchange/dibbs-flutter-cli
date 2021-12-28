import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String localDataSourceGeneratorTest(ObjectGenerate objectGenerate) => '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ${objectGenerate.name}LocalDataSource dataSource;

  setUp(() {
    configureInjection();
    dataSource = getIt();
  });

  test('${objectGenerate.name} local_data_source test', () async {
    
  });
}
''';

String remoteDataSourceGeneratorTest(ObjectGenerate objectGenerate) => '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ${objectGenerate.name}RemoteDataSource dataSource;

  setUp(() {
    configureInjection();
    dataSource = getIt();
  });

  test('${objectGenerate.name} remote_data_source test', () async {
    
  });
}
''';
