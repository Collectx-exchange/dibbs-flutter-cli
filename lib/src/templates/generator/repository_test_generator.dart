import 'package:dibbs_flutter_cli/src/utils/object_generate.dart';

String repositoryTestGenerator(ObjectGenerate obj) => '''
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import 'package:${obj.packageName}/${obj.import?.replaceFirst("lib/", "").replaceAll("\\", "/")}';

class MockClient extends Mock implements Dio {}

void main() {
  ${obj.name}Repository repository;
 // MockClient client;

  setUp(() {
  // repository = ${obj.name}Repository();
  // client = MockClient();
  });

  group('${obj.name}Repository Test', () {
 //  test("First Test", () {
 //    expect(repository, isInstanceOf<${obj.name}Repository>());
 //  });

   test('returns a Post if the http call completes successfully', () async {
 //    when(client.get('https://jsonplaceholder.typicode.com/posts/1'))
 //        .thenAnswer((_) async =>
 //            Response(data: {'title': 'Test'}, statusCode: 200));
 //    Map<String, dynamic> data = await repository.fetchPost(client);
 //    expect(data['title'], 'Test');
   });

  });
}
  ''';

String repositoryImplTestGeneratorClean(ObjectGenerate objectGenerate) {
  return '''
import 'package:${objectGenerate.packageName}/${objectGenerate.import?.replaceAll("lib/", "")}';
import 'package:${objectGenerate.packageName}/di/di.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ${objectGenerate.name}RepositoryImpl repo;

  setUp(() {
    configureInjection();
    repo = getIt();
  });

  test('${objectGenerate.name} repository implementation test', () async {});
}

''';
}
